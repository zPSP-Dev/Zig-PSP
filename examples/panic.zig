//A brief example of PSP Panic Handling

const psp = @import("psp/pspsdk.zig");
pub const panic = psp.debug.panic;

comptime {
    _ = psp.module_start_struct;
}

fn addOne(x: u8) u8 {
    return x + 1;
}

pub fn main() !void {
    //psp.debug.pancakeMode = true;
    psp.utils.enableHomeButton();
    psp.debug.screenInit();

    _ = addOne(255);

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
}
