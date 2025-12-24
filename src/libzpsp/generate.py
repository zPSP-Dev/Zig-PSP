import os
import shutil
import subprocess
import re
import argparse
from pathlib import Path
from dataclasses import dataclass
from typing import List, Dict, Optional, Tuple
from contextlib import contextmanager

@dataclass
class ImportFunc:
    nid: str
    name: str
    signature: Optional[str] = None  # Store the C function signature
    doc_comment: Optional[str] = None  # Store the C doc comment

@dataclass
class Module:
    name: str
    data_tag: str
    functions: List[ImportFunc]

    def __str__(self):
        return f"Module: {self.name} (Data Tag: {self.data_tag})\n" + \
               f"Functions ({len(self.functions)}):\n" + \
               "\n".join(f"  - {func.name} (NID: {func.nid})" for func in self.functions)

@contextmanager
def temporary_directory(path):
    """Context manager to ensure directory is removed after use."""
    try:
        yield path
    finally:
        if os.path.exists(path):
            shutil.rmtree(path)

def clone_repository(repo_url: str, target_dir: str) -> str:
    """Clone the PSPSDK repository."""
    if os.path.exists(target_dir):
        shutil.rmtree(target_dir)
    subprocess.run(["git", "clone", repo_url, target_dir], check=True)
    return target_dir

def remove_bad_folders(base_dir: str, bad_folders: List[str]):
    """Remove specified folders from the repository."""
    for folder in bad_folders:
        folder_path = os.path.join(base_dir, folder)
        if os.path.exists(folder_path):
            shutil.rmtree(folder_path)

def remove_bad_files(base_dir: str, bad_files: List[str]):
    """Remove specified files from the repository."""
    for file in bad_files:
        for root, _, files in os.walk(base_dir):
            if file in files:
                os.remove(os.path.join(root, file))

def remove_driver_files(base_dir: str):
    """Remove files and folders containing '_driver'."""
    for root, dirs, files in os.walk(base_dir, topdown=False):
        # Remove files containing '_driver'
        for file in files:
            if '_driver' in file:
                os.remove(os.path.join(root, file))

        # Remove directories containing '_driver'
        for dir_name in dirs:
            if '_driver' in dir_name:
                shutil.rmtree(os.path.join(root, dir_name))

def parse_import_start(line: str) -> Optional[tuple[str, str]]:
    """Parse IMPORT_START line and return (module_name, data_tag) or None if not a valid IMPORT_START."""
    match = re.match(r'IMPORT_START\s+"([^"]+)",\s*(0x[0-9a-fA-F]+)', line)
    if match:
        return match.group(1), match.group(2)
    return None

def parse_import_func(line: str) -> Optional[tuple[str, str, str]]:
    """Parse IMPORT_FUNC line and return (module_name, nid, func_name) or None if not a valid IMPORT_FUNC."""
    match = re.match(r'IMPORT_FUNC\s+"([^"]+)",\s*(0x[0-9a-fA-F]+),\s*([^\s]+)', line)
    if match:
        return match.group(1), match.group(2), match.group(3)
    return None

def parse_c_type_to_zig(c_type: str) -> str:
    """Convert C type to Zig type."""
    # Basic type mappings
    type_map = {
        'void': 'void',
        'int': 'c_int',
        'unsigned int': 'c_uint',
        'char': 'c_char',
        'unsigned char': 'u8',
        'short': 'c_short',
        'unsigned short': 'c_ushort',
        'long': 'c_long',
        'unsigned long': 'c_ulong',
        'float': 'f32',
        'double': 'f64',
        'size_t': 'usize',
        'ssize_t': 'isize',
        'uint32_t': 'u32',
        'uint64_t': 'u64',
        'int32_t': 'i32',
        'int64_t': 'i64',
        'uint8_t': 'u8',
        'int8_t': 'i8',
        'uint16_t': 'u16',
        'int16_t': 'i16',
        'u64': 'u64',
        'u32': 'u32',
        'u16': 'u16',
        'u8': 'u8',
        'i64': 'i64',
        'i32': 'i32',
        'i16': 'i16',
        'i8': 'i8',
        # PSP-specific types
        'SceUID': 'SceUID',
        'SceSize': 'SceSize',
        'SceSSize': 'SceSSize',
        'SceUChar': 'SceUChar',
        'SceUInt': 'SceUInt',
        'SceMode': 'SceMode',
        'SceOff': 'SceOff',
        'SceIores': 'SceIores',
        'SceUChar8': 'SceUChar8',
        'SceUShort16': 'SceUShort16',
        'SceUInt32': 'SceUInt32',
        'SceUInt64': 'SceUInt64',
        'SceULong64': 'SceULong64',
        'SceChar8': 'SceChar8',
        'SceShort16': 'SceShort16',
        'SceInt32': 'SceInt32',
        'SceInt64': 'SceInt64',
        'SceLong64': 'SceLong64',
        'SceFloat': 'SceFloat',
        'SceFloat32': 'SceFloat32',
        'SceWChar16': 'SceWChar16',
        'SceWChar32': 'SceWChar32',
        'SceBool': 'SceBool',
        'SceVoid': 'SceVoid',
        'ScePVoid': 'ScePVoid',
    }

    # Handle const first
    is_const = 'const' in c_type
    if is_const:
        base_type = c_type.replace('const', '').strip()
        # Special case for const void*
        if '*' in base_type and base_type.replace('*', '').strip() == 'void':
            return '?*const anyopaque'
        result = parse_c_type_to_zig(base_type)
        if '*' in result:
            # For pointer types, const goes before the pointer
            return result.replace('[*c]', '[*c]const ')
        return result

    # Handle pointers
    if '*' in c_type:
        base_type = c_type.replace('*', '').strip()
        # Special case for void*
        if base_type == 'void':
            return '?*anyopaque'
        return f'[*c]{parse_c_type_to_zig(base_type)}'

    # Handle basic types
    return type_map.get(c_type, 'c_int')  # Default to c_int if unknown

def parse_c_function_signature(line: str) -> Optional[Tuple[str, List[Tuple[str, str]], str]]:
    """Parse C function signature and return (return_type, param_types_and_names, function_name)."""
    # Remove all comments (both single-line and multi-line)
    line = re.sub(r'/\*.*?\*/', '', line, flags=re.DOTALL)  # Remove multi-line comments
    line = re.sub(r'//.*$', '', line)  # Remove single-line comments
    line = line.strip()

    # Split into words while preserving * as part of the type
    words = []
    current_word = ''
    for char in line:
        if char == ' ':
            if current_word:
                words.append(current_word)
                current_word = ''
        elif char == '*':
            if current_word:
                words.append(current_word)
                current_word = ''
            words.append('*')
        elif char == '(':
            if current_word:
                words.append(current_word)
                current_word = ''
            words.append('(')
        elif char == ')':
            if current_word:
                words.append(current_word)
                current_word = ''
            words.append(')')
        else:
            current_word += char
    if current_word:
        words.append(current_word)

    # Find the function name (it's the last word before the opening parenthesis)
    func_name = None
    for i, word in enumerate(words):
        if word == '(':
            if i > 0:
                func_name = words[i-1]
            break

    if not func_name:
        return None

    # Get the return type (everything before the function name)
    return_type = ' '.join(words[:words.index(func_name)])

    # Get the parameters (everything between the parentheses)
    params_start = words.index('(')
    params_end = words.index(')')
    params = ' '.join(words[params_start+1:params_end])

    # Parse parameters
    param_types_and_names = []
    if params.strip() and params.strip() != 'void':
        for param in params.split(','):
            param = param.strip()
            if param:
                # Skip invalid parameters like '?'
                if param == '?':
                    return None

                # Split into words while preserving * as part of the type
                words = []
                current_word = ''
                for char in param:
                    if char == ' ':
                        if current_word:
                            words.append(current_word)
                            current_word = ''
                    elif char == '*':
                        if current_word:
                            words.append(current_word)
                            current_word = ''
                        words.append('*')
                    elif char == ':':
                        # If we have a current word, add it and the colon
                        if current_word:
                            words.append(current_word)
                            current_word = ''
                        words.append(':')
                    else:
                        current_word += char
                if current_word:
                    words.append(current_word)

                # Find the last word that's not a type keyword or modifier
                name = None
                for word in reversed(words):
                    if word not in ['const', 'struct', 'volatile', 'restrict', '*', ':']:
                        name = word
                        break

                if name:
                    # Get all words up to but not including the name
                    type_words = []
                    found_name = False
                    for word in words:
                        if word == name:
                            found_name = True
                        elif not found_name:
                            type_words.append(word)

                    param_type = ' '.join(type_words)
                    param_types_and_names.append((param_type, name))
                else:
                    param_types_and_names.append((param, f"arg{len(param_types_and_names)}"))

    return return_type, param_types_and_names, func_name

def parse_doc_comment(lines: List[str]) -> Optional[str]:
    """Parse C doc comment and convert to Zig format."""
    if not lines:
        return None

    # Remove the /** and */ lines
    lines = lines[1:-1]

    # Process each line
    processed_lines = []
    for i, line in enumerate(lines):
        # Replace tabs with spaces
        line = line.replace('\t', '    ')
        line = line.strip()
        # Remove leading * and spaces
        line = re.sub(r'^\s*\*\s*', '', line)
        # Skip empty lines or lines that are just slashes
        if not line or line in ['/', '/**']:
            continue

        # Handle @code blocks
        if line.startswith('@code'):
            processed_lines.append('`')
            continue
        if line.startswith('@endcode'):
            processed_lines.append('`')
            continue

        # Handle @param
        if line.startswith('@param'):
            param = line[6:].strip()
            # Split on first occurrence of ' - ' to separate name from description
            parts = param.split(' - ', 1)
            if len(parts) == 2:
                name, desc = parts
                processed_lines.append(f"`{name.strip()}` - {desc.strip()}")
            else:
                processed_lines.append(f"`{param}`")
            continue

        # Handle @return
        if line.startswith('@return'):
            ret = line[7:].strip()
            processed_lines.append(f"Returns {ret}")
            continue

        # Regular line
        processed_lines.append(line)

    # Join with /// prefix, adding indentation for all lines except the first
    return '\n'.join(f"/// {line}" if i == 0 else f"    /// {line}" for i, line in enumerate(processed_lines))

def find_function_signature(headers_dir: str, func_name: str) -> Optional[Tuple[str, Optional[str]]]:
    """Search header files for function signature and doc comment."""
    for root, _, files in os.walk(headers_dir):
        for file in files:
            if file.endswith('.h'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r') as f:
                        content = f.read()
                        # First find the function signature
                        lines = content.split('\n')
                        doc_lines = []
                        in_comment = False
                        function_lines = []

                        for i, line in enumerate(lines):
                            # Handle multi-line comments
                            if '/*' in line:
                                in_comment = True
                                continue
                            if '*/' in line:
                                in_comment = False
                                continue
                            if in_comment:
                                continue

                            # Skip single-line comments
                            if line.strip().startswith('//'):
                                continue

                            # If we find the function name, start collecting lines
                            if func_name in line and '(' in line:
                                function_lines = [line]
                                # Look for doc comment before the function
                                j = i - 1
                                while j >= 0 and (lines[j].strip().startswith('*') or lines[j].strip().startswith('/*')):
                                    doc_lines.insert(0, lines[j].strip())
                                    j -= 1
                                if j >= 0 and lines[j].strip() == '/**':
                                    doc_lines.insert(0, lines[j].strip())

                                # If the function declaration spans multiple lines, collect them
                                if '(' in line and ')' not in line:
                                    k = i + 1
                                    while k < len(lines) and ')' not in lines[k]:
                                        if not lines[k].strip().startswith('//'):
                                            function_lines.append(lines[k])
                                        k += 1
                                    if k < len(lines):
                                        function_lines.append(lines[k])

                                # Join the function lines and parse
                                full_declaration = ' '.join(line.strip() for line in function_lines)
                                sig = parse_c_function_signature(full_declaration)
                                if sig and sig[2] == func_name:
                                    return_type, param_types_and_names, _ = sig

                                    # Convert to Zig signature
                                    zig_return = parse_c_type_to_zig(return_type)
                                    if param_types_and_names:
                                        # Check if the last parameter is varargs
                                        if param_types_and_names[-1][1] == '...':
                                            # For varargs, only include the parameters up to ...
                                            zig_params = [f"{name}: {parse_c_type_to_zig(t)}" for t, name in param_types_and_names[:-1]]
                                            signature = f"({', '.join(zig_params)}, ...) {zig_return}"
                                        else:
                                            zig_params = [f"{name}: {parse_c_type_to_zig(t)}" for t, name in param_types_and_names]
                                            signature = f"({', '.join(zig_params)}) {zig_return}"
                                    else:
                                        signature = f"() {zig_return}"

                                    # Parse doc comment if present
                                    doc_comment = parse_doc_comment(doc_lines) if doc_lines else None
                                    return signature, doc_comment
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")
                    continue
    return None

def process_s_files(base_dir: str, verbose: bool = False) -> Dict[str, Module]:
    """Process .S files and build module structure."""
    modules: Dict[str, Module] = {}

    for root, _, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.S'):
                file_path = os.path.join(root, file)
                current_module = None
                import_start_count = 0

                try:
                    with open(file_path, 'r') as f:
                        for line_num, line in enumerate(f, 1):
                            line = line.strip()

                            # Check for IMPORT_START
                            if 'IMPORT_START' in line:
                                import_start_count += 1
                                if import_start_count > 1:
                                    raise ValueError(f"Multiple IMPORT_START found in {file_path}")

                                result = parse_import_start(line)
                                if result:
                                    module_name, data_tag = result
                                    # Skip sceUsbstorBoot module
                                    if module_name == "sceUsbstorBoot":
                                        continue
                                    if module_name in modules:
                                        raise ValueError(f"Module {module_name} already defined in another file")
                                    modules[module_name] = Module(module_name, data_tag, [])
                                    current_module = module_name
                                else:
                                    raise ValueError(f"Invalid IMPORT_START format in {file_path}:{line_num}")

                            # Check for IMPORT_FUNC
                            elif 'IMPORT_FUNC' in line and current_module:
                                result = parse_import_func(line)
                                if result:
                                    module_name, nid, func_name = result
                                    if module_name != current_module:
                                        raise ValueError(f"IMPORT_FUNC module name mismatch in {file_path}:{line_num}")
                                    modules[current_module].functions.append(ImportFunc(nid, func_name))
                                else:
                                    raise ValueError(f"Invalid IMPORT_FUNC format in {file_path}:{line_num}")

                except Exception as e:
                    print(f"Error processing {file_path}: {e}")
                    continue

    # Find function signatures in header files
    for module in modules.values():
        for func in module.functions:
            result = find_function_signature(base_dir, func.name)
            if result:
                func.signature, func.doc_comment = result

    if verbose:
        print("\nModule Diagnostic Information:")
        print("=" * 50)
        for module in modules.values():
            print(module)
            print("-" * 50)

    return modules

def generate_zig_file(modules: Dict[str, Module], output_path: str):
    """Generate the Zig source file from the module data."""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with open(output_path, 'w') as f:
        # Write header
        f.write('const macro = @import("pspmacros.zig");\n')
        f.write('const options = @import("libzpsp_option");\n\n')

        # Write comptime block
        f.write('comptime {\n')
        f.write('    @setEvalBranchQuota(1000000);\n\n')

        # Write module declarations
        for module in modules.values():
            f.write(f'    if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "{module.name}") and options.{module.name})) {{\n')
            f.write(f'        asm(macro.import_module_start("{module.name}", "{module.data_tag}", "{len(module.functions)}"));\n')
            # Add function declarations
            for func in module.functions:
                if func.signature:
                    # Count the number of arguments by counting commas in the parameters
                    params = func.signature.split('(')[1].split(')')[0]
                    arg_count = params.count(',') + 1 if params and params != '...' else 0
                    if arg_count > 4:
                        # For functions with more than 4 arguments, create _stub and wrapper
                        f.write(f'        asm(macro.import_function("{module.name}", "{func.nid}", "{func.name}_stub"));\n')
                        f.write(f'        asm(macro.generic_abi_wrapper("{func.name}", {arg_count}));\n')
                    else:
                        # For functions with 4 or fewer arguments, just import normally
                        f.write(f'        asm(macro.import_function("{module.name}", "{func.nid}", "{func.name}"));\n')
                else:
                    # If no signature, assume no arguments and import normally
                    f.write(f'        asm(macro.import_function("{module.name}", "{func.nid}", "{func.name}"));\n')
            f.write('    }\n\n')

        f.write('}\n')

def generate_pspsdk_file(modules: Dict[str, Module], output_path: str):
    """Generate the Zig source file containing extern function declarations."""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with open(output_path, 'w') as f:
        # Write header
        f.write('const options = @import("libzpsp_option");\n')
        f.write('const types = @import("psptypes.zig");\n\n')

        # Write PSP type definitions
        f.write('pub const SceUID = types.SceUID;\n')
        f.write('pub const SceSize = types.SceSize;\n')
        f.write('pub const SceSSize = types.SceSSize;\n')
        f.write('pub const SceUChar = types.SceUChar;\n')
        f.write('pub const SceUInt = types.SceUInt;\n')
        f.write('pub const SceMode = types.SceMode;\n')
        f.write('pub const SceOff = types.SceOff;\n')
        f.write('pub const SceIores = types.SceIores;\n')
        f.write('pub const SceUChar8 = types.SceUChar8;\n')
        f.write('pub const SceUShort16 = types.SceUShort16;\n')
        f.write('pub const SceUInt32 = types.SceUInt32;\n')
        f.write('pub const SceUInt64 = types.SceUInt64;\n')
        f.write('pub const SceULong64 = types.SceULong64;\n')
        f.write('pub const SceChar8 = types.SceChar8;\n')
        f.write('pub const SceShort16 = types.SceShort16;\n')
        f.write('pub const SceInt32 = types.SceInt32;\n')
        f.write('pub const SceInt64 = types.SceInt64;\n')
        f.write('pub const SceLong64 = types.SceLong64;\n')
        f.write('pub const SceFloat = types.SceFloat;\n')
        f.write('pub const SceFloat32 = types.SceFloat32;\n')
        f.write('pub const SceWChar16 = types.SceWChar16;\n')
        f.write('pub const SceWChar32 = types.SceWChar32;\n')
        f.write('pub const SceBool = types.SceBool;\n')
        f.write('pub const SceVoid = types.SceVoid;\n')
        f.write('pub const ScePVoid = types.ScePVoid;\n\n')

        # Write PSP-specific types
        f.write('pub const ScePspSRect = types.ScePspSRect;\n')
        f.write('pub const ScePspIRect = types.ScePspIRect;\n')
        f.write('pub const ScePspL64Rect = types.ScePspL64Rect;\n')
        f.write('pub const ScePspFRect = types.ScePspFRect;\n')
        f.write('pub const ScePspSVector2 = types.ScePspSVector2;\n')
        f.write('pub const ScePspIVector2 = types.ScePspIVector2;\n')
        f.write('pub const ScePspL64Vector2 = types.ScePspL64Vector2;\n')
        f.write('pub const ScePspFVector2 = types.ScePspFVector2;\n')
        f.write('pub const ScePspVector2 = types.ScePspVector2;\n')
        f.write('pub const ScePspSVector3 = types.ScePspSVector3;\n')
        f.write('pub const ScePspIVector3 = types.ScePspIVector3;\n')
        f.write('pub const ScePspL64Vector3 = types.ScePspL64Vector3;\n')
        f.write('pub const ScePspFVector3 = types.ScePspFVector3;\n')
        f.write('pub const ScePspVector3 = types.ScePspVector3;\n')
        f.write('pub const ScePspSVector4 = types.ScePspSVector4;\n')
        f.write('pub const ScePspIVector4 = types.ScePspIVector4;\n')
        f.write('pub const ScePspL64Vector4 = types.ScePspL64Vector4;\n')
        f.write('pub const ScePspFVector4 = types.ScePspFVector4;\n')
        f.write('pub const ScePspFVector4Unaligned = types.ScePspFVector4Unaligned;\n')
        f.write('pub const ScePspVector4 = types.ScePspVector4;\n')
        f.write('pub const ScePspIMatrix2 = types.ScePspIMatrix2;\n')
        f.write('pub const ScePspFMatrix2 = types.ScePspFMatrix2;\n')
        f.write('pub const ScePspMatrix2 = types.ScePspMatrix2;\n')
        f.write('pub const ScePspIMatrix3 = types.ScePspIMatrix3;\n')
        f.write('pub const ScePspFMatrix3 = types.ScePspFMatrix3;\n')
        f.write('pub const ScePspMatrix3 = types.ScePspMatrix3;\n')
        f.write('pub const ScePspIMatrix4 = types.ScePspIMatrix4;\n')
        f.write('pub const ScePspIMatrix4Unaligned = types.ScePspIMatrix4Unaligned;\n')
        f.write('pub const ScePspFMatrix4 = types.ScePspFMatrix4;\n')
        f.write('pub const ScePspFMatrix4Unaligned = types.ScePspFMatrix4Unaligned;\n')
        f.write('pub const ScePspMatrix4 = types.ScePspMatrix4;\n')
        f.write('pub const ScePspFQuaternion = types.ScePspFQuaternion;\n')
        f.write('pub const ScePspFQuaternionUnaligned = types.ScePspFQuaternionUnaligned;\n')
        f.write('pub const ScePspFColor = types.ScePspFColor;\n')
        f.write('pub const ScePspFColorUnaligned = types.ScePspFColorUnaligned;\n')
        f.write('pub const ScePspRGBA8888 = types.ScePspRGBA8888;\n')
        f.write('pub const ScePspRGBA4444 = types.ScePspRGBA4444;\n')
        f.write('pub const ScePspRGBA5551 = types.ScePspRGBA5551;\n')
        f.write('pub const ScePspRGB565 = types.ScePspRGB565;\n')
        f.write('pub const ScePspUnion32 = types.ScePspUnion32;\n')
        f.write('pub const ScePspUnion64 = types.ScePspUnion64;\n')
        f.write('pub const ScePspUnion128 = types.ScePspUnion128;\n')
        f.write('pub const ScePspDateTime = types.ScePspDateTime;\n\n')

        # Write EMPTY struct definition
        f.write('const EMPTY = struct {};\n\n')

        # Write module declarations
        for module in modules.values():
            # Write module externs struct
            f.write(f'const {module.name} = struct {{\n')
            for func in module.functions:
                if func.doc_comment:
                    f.write(f'    {func.doc_comment}\n')
                if func.signature:
                    # Split the signature into parameters and return type
                    params, ret_type = func.signature.split(') ')
                    f.write(f'    pub extern fn {func.name}{params}) callconv(.C) {ret_type};\n\n')
                else:
                    f.write(f'    pub extern fn {func.name}() callconv(.C) void;\n\n')
            f.write('};\n\n')

            # Write usingnamespace declaration
            f.write(f'pub usingnamespace if ((@hasDecl(options, "everything") and options.everything) or (@hasDecl(options, "{module.name}") and options.{module.name})) {module.name} else EMPTY;\n\n')

def generate_options_file(modules: Dict[str, Module], output_path: str):
    """Generate the options.zig file containing build options for each module."""
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    with open(output_path, 'w') as f:
        # Write header
        f.write('const std = @import("std");\n\n')

        # Write the options struct
        f.write('pub const Options = struct {\n')
        f.write('    everything: bool = false,\n')
        for module in modules.values():
            f.write(f'    {module.name}: bool = false,\n')
        f.write('};\n\n')

        # Write the addOptions function
        f.write('pub fn addOptions(b: *std.Build, options: Options) *std.Build.Step.Options {\n')
        f.write('    const step_options = b.addOptions();\n\n')

        # Add "everything" option
        f.write('    step_options.addOption(bool, "everything", options.everything);\n\n')

        # Add options for each module
        for module in modules.values():
            f.write(f'    step_options.addOption(bool, "{module.name}", options.{module.name});\n')

        f.write('\n    return step_options;\n')
        f.write('}\n')

def main():
    parser = argparse.ArgumentParser(description='Generate Zig bindings for PSPSDK')
    parser.add_argument('--repo-url', default='https://github.com/pspdev/pspsdk.git',
                      help='URL of the PSPSDK repository')
    parser.add_argument('--verbose', '-v', action='store_true',
                      help='Enable verbose output')
    parser.add_argument('--output-dir', default='src',
                      help='Output directory for the generated Zig files')
    args = parser.parse_args()

    # Configuration
    target_dir = "pspsdk"
    bad_folders = ["src/samples", "src/base", "src/debug", "src/sdk",
                   "src/kernel", "src/vsh", "src/modinfo", "src/fpu", "src/video", "src/sircs", "tools"]
    bad_files = ["sceUmd.S"]

    with temporary_directory(target_dir):
        # Clone repository
        print("Cloning repository...")
        base_dir = clone_repository(args.repo_url, target_dir)

        # Remove bad folders
        print("Removing bad folders...")
        remove_bad_folders(base_dir, bad_folders)

        # Remove bad files
        print("Removing bad files...")
        remove_bad_files(base_dir, bad_files)

        # Remove driver files and folders
        print("Removing driver files and folders...")
        remove_driver_files(base_dir)

        # Process .S files
        print("\nProcessing .S files for IMPORT_* lines:")
        modules = process_s_files(base_dir, args.verbose)

        # Generate Zig files
        print(f"\nGenerating Zig files in {args.output_dir}...")
        generate_zig_file(modules, os.path.join(args.output_dir, 'libzpsp.zig'))
        generate_pspsdk_file(modules, os.path.join(args.output_dir, 'pspsdk.zig'))
        generate_options_file(modules, os.path.join(args.output_dir, 'options.zig'))
        print("Done!")

if __name__ == "__main__":
    main()
