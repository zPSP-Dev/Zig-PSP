const psp = @import("../c/modules.zig");
const debug = @import("debug.zig");
var current_time: u64 = 0;
var tickRate: u32 = 0;

//Starts a benchmark
pub fn benchmark_start() void {
    tickRate = psp.sceRtcGetTickResolution();
    _ = psp.sceRtcGetCurrentTick(&current_time);
}

//Ends the benchmark and reports ticks & time
pub fn benchmark_end() !u64 {
    const oldTime = current_time;
    _ = psp.sceRtcGetCurrentTick(&current_time);

    const delta = current_time - oldTime;

    const deltaF = @as(f64, @floatFromInt(delta));
    const tickRF = @as(f32, @floatFromInt(tickRate));

    try debug.printFormat("Method took {} ticks. ({d} ms)\n", .{ delta, deltaF / tickRF * 1000 });

    return delta;
}
