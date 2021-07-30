const std = @import("std");
const expect = std.testing.expect;
const sdl = @import("main.zig");

test {
    try sdl.init(.{ .events = true });
    defer sdl.quit();

    sdl.setEventDisabled(.key_down, true);
    try expect(sdl.isEventDisabled(.key_down));
    sdl.setEventDisabled(.key_down, false);
    try expect(!sdl.isEventDisabled(.key_down));
}

fn event_filter_pass(userdata: ?*c_void, event: *sdl.Event) c_int {
    _ = @ptrCast(*c_void, userdata);
    _ = @ptrCast(*c_void, event);
    return 1;
}

test {
    try sdl.init(.{ .events = true });
    defer sdl.quit();

    const result1 = sdl.getEventFilter();
    try expect(result1 == null);

    var data: i32 = 0;
    sdl.setEventFilter(.{ .func = event_filter_pass, .userdata = &data });

    const result2 = sdl.getEventFilter();
    try expect(result2 != null);
    const result2d = result2.?;
    try expect(result2d.func == event_filter_pass);
    try expect(result2d.userdata == @ptrCast(*c_void, &data));
}
