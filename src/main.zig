const psp = @import("psp/pspsdk.zig");
pub const panic = psp.debug.panic;

comptime {
    _ = psp.module_start_struct;
}

const MyTestErrors = error{
    LolWhatsAnError,
};


fn addOne(x: u8) u8 {
    return x + 1;
}

pub fn main() !void {
    psp.utils.enableHomeButton();
    psp.debug.screenInit();

    _ = addOne(255);

    try psp.debug.printFormat("Hello {}!\n", .{"world"});
}
