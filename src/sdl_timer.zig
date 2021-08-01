const c = @cImport(@cInclude("SDL.h"));
const std = @import("std");
usingnamespace @import("sdl_general.zig");

/// Get ticks (milliseconds) since SDL library initialization.
pub fn getTicks() u32 {
    return c.SDL_GetTicks();
}

/// Test if `first` has passed `second`.
pub fn ticksPassed(first: u32, second: u32) bool {
    return c.SDL_TICKS_PASSED(first, second) != 0;
}

/// Get high resolution counter value.
pub fn getPerformanceCounter() u64 {
    return c.SDL_GetPerformanceCounter();
}

/// Get the number of counts per second of the  high resolution counter.
pub fn getPerformanceFrequency() u64 {
    return c.SDL_GetPerformanceFrequency();
}

/// The callback is called when `interval` ticks have elapsed.  Return the
/// interval in ticks to the next callback or `0` to cancel the alarm.
pub const TimerCallback = fn (interval: u32, param: ?*c_void) u32;

/// Id of a timer.
pub const TimerId = c_int;

/// Add a timer to be invoked after `interval` ticks.
pub fn addTimer(interval: u32, callback: TimerCallback, param: ?*c_void) !TimerId {
    const id = c.SDL_AddTimer(interval, callback, param);
    if (id == 0) return error.SDL2_Timer;
    return id;
}

/// Remove a timer by its id.
pub fn removeTimer(id: TimerId) !void {
    if (c.SDL_RemoveTimer(id) == 0)
        return error.SDL2_Timer;
}
