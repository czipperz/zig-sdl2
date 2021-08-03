const std = @import("std");
const c = @import("sdl_c.zig");
pub usingnamespace @import("sdl_keycode.zig");
pub usingnamespace @import("sdl_scancode.zig");

pub const Keysym = extern struct {
    /// Physical key code.
    scancode: Scancode,
    /// Virtual key code.
    sym: Keycode,
    /// Current key modifiers.
    mod: u16,
    unused: u32,
};

comptime { std.debug.assert(@sizeOf(Keysym) == @sizeOf(c.SDL_Keysym)); }
