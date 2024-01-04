import subprocess
import os
from typing import Tuple, List

def download_git_repo(url: str, path: str):
    """Downloads a git repo to a certain path"""
    try: 
        subprocess.run(["git", "clone", url, path])
        print(f"Downloaded {url} to {path}")
    except Exception as e:
        print(f"Error: {e}")

def scan_folder_for_files_with_extension(path: str, extension: str) -> List[str]:
    """Scans a folder for files with a certain extension and returns a list of them"""
    file_list = []

    for root, _, files in os.walk(path):
        for file in files:
            if file.endswith(extension):
                file_list.append(os.path.join(root, file))

    return file_list

def find_import_lines(file: str) -> List[str]:
    """Finds all the import lines in a file"""
    import_lines = []

    with open(file, "r") as f:
        for line in f.readlines():
            # Strip the line of whitespace before and after
            line = line.strip()
            if line.startswith("IMPORT_"):
                # Replace tabs with spaces
                line = line.replace("\t", " ")
                import_lines.append(line)

    # Count the number of IMPORT_START lines
    count = 0
    for line in import_lines:
        if line.startswith("IMPORT_START"):
            count += 1

    # If there is more than one IMPORT_START line, then there is a problem
    assert count == 1

    return import_lines

# Import start 
# mod_name, tag

# Import Function
# mod_name, hash, func_name

# Table:
# mod_name, tag, [hash, func_name]

def make_table(import_lines: Tuple[str, str, List[Tuple[str, str]]]):
    """Makes a table from the import lines"""
    
    # First line is the IMPORT_START line, split by first space
    import_start_line = import_lines[0].split(" ")[1:]
    import_start_line = " ".join(import_start_line)

    # Remove all spaces
    import_start_line = import_start_line.replace(" ", "")

    # Split the line into the mod_name and tag
    mod_name, tag = import_start_line.split(",")

    # Remove the IMPORT_START line
    import_lines = import_lines[1:]

    # Create a list of tuples containing the hash and function name
    hash_func_list = []
    for line in import_lines:
        # Split the line by the first space
        line = line.split(" ")[1:]
        line = " ".join(line)

        # Remove all spaces
        line = line.replace(" ", "")

        # Split the line into the hash and function name
        mod, hash, func_name = line.split(",")

        assert(mod == mod_name)

        hash_func_list.append((hash, func_name))
    
    return mod_name, tag, hash_func_list

def table_to_zig(table: Tuple[str, str, List[Tuple[str, str]]]):
    """Converts a table to zig code"""
    mod_name, tag, hash_func_list = table
    
    zig_src = "\n\ncomptime {\n"

    zig_src += "    asm (macro.import_module_start(" + mod_name + ", \"" + tag + "\", \"" + str(len(hash_func_list)) + "\"));\n"

    for hash, func_name in hash_func_list:
        zig_src += "    asm (macro.import_function(" + mod_name + ", \"" + hash + "\", \"" + func_name + "\"));\n"

    zig_src += "}"

    return zig_src

def main():
    url = "https://github.com/pspdev/pspsdk.git"
    path = "pspsdk"
    download_git_repo(url, path)
    files = scan_folder_for_files_with_extension(path, ".S")
    
    bad_folders = ["src/samples", "src/base", "src/debug", "src/sdk", "src/kernel", "src/vsh", "src/modinfo", "src/fpu"]
    filtered_files = [file for file in files if not any(bad_folder in file for bad_folder in bad_folders)]

    bad_files = ["sceUmd.S"]
    filtered_files = [file for file in filtered_files if not any(bad_file in file for bad_file in bad_files)]

    tables = map(make_table, map(find_import_lines, filtered_files))

    # Remove tables with mod_name that ends in _driver"
    tables = [table for table in tables if not table[0].endswith("_driver\"")]

    zig_src = "\n".join(map(table_to_zig, tables))

    # Remove lines with `const macro = @import("pspmacros.zig");` after the first
    for line in zig_src.split("\n")[2:]:
        if line.startswith("const macro = @import(\"pspmacros.zig\");"):
            zig_src = zig_src.replace(line, "")

    # Remove the pattern "}\n\ncomptime {"
    zig_src = "const macro = @import(\"pspmacros.zig\");" + zig_src.replace("}\n\n\ncomptime {", "")

    # Insert line after first "comptime {"
    zig_src = zig_src.replace("comptime {", "comptime {\n    @setEvalBranchQuota(1000000);\n")

    # Write the zig code to a file
    with open("libzpsp.zig", "w") as f:
        f.write(zig_src)
    
    # Remove directory
    subprocess.run(["rm", "-rf", path])

    # Format the zig code
    subprocess.run(["zig", "fmt", "libzpsp.zig"])

    # Build the zig code
    subprocess.run(["zig", "build"])

if __name__ == "__main__":
    main()