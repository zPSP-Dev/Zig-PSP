    .module hardfloat
    .set noreorder
    .set nomacro

    .text
    .align 2
    .globl mips_div_mod_u32
    .ent mips_div_mod_u32

# u32 mips_div_mod_u32(u32 dividend, u32 divisor, u32 *residue_ptr)
# Arguments:
#   a0 = dividend
#   a1 = divisor
#   a2 = pointer to u32 where remainder will be stored
# Returns:
#   v0 = quotient

mips_div_mod_u32:
    # Perform unsigned divide
    divu    $a0, $a1        # dividend / divisor

    # Move quotient and remainder
    mflo    $v0             # quotient -> v0
    mfhi    $t0             # remainder -> t0

    # Store remainder into *residue_ptr
    sw      $t0, 0($a2)

    jr      $ra
    nop

    .end mips_div_mod_u32