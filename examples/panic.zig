//A brief example of PSP Panic Handling

const psp = @import("psp/utils/psp.zig");
pub const panic = psp.debug.panic;

comptime {
    asm(psp.module_info("Zig PSP App", 0, 1, 0));
}

fn addOne(x: u8) u8 {
    return x + 1;
}

pub fn main() !void {
    //psp.debug.pancakeMode = true;
    psp.utils.enableHBCB();
    psp.debug.screenInit();

    _ = addOne(255);

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
}
