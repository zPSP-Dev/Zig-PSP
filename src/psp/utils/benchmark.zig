usingnamespace @import("../include/psprtc.zig");

var current_time: u64 = 0;
var tickRate: u32 = 0;

//Starts a benchmark
pub fn benchmark_start() void {
    tickRate = sceRtcGetTickResolution();
    _ = sceRtcGetCurrentTick(&current_time);
}

//Ends the benchmark and reports ticks & time
pub fn benchmark_end() !u64 {
    var oldTime = current_time;
    _ = sceRtcGetCurrentTick(&current_time);

    var delta = current_time - oldTime;

    var deltaF = @as(f64, @floatFromInt(delta));
    var tickRF = @as(f32, @floatFromInt(tickRate));

    try printFormat("Method took {} ticks. ({d} ms)\n", .{ delta, deltaF / tickRF * 1000 });

    return delta;
}
