const c = @cImport(@cInclude("SDL.h"));
const std = @import("std");
usingnamespace @import("sdl_general.zig");

/// The display mode.
pub const Mode = c.SDL_DisplayMode;

/// The index of a display.
pub const DisplayIndex = usize;

/// Get the number of available video displays.
pub fn getNum() Error!DisplayIndex {
    const result = c.SDL_GetNumVideoDisplays();
    if (result < 0) return error.SDL2_Video;
    return @intCast(DisplayIndex, result);
}

/// Get the name of the display at the given index or `null` if out of bounds.
pub fn getName(display_index: DisplayIndex) ?[*:0]const u8 {
    std.debug.assert(display_index < (getNum() catch unreachable));
    return c.SDL_GetDisplayName(display_index);
}

/// Get the desktop area represented by a display, or `null` if out of bounds.
/// The primary display will be located at 0, 0.
pub fn getBounds(display_index: DisplayIndex) ?Rect {
    var result: Rect = undefined;
    if (c.SDL_GetDisplayBounds(display_index, @ptrCast(*c.SDL_Rect, &result)) < 0) return null;
    return result;
}

/// Get the usable desktop area represented by a display, or `null` if out of bounds.
/// The primary display will be located at 0, 0.
/// A window cannot be placed outside the usable area with the exception of when it is fullscreen.
pub fn getUsableBounds(display_index: DisplayIndex) ?Rect {
    var result: Rect = undefined;
    if (c.SDL_GetDisplayUsableBounds(display_index, @ptrCast(*c.SDL_Rect, &result)) < 0) return null;
    return result;
}

pub const Dpi = struct {
    diagonal: f32,
    horizontal: f32,
    vertical: f32,
};

/// Get the dots/pixels-per-inch for a display, or `null` if out of bounds or not supported.
pub fn getDPI(display_index: DisplayIndex) ?Dpi {
    var ddpi: c_float = undefined;
    var hdpi: c_float = undefined;
    var vdpi: c_float = undefined;
    if (c.SDL_GetDisplayDPI(display_index, &ddpi, &hdpi, &vdpi) < 0) return null;
    return .{ .diagonal = ddpi, .horizontal = hdpi, .vertical = vdpi };
}

/// Get the orientation of a display, or `null` if out of bounds or not supported.
pub fn getOrientation(display_index: DisplayIndex) ?DisplayOrientation {
    const result = c.SDL_GetDisplayOrientation(display_index);
    if (result == c.SDL_ORIENTATION_UNKNOWN) return null;
    return result;
}

/// Return the number of available display modes, or `null` if out of bounds.
pub fn getNumModes(display_index: DisplayIndex) ?usize {
    const result = c.SDL_GetNumDisplayModes(display_index);
    if (result < 0) return null;
    return @intCast(DisplayIndex, result);
}

/// Get a display mode, or `null` if out of bounds.
pub fn getMode(display_index: DisplayIndex, mode: usize) ?Mode {
    var result: Mode = undefined;
    if (c.SDL_GetDisplayMode(display_index, mode, &result) < 0) return null;
    return result;
}

/// Get the desktop mode of a display, or `null` if out of bounds.
pub fn getDesktopMode(display_index: DisplayIndex) ?Mode {
    var result: Mode = undefined;
    if (c.SDL_GetDesktopDisplayMode(display_index, &result) < 0) return null;
    return result;
}

/// Get the current mode of a display, or `null` if out of bounds.
pub fn getCurrentMode(display_index: DisplayIndex) ?Mode {
    var result: Mode = undefined;
    if (c.SDL_GetCurrentDisplayMode(display_index, &result) < 0) return null;
    return result;
}

/// Find the closest mode to a given mode for a display,
/// or `null` if either out of bounds or all available modes are too small.
pub fn getClosestMode(display_index: DisplayIndex, mode: Mode) ?Mode {
    var result: Mode = undefined;
    if (c.SDL_GetClosestDisplayMode(display_index, mode, &result) == null) return null;
    return result;
}

/// Get the display index associated with a window, or `null` on error.
pub fn getWindowDisplayIndex(window: *Window) ?DisplayIndex {
    const result = c.SDL_GetWindowDisplayIndex(window);
    if (result < 0) return null;
    return @intCast(DisplayIndex, result);
}

/// Set the display mode used when a fullscreen window is visible.
/// If no mode is passed then the default mode is used.
pub fn setWindowDisplayMode(window: *Window, mode: ?Mode) Error!void {
    if (c.SDL_SetWindowDisplayMode(window, &mode) < 0)
        return error.SDL2_Video;
}

/// Get the display mode used when a fullscreen window is visible.
pub fn getWindowDisplayMode(window: *Window) Error!Mode {
    var result: Mode = undefined;
    if (c.SDL_GetWindowDisplayMode(window, &result) < 0) return error.SDL2_Video;
    return result;
}
