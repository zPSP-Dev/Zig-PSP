#!/usr/bin/env python3
"""Decode PSP GE display list binary dumps into human-readable commands."""
import struct, sys

# GE command names (subset — covers the common ones)
CMD_NAMES = {
    0x00: "NOP", 0x01: "VADDR", 0x02: "IADDR", 0x03: "---", 0x04: "PRIM",
    0x05: "BEZIER", 0x06: "SPLINE", 0x07: "BBOX", 0x08: "JUMP", 0x09: "BJUMP",
    0x0A: "CALL", 0x0B: "RET", 0x0C: "END", 0x0D: "---", 0x0E: "SIGNAL",
    0x0F: "FINISH", 0x10: "BASE", 0x11: "---", 0x12: "VTYPE",
    0x13: "OFFSET_ADDR", 0x14: "ORIGIN_ADDR", 0x15: "REGION1", 0x16: "REGION2",
    0x17: "LTE", 0x18: "LTE0", 0x19: "LTE1", 0x1A: "LTE2", 0x1B: "LTE3",
    0x1C: "CPE", 0x1D: "BCE", 0x1E: "TME", 0x1F: "FGE",
    0x20: "DTE", 0x21: "ABE", 0x22: "ATE", 0x23: "ZTE",
    0x24: "STE", 0x25: "AAE", 0x26: "PCE", 0x27: "CTE",
    0x28: "LOE",
    0x2A: "BONEN", 0x2B: "BONEP", 0x2C: "MORPHW0", 0x2D: "MORPHW1",
    0x2E: "MORPHW2", 0x2F: "MORPHW3", 0x30: "MORPHW4", 0x31: "MORPHW5",
    0x32: "MORPHW6", 0x33: "MORPHW7",
    0x36: "PATCH_DIV", 0x37: "PATCH_PRIM", 0x38: "PATCH_FACING",
    0x3A: "WORLD_START", 0x3B: "WORLD_DATA",
    0x3C: "VIEW_START", 0x3D: "VIEW_DATA",
    0x3E: "PROJ_START", 0x3F: "PROJ_DATA",
    0x40: "TGEN_START", 0x41: "TGEN_DATA",
    0x42: "VIEWPORT_SX", 0x43: "VIEWPORT_SY", 0x44: "VIEWPORT_SZ",
    0x45: "VIEWPORT_CX", 0x46: "VIEWPORT_CY", 0x47: "VIEWPORT_CZ",
    0x48: "TEX_SCALE_U", 0x49: "TEX_SCALE_V",
    0x4A: "TEX_OFFSET_U", 0x4B: "TEX_OFFSET_V",
    0x4C: "SCREEN_OFFSET_X", 0x4D: "SCREEN_OFFSET_Y",
    0x50: "SHADE_MODE", 0x51: "REV_NORM",
    0x53: "COLOR_MAT", 0x54: "EMC", 0x55: "AMC", 0x56: "DMC",
    0x57: "SMC", 0x58: "AMA", 0x5B: "SPOW",
    0x5C: "ALC", 0x5D: "ALA", 0x5E: "LMODE", 0x5F: "LTYPE0",
    0x60: "LTYPE1", 0x61: "LTYPE2", 0x62: "LTYPE3",
    0x63: "LX0", 0x64: "LY0", 0x65: "LZ0",
    0x66: "LX1", 0x67: "LY1", 0x68: "LZ1",
    0x69: "LX2", 0x6A: "LY2", 0x6B: "LZ2",
    0x6C: "LX3", 0x6D: "LY3", 0x6E: "LZ3",
    0x6F: "LD0_0", 0x70: "LD0_1", 0x71: "LD0_2",
    0x72: "LD1_0", 0x73: "LD1_1", 0x74: "LD1_2",
    0x75: "LD2_0", 0x76: "LD2_1", 0x77: "LD2_2",
    0x78: "LD3_0", 0x79: "LD3_1", 0x7A: "LD3_2",
    0x7B: "LC0_AMB", 0x7C: "LC0_DIF", 0x7D: "LC0_SPC",
    0x7E: "LC1_AMB", 0x7F: "LC1_DIF", 0x80: "LC1_SPC",
    0x81: "LC2_AMB", 0x82: "LC2_DIF", 0x83: "LC2_SPC",
    0x84: "LC3_AMB", 0x85: "LC3_DIF", 0x86: "LC3_SPC",
    0x87: "CULL", 0x88: "FBP", 0x89: "FBW",
    0x8A: "ZBP", 0x8B: "ZBW",
    0x8C: "TBP0", 0x8D: "TBP1", 0x8E: "TBP2", 0x8F: "TBP3",
    0x90: "TBP4", 0x91: "TBP5", 0x92: "TBP6", 0x93: "TBP7",
    0x94: "TBW0", 0x95: "TBW1", 0x96: "TBW2", 0x97: "TBW3",
    0x98: "TBW4", 0x99: "TBW5", 0x9A: "TBW6", 0x9B: "TBW7",
    0x9C: "CBP", 0x9D: "CBPH",
    0x9E: "TRXSBP", 0x9F: "TRXSBW", 0xA0: "TRXDBP", 0xA1: "TRXDBW",
    0xA2: "TRXSIZE", 0xA3: "TRXPOS", 0xA4: "TRXKICK", 0xA5: "TRXSPOS", 0xA6: "TRXDPOS",
    0xA7: "TEX_SIZE0", 0xA8: "TEX_SIZE1", 0xA9: "TEX_SIZE2", 0xAA: "TEX_SIZE3",
    0xAB: "TEX_SIZE4", 0xAC: "TEX_SIZE5", 0xAD: "TEX_SIZE6", 0xAE: "TEX_SIZE7",
    0xAF: "TMAP", 0xB0: "TEX_SHADE",
    0xB1: "TEX_MODE", 0xB2: "TEX_FORMAT", 0xB3: "LOAD_CLUT",
    0xB4: "CLUT_MODE", 0xB5: "TEX_FILTER", 0xB6: "TEX_WRAP",
    0xB7: "TEX_LEVEL", 0xB8: "TEX_FUNC", 0xB9: "TEX_ENV_COLOR",
    0xBA: "TEX_FLUSH", 0xBB: "TEX_SYNC",
    0xBC: "FOG1", 0xBD: "FOG2", 0xBE: "FOG_COLOR",
    0xBF: "TEX_SLOPE", 0xC0: "PSM", 0xC1: "CLEAR_MODE",
    0xC2: "SCISSOR1", 0xC3: "SCISSOR2",
    0xC4: "MIN_Z", 0xC5: "MAX_Z",
    0xC6: "COLOR_TEST", 0xC7: "COLOR_REF", 0xC8: "COLOR_MASK_FUNC",
    0xC9: "ALPHA_TEST", 0xCA: "STENCIL_TEST", 0xCB: "STENCIL_OP",
    0xCC: "DEPTH_TEST", 0xCD: "BLEND_FUNC", 0xCE: "BLEND_FIX_A", 0xCF: "BLEND_FIX_B",
    0xD0: "DITH0", 0xD1: "DITH1", 0xD2: "DITH2", 0xD3: "DITH3",
    0xD4: "LOG_OP", 0xD5: "Z_MASK", 0xD6: "MASK_RGB", 0xD7: "MASK_ALPHA",
    0xD8: "XFER_SRC", 0xD9: "XFER_DST", 0xDA: "XFER_SRC_STRIDE",
    0xDB: "XFER_DST_STRIDE", 0xDC: "XFER_SRC_POS", 0xDD: "XFER_DST_POS",
    0xDE: "XFER_SIZE",
}

# Commands whose 24-bit arg is actually a float (top 24 bits of IEEE 754)
FLOAT_CMDS = {
    0x3B, 0x3D, 0x3F, 0x41,  # matrix data (world/view/proj/tgen)
    0x42, 0x43, 0x44, 0x45, 0x46, 0x47,  # viewport
    0x48, 0x49, 0x4A, 0x4B,  # tex scale/offset
    0x5B,  # specular power
    0xBC, 0xBD,  # fog
    0xBF,  # tex slope
    0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33,  # morph weights
    0x63, 0x64, 0x65, 0x66, 0x67, 0x68,  # light pos 0-1
    0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E,  # light pos 2-3
    0x6F, 0x70, 0x71, 0x72, 0x73, 0x74,  # light dir 0-1
    0x75, 0x76, 0x77, 0x78, 0x79, 0x7A,  # light dir 2-3
}

PRIM_NAMES = {0: "POINTS", 1: "LINES", 2: "LINE_STRIP", 3: "TRIANGLES",
              4: "TRI_STRIP", 5: "TRI_FAN", 6: "SPRITES"}

def decode_f24(val):
    """Decode a 24-bit float (top 24 bits of IEEE 754 float32)."""
    bits = val << 8
    return struct.unpack('f', struct.pack('I', bits))[0]

def decode_vtype(v):
    parts = []
    tex = v & 3
    if tex: parts.append(f"tex={'8b,16b,32f'[tex-1]}")
    col = (v >> 2) & 7
    col_names = {0:"none",1:"?1",2:"?2",3:"?3",4:"5650",5:"5551",6:"4444",7:"8888"}
    if col: parts.append(f"col={col_names.get(col,str(col))}")
    nrm = (v >> 5) & 3
    if nrm: parts.append(f"nrm={'8b,16b,32f'[nrm-1]}")
    vtx = (v >> 7) & 3
    if vtx: parts.append(f"vtx={'8b,16b,32f'[vtx-1]}")
    wt = (v >> 9) & 3
    if wt: parts.append(f"wt={'8b,16b,32f'[wt-1]}")
    idx = (v >> 11) & 3
    if idx: parts.append(f"idx={'8b,16b'[idx-1]}")
    nw = (v >> 14) & 7
    if nw: parts.append(f"nwt={nw+1}")
    nv = (v >> 18) & 7
    if nv: parts.append(f"nvtx={nv+1}")
    if v & (1 << 23): parts.append("2D")
    return ",".join(parts) if parts else "empty"

def decode_cmd(idx, cmd_byte, arg):
    name = CMD_NAMES.get(cmd_byte, f"CMD_{cmd_byte:02X}")
    extra = ""

    if cmd_byte in FLOAT_CMDS:
        fval = decode_f24(arg)
        extra = f"  = {fval:.6g}"
    elif cmd_byte == 0x12:  # VTYPE
        extra = f"  [{decode_vtype(arg)}]"
    elif cmd_byte == 0x04:  # PRIM
        ptype = (arg >> 16) & 7
        count = arg & 0xFFFF
        extra = f"  {PRIM_NAMES.get(ptype, str(ptype))} count={count}"
    elif cmd_byte == 0x01:  # VADDR
        extra = f"  addr=0x{arg:06X}"
    elif cmd_byte == 0x02:  # IADDR
        extra = f"  addr=0x{arg:06X}"
    elif cmd_byte == 0x10:  # BASE
        extra = f"  base=0x{arg:06X}"
    elif cmd_byte == 0x88:  # FBP
        extra = f"  addr=0x{arg:06X}"
    elif cmd_byte == 0x89:  # FBW
        extra = f"  stride={arg & 0xFFFF} hi=0x{(arg >> 16) & 0xFF:02X}"
    elif cmd_byte == 0x8A:  # ZBP
        extra = f"  addr=0x{arg:06X}"
    elif cmd_byte == 0x8B:  # ZBW
        extra = f"  stride={arg & 0xFFFF} hi=0x{(arg >> 16) & 0xFF:02X}"
    elif cmd_byte == 0x8C:  # TBP0
        extra = f"  addr=0x{arg:06X}"
    elif cmd_byte == 0xCC:  # DEPTH_TEST
        funcs = {0:"NEVER",1:"ALWAYS",2:"EQ",3:"NEQ",4:"LT",5:"LEQUAL",6:"GT",7:"GEQUAL"}
        extra = f"  func={funcs.get(arg, str(arg))}"
    elif cmd_byte == 0xC1:  # CLEAR_MODE
        extra = f"  flags=0x{arg:06X}"
    elif cmd_byte == 0x87:  # CULL
        extra = f"  {'CW' if arg else 'CCW'}"
    elif cmd_byte == 0x50:  # SHADE
        extra = f"  {'SMOOTH' if arg else 'FLAT'}"
    elif cmd_byte == 0xC0:  # PSM
        psm_names = {0:"5650",1:"5551",2:"4444",3:"8888"}
        extra = f"  {psm_names.get(arg, str(arg))}"
    elif cmd_byte in (0x15, 0x16):  # REGION
        x = arg & 0x3FF
        y = (arg >> 10) & 0x3FF
        extra = f"  ({x},{y})"
    elif cmd_byte in (0xC2, 0xC3):  # SCISSOR
        x = arg & 0x3FF
        y = (arg >> 10) & 0x3FF
        extra = f"  ({x},{y})"
    elif cmd_byte in (0xC4, 0xC5):  # MIN_Z/MAX_Z
        extra = f"  z={arg}"
    elif cmd_byte == 0xB8:  # TEX_FUNC
        funcs = {0:"MODULATE",1:"DECAL",2:"BLEND",3:"REPLACE",4:"ADD"}
        f_idx = arg & 7
        rgba = "RGBA" if (arg >> 8) & 1 else "RGB"
        extra = f"  {funcs.get(f_idx, str(f_idx))} {rgba}"
    elif cmd_byte == 0xB5:  # TEX_FILTER
        filters = {0:"NEAREST",1:"LINEAR",4:"NEAREST_MIPMAP_NEAREST",
                   5:"LINEAR_MIPMAP_NEAREST",6:"NEAREST_MIPMAP_LINEAR",7:"LINEAR_MIPMAP_LINEAR"}
        mag = arg & 7
        minn = (arg >> 8) & 7
        extra = f"  min={filters.get(minn,str(minn))} mag={filters.get(mag,str(mag))}"
    elif cmd_byte == 0x5C:  # ALC (ambient light color)
        extra = f"  rgb=0x{arg:06X}"
    elif cmd_byte == 0x58:  # AMA (ambient alpha)
        extra = f"  a=0x{arg:06X}"

    return f"  {idx:4d}: {cmd_byte:02X} {arg:06X}  {name:<18s}{extra}"

def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <dl.bin> [dl2.bin]")
        sys.exit(1)

    for path in sys.argv[1:]:
        print(f"\n{'='*60}")
        print(f"  {path}")
        print(f"{'='*60}")
        with open(path, 'rb') as f:
            data = f.read()
        count = len(data) // 4
        for i in range(count):
            word = struct.unpack_from('<I', data, i * 4)[0]
            cmd_byte = (word >> 24) & 0xFF
            arg = word & 0xFFFFFF
            print(decode_cmd(i, cmd_byte, arg))

if __name__ == '__main__':
    main()
