const std = @import("std");
const c = @import("sdl_c.zig");
usingnamespace @import("sdl_general.zig");
usingnamespace @import("sdl_video.zig");
usingnamespace @import("sdl_rect.zig");

pub const Cursor = c.SDL_Cursor;

pub const SystemCursor = enum(u32) {
    /// Arrow
    arrow     = SDL_SYSTEM_CURSOR_ARROW,
    /// I-beam
    ibeam     = SDL_SYSTEM_CURSOR_IBEAM,
    /// Wait
    wait      = SDL_SYSTEM_CURSOR_WAIT,
    /// Crosshair
    crosshair = SDL_SYSTEM_CURSOR_CROSSHAIR,
    /// Small wait cursor (or Wait if not available)
    waitarrow = SDL_SYSTEM_CURSOR_WAITARROW,
    /// Double arrow pointing northwest and southeast
    sizenwse  = SDL_SYSTEM_CURSOR_SIZENWSE,
    /// Double arrow pointing northeast and southwest
    sizenesw  = SDL_SYSTEM_CURSOR_SIZENESW,
    /// Double arrow pointing west and east
    sizewe    = SDL_SYSTEM_CURSOR_SIZEWE,
    /// Double arrow pointing north and south
    sizens    = SDL_SYSTEM_CURSOR_SIZENS,
    /// Four pointed arrow pointing north, south, east, and west
    sizeall   = SDL_SYSTEM_CURSOR_SIZEALL,
    /// Slashed circle or crossbones
    no        = SDL_SYSTEM_CURSOR_NO,
    /// Hand
    hand      = SDL_SYSTEM_CURSOR_HAND,
};

pub const MouseWheelDirection = enum(u32) {
    /// The scroll direction is normal
    normal = c.SDL_MOUSEWHEEL_NORMAL,
    /// The scroll direction is flipped / natural
    flipped = c.SDL_MOUSEWHEEL_FLIPPED,
};

pub fn getMouseFocus() ?*Window { return c.SDL_GetMouseFocus(); }

pub const MouseState = struct {
    point: Point,
    state: u32,
};

pub fn getMouseState() MouseState {
    var point: Point = undefined;
    const state = c.SDL_GetMouseState(&point.x, &point.y);
    return .{ .point = point, .state = state };
}

pub fn getGlobalMouseState() MouseState {
    var point: Point = undefined;
    const state = c.SDL_GetGlobalMouseState(&point.x, &point.y);
    return .{ .point = point, .state = state };
}

pub fn getRelativeMouseState() MouseState {
    var point: Point = undefined;
    const state = c.SDL_GetRelativeMouseState(&point.x, &point.y);
    return .{ .point = point, .state = state };
}

pub fn warpMouseInWindow(window: ?*Window, point: Point) void {
    c.SDL_WarpMouseInWindow(window, point.x, point.y);
}

pub fn warpMouseGlobal(point: Point) !void {
    if (c.SDL_WarpMouseInWindow(point.x, point.y) < 0)
        return error.SDL2_Video;
}

pub fn setRelativeMouseMode(enabled: bool) !void {
    if (c.SDL_SetRelativeMouseMode(@boolToInt(enabled)) < 0)
        return error.SDL2_Video;
}

pub fn getRelativeMouseMode() bool {
    return c.SDL_GetRelativeMouseMode() != 0;
}

pub fn captureMouse(enabled: bool) !void {
    if (c.SDL_CaptureMouse(@boolToInt(enabled)) < 0)
        return error.SDL2_Video;
}

pub fn createCursor(data: [*]const u8, mask: [*]const u8,
                    w: c_int, h: c_int, hot_x: c_int, hot_y: c_int) !*Cursor {
    return c.CreateCursor(data, mask, w, h, hot_x, hot_y)
           orelse error.OutOfMemory;
}

pub fn createColorCursor(surface: *Surface, hot_x: c_int, hot_y: c_int) !*Cursor {
    return c.CreateColorCursor(surface, hot_x, hot_y)
           orelse error.OutOfMemory;
}

pub fn createSystemCursor(id: SystemCursor) !*Cursor {
    return c.CreateSystemCursor(id)
           orelse error.OutOfMemory;
}

pub fn setCursor(cursor: *Cursor) void { c.SDL_SetCursor(cursor); }
pub fn getCursor() ?*Cursor { return c.SDL_GetCursor(cursor); }
pub fn getDefaultCursor() ?*Cursor { return c.SDL_GetDefaultCursor(cursor); }

pub fn freeCursor(cursor: *Cursor) void {
    c.SDL_FreeCursor(cursor);
}

pub fn showCursor(enable: bool) void {
    c.SDL_ShowCursor(@boolToInt(enable));
}
pub fn isCursorShown() bool {
    return c.SDL_ShowCursor(-1) != 0;
}

pub const Button = enum(u8) {
    left = c.SDL_BUTTON_LEFT,
    middle = c.SDL_BUTTON_MIDDLE,
    right = c.SDL_BUTTON_RIGHT,
    x1 = c.SDL_BUTTON_X1,
    x2 = c.SDL_BUTTON_X2,

    pub fn mask(button: Button) u8 {
        return c.SDL_BUTTON(button);
    }
};
