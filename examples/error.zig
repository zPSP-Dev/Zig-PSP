// Demonstrates main() returning an error, exercising the panic handler.

const sdk = @import("pspsdk");

pub const panic = sdk.extra.debug.panic;

comptime {
    asm (sdk.extra.module.module_info("SDK Error", .{ .mode = .User }, 1, 0));
}

const MyTestErrors = error{
    TestError,
};

pub fn main() !void {
    sdk.extra.utils.enableHBCB();
    sdk.extra.debug.screenInit();

    sdk.extra.debug.print("Hello world!\n");

    return MyTestErrors.TestError;
}
