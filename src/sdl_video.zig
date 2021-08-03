const std = @import("std");
const c = @import("sdl_c.zig");
usingnamespace @import("sdl_general.zig");
usingnamespace @import("sdl_rect.zig");
usingnamespace @import("sdl_pixels.zig");
usingnamespace @import("sdl_surface.zig");
pub const gl = @import("sdl_gl.zig");
pub const display = @import("sdl_video_display.zig");
pub const screen_saver = @import("sdl_video_screen_saver.zig");

pub const Window = c.SDL_Window;

pub const WindowPos = union(enum) {
    centered:    void,
    unspecified: void,
    position:    c_int,

    pub fn toInt(self: WindowPos) c_int {
        return switch (self) {
            .centered => c.SDL_WINDOWPOS_CENTERED,
            .unspecified => c.SDL_WINDOWPOS_UNDEFINED,
            .position => |p| p,
        };
    }

    pub fn fromInt(i: c_int) WindowPos {
        return switch (i) {
            c.SDL_WINDOWPOS_CENTERED => .centered,
            c.SDL_WINDOWPOS_UNDEFINED => .unspecified,
            _ => .{ .position = i },
        };
    }
};

pub const WindowFlags = struct {
    fullscreen:         bool = false,
    opengl:             bool = false,
    shown:              bool = false,
    hidden:             bool = false,
    borderless:         bool = false,
    resizable:          bool = false,
    minimized:          bool = false,
    maximized:          bool = false,
    input_grabbed:      bool = false,
    input_focus:        bool = false,
    mouse_focus:        bool = false,
    /// Note: SDL_WINDOW_FULLSCREEN_DESKTOP can only be set if SDL_WINDOW_FULLSCREEN is set!
    fullscreen_desktop: bool = false,
    foreign:            bool = false,
    allow_highdpi:      bool = false,
    mouse_capture:      bool = false,
    always_on_top:      bool = false,
    skip_taskbar:       bool = false,
    utility:            bool = false,
    tooltip:            bool = false,
    popup_menu:         bool = false,
    vulkan:             bool = false,

    pub fn fromU32(x: u32) WindowFlags {
        var self = WindowFlags{};

        if (x & c.SDL_WINDOW_FULLSCREEN)    self.fullscreen = true;
        if (x & c.SDL_WINDOW_OPENGL)        self.opengl = true;
        if (x & c.SDL_WINDOW_SHOWN)         self.shown = true;
        if (x & c.SDL_WINDOW_HIDDEN)        self.hidden = true;
        if (x & c.SDL_WINDOW_BORDERLESS)    self.borderless = true;
        if (x & c.SDL_WINDOW_RESIZABLE)     self.resizable = true;
        if (x & c.SDL_WINDOW_MINIMIZED)     self.minimized = true;
        if (x & c.SDL_WINDOW_MAXIMIZED)     self.maximized = true;
        if (x & c.SDL_WINDOW_INPUT_GRABBED) self.input_grabbed = true;
        if (x & c.SDL_WINDOW_INPUT_FOCUS)   self.input_focus = true;
        if (x & c.SDL_WINDOW_MOUSE_FOCUS)   self.mouse_focus = true;
        if (x & c.SDL_WINDOW_FOREIGN)       self.foreign = true;
        if (x & c.SDL_WINDOW_ALLOW_HIGHDPI) self.allow_highdpi = true;
        if (x & c.SDL_WINDOW_MOUSE_CAPTURE) self.mouse_capture = true;
        if (x & c.SDL_WINDOW_ALWAYS_ON_TOP) self.always_on_top = true;
        if (x & c.SDL_WINDOW_SKIP_TASKBAR)  self.skip_taskbar = true;
        if (x & c.SDL_WINDOW_UTILITY)       self.utility = true;
        if (x & c.SDL_WINDOW_TOOLTIP)       self.tooltip = true;
        if (x & c.SDL_WINDOW_POPUP_MENU)    self.popup_menu = true;
        if (x & c.SDL_WINDOW_VULKAN)        self.vulkan = true;

        if (x & c.SDL_WINDOW_FULLSCREEN_DESKTOP) {
            self.fullscreen_desktop = true;
            std.debug.assert(self.fullscreen);
        }

        return self;
    }

    pub fn toU32(self: WindowFlags) u32 {
        var x: u32 = 0;

        if (self.fullscreen)    x |= c.SDL_WINDOW_FULLSCREEN;
        if (self.opengl)        x |= c.SDL_WINDOW_OPENGL;
        if (self.shown)         x |= c.SDL_WINDOW_SHOWN;
        if (self.hidden)        x |= c.SDL_WINDOW_HIDDEN;
        if (self.borderless)    x |= c.SDL_WINDOW_BORDERLESS;
        if (self.resizable)     x |= c.SDL_WINDOW_RESIZABLE;
        if (self.minimized)     x |= c.SDL_WINDOW_MINIMIZED;
        if (self.maximized)     x |= c.SDL_WINDOW_MAXIMIZED;
        if (self.input_grabbed) x |= c.SDL_WINDOW_INPUT_GRABBED;
        if (self.input_focus)   x |= c.SDL_WINDOW_INPUT_FOCUS;
        if (self.mouse_focus)   x |= c.SDL_WINDOW_MOUSE_FOCUS;
        if (self.foreign)       x |= c.SDL_WINDOW_FOREIGN;
        if (self.allow_highdpi) x |= c.SDL_WINDOW_ALLOW_HIGHDPI;
        if (self.mouse_capture) x |= c.SDL_WINDOW_MOUSE_CAPTURE;
        if (self.always_on_top) x |= c.SDL_WINDOW_ALWAYS_ON_TOP;
        if (self.skip_taskbar)  x |= c.SDL_WINDOW_SKIP_TASKBAR;
        if (self.utility)       x |= c.SDL_WINDOW_UTILITY;
        if (self.tooltip)       x |= c.SDL_WINDOW_TOOLTIP;
        if (self.popup_menu)    x |= c.SDL_WINDOW_POPUP_MENU;
        if (self.vulkan)        x |= c.SDL_WINDOW_VULKAN;

        if (self.fullscreen_desktop) {
            std.debug.assert(self.fullscreen);
            x |= c.SDL_WINDOW_FULLSCREEN_DESKTOP;
        }

        return x;
    }
};

pub const DisplayOrientation = enum(u32) {
    /// Right side up.
    landscape         = c.SDL_ORIENTATION_LANDSCAPE,
    /// Left side up.
    landscape_flipped = c.SDL_ORIENTATION_LANDSCAPE_FLIPPED,
    /// Top side up.
    portrait          = c.SDL_ORIENTATION_PORTRAIT,
    /// Bottom side up.
    portrait_flipped  = c.SDL_ORIENTATION_PORTRAIT_FLIPPED,
};

/// Get the number of available video drivers.
pub fn getNumVideoDrivers() Error!usize {
    const result = c.SDL_GetNumVideoDrivers();
    if (result < 0) return error.NumVideoDrivers;
    return @intCast(usize, result);
}

/// Get the name of the video driver at the given index.  Returns `null` if out of bounds.
pub fn getVideoDriver(index: usize) [*:0]const u8 {
    std.debug.assert(index < (getNumVideoDrivers() catch unreachable));
    return c.SDL_GetVideoDriver(@intCast(c_int, index));
}

/// Initialize the video subsystem.
/// Uses the driver specified by `driver_name` if it is provided.
pub fn videoInit(driver_name: ?[*:0]const u8) Error!void {
    const result = c.SDL_VideoInit(driver_name);
    if (result != 0) return error.SDL2_Video;
}

/// Show down the video subsystem.
pub fn videoQuit() void { c.SDL_VideoQuit(); }

/// Get the name of the initialized video driver.
pub fn getCurrentVideoDriver() ?[*:0]const u8 {
    return c.SDL_GetCurrentVideoDriver();
}

/// Get the pixel format of a window.
pub fn getWindowPixelFormat(window: *Window) PixelFormat {
    return @intToEnum(PixelFormat, SDL_GetWindowPixelFormat(window));
}

/// Create a window with specified name, position, and flags.
pub fn createWindow(name: [*:0]const u8, x: WindowPos, y: WindowPos,
                    w: c_int, h: c_int, flags: WindowFlags) Error!*Window {
    const window: ?*Window = c.SDL_CreateWindow(name, x.toInt(), y.toInt(), w, h, flags.toU32());
    return window orelse return error.SDL2_Video;
}

/// Create an SDL window from an existing native window.
pub fn createWindowFrom(data: ?*const c_void) Error!*Window {
    const window: ?*Window = c.SDL_CreateWindowFrom(data);
    return window orelse return error.SDL2_Video;
}

/// Destroy a window and close it.
pub fn destroyWindow(window: *Window) void {
    c.SDL_DestroyWindow(window);
}

/// Get the id of a window.
pub fn getWindowId(window: *Window) u32 { return c.SDL_GetWindowID(window); }

/// Lookup a window by its id.
pub fn getWindowFromId(id: u32) ?*Window {
    return c.SDL_GetWindowFromId(id);
}

/// Get the window flags.
pub fn getWindowFlags(window: *Window) WindowFlags {
    return WindowFlags.fromU32(c.SDL_GetWindowFlags(window));
}

/// Set the title of the window.
pub fn setWindowTitle(window: *Window, title: [*:0]const u8) void {
    c.SDL_SetWindowTitle(window, title);
}

/// Get the title of the window.
pub fn getWindowTitle(window: *Window) [*:0]const u8 {
    return c.SDL_GetWindowTitle(window);
}

/// Set the icon for a window.
pub fn setWindowIcon(window: *Window, icon: *Surface) void {
    c.SDL_SetWindowIcon(window, icon);
}

/// Set the data bound to `name` to `userdata` and return the old mapping, if one exists.
pub fn setWindowData(window: *Window, name: [*:0]const u8, userdata: ?*c_void) ?*c_void {
    return c.SDL_SetWindowData(window, name, userdata);
}

/// Get the data bound to `name`, if one exists.
pub fn getWindowData(window: *Window, name: [*:0]const u8) ?*c_void {
    return c.SDL_GetWindowData(window, name);
}

/// Set the position of a window.
pub fn setWindowPosition(window: *Window, x: WindowPos, y: WindowPos) void {
    c.SDL_SetWindowPosition(window, x.toInt(), y.toInt());
}

pub const WindowPosPair = struct { x: WindowPos, y: WindowPos };

/// Set the position of a window.
pub fn getWindowPosition(window: *Window) WindowPosPair {
    var x: c_int = undefined;
    var y: c_int = undefined;
    c.SDL_GetWindowPosition(window, &x, &y);
    return .{ .x = WindowPos.fromInt(x), .y = WindowPos.fromInt(y) };
}

/// Set the size of a window's client area.
pub fn setWindowSize(window: *Window, w: c_int, h: c_int) void {
    c.SDL_SetWindowSize(window, w, h);
}

/// Get the size of a window's client area.
pub fn getWindowSize(window: *Window) Dimension {
    var w: c_int = undefined;
    var h: c_int = undefined;
    c.SDL_GetWindowSize(window, &w, &h);
    return .{ .w = w, .h = h };
}

pub const WindowBordersSize = struct {
    top: c_int, left: c_int, bottom: c_int, right: c_int,
};

/// Get the size of the window's border size or `null` if not supported.
pub fn getWindowBordersSize(window: *Window) ?WindowBordersSize {
    var top: c_int = undefined;
    var left: c_int = undefined;
    var bottom: c_int = undefined;
    var right: c_int = undefined;
    if (c.SDL_GetWindowBordersSize(window, &top, &left, &bottom, &right) < 0) return null;
    return .{ top, left, bottom, right };
}

pub fn setWindowMinimumSize(window: *Window, min_w: c_int, min_h: c_int) void {
    c.SDL_SetWindowMinimumSize(window, min_w, min_h);
}

pub fn getWindowMinimumSize(window: *Window) Dimension {
    var d: Dimension = undefined;
    c.SDL_GetWindowMinimumSize(window, &d.w, &d.h);
    return d;
}

pub fn setWindowMaximumSize(window: *Window, min_w: c_int, min_h: c_int) void {
    c.SDL_SetWindowMaximumSize(window, min_w, min_h);
}

pub fn getWindowMaximumSize(window: *Window) Dimension {
    var d: Dimension = undefined;
    c.SDL_GetWindowMaximumSize(window, &d.w, &d.h);
    return d;
}

pub fn setWindowBordered(window: *Window, bordered: bool) void {
    c.SDL_SetWindowBordered(window, bordered);
}

pub fn setWindowResizable(window: *Window, resizable: bool) void {
    c.SDL_SetWindowResizable(window, resizable);
}

pub fn showWindow(window: *Window) void {
    c.SDL_ShowWindow(window);
}
pub fn hideWindow(window: *Window) void {
    c.SDL_HideWindow(window);
}

/// Raise the window to the front and focus it.
pub fn raiseWindow(window: *Window) void {
    c.SDL_RaiseWindow(window);
}
/// Focus the window without raising it.
pub fn focusNoRaiseWindow(window: *Window) !void {
    if (c.SDL_SetWidowInputFocus(window) < 0)
        return error.SDL2_Video;
}
pub fn maximizeWindow(window: *Window) void {
    c.SDL_MaximizeWindow(window);
}
pub fn minimizeWindow(window: *Window) void {
    c.SDL_MinimizeWindow(window);
}
pub fn restoreWindow(window: *Window) void {
    c.SDL_RestoreWindow(window);
}

pub fn setWindowFullscreen(window: *Window, flags: u32) !void {
    if (c.SDL_SetWindowFullscreen(window, flags) < 0)
        return error.SDL2_Video;
}

pub fn getWindowSurface(window: *Window) ?*Surface {
    return @ptrCast(?*Surface, c.SDL_GetWindowSurface(window));
}

pub fn updateWindowSurface(window: *Window) !void {
    if (c.SDL_UpdateWindowSurface(window) < 0)
        return error.SDL2_Video;
}

pub fn updateWindowSurfaceRects(window: *Window, rects: []const Rect) !void {
    if (c.SDL_UpdateWindowSurfaceRects(window, @ptrCast(c.SDL_Rect, rects.ptr),
                                       @intCast(c_int, rects.len)) < 0)
        return error.SDL2_Video;
}

pub fn setWindowGrab(window: *Window, grabbed: bool) void {
    c.SDL_SetWindowGrab(window, @boolToInt(grabbed));
}
pub fn getWindowGrab(window: *Window) bool {
    return c.SDL_SetWindowGrab(window) != 0;
}

pub fn getGrabbedWindow() ?*Window {
    return c.SDL_GetGrabbedWindow();
}

pub fn setWindowBrightness(window: *Window, brightness: f32) !void {
    if (c.SDL_SetWindowBrightness(window, @floatCast(c_float, brightness)) < 0)
        return error.SDL2_Video;
}
pub fn getWindowBrightness(window: *Window) f32 {
    return @floatCast(f32, c.SDL_GetWindowBrightness(window));
}

pub fn setWindowOpacity(window: *Window, opacity: f32) !void {
    if (c.SDL_SetWindowOpacity(window, @floatCast(c_float, opacity)) < 0)
        return error.SDL2_Video;
}
pub fn getWindowOpacity(window: *Window) f32 {
    var result: c_float = undefined;
    if (c.SDL_GetWindowOpacity(window, &result) < 0)
        return error.SDL2_Video;
    return @floatCast(f32, result);
}

pub fn setWindowAsModalFor(modal: *Window, parent: *Window) !void {
    if (c.SDL_SetWindowModalFor(modal, parent) < 0)
        return error.SDL2_Video;
}

pub fn setWindowGammaRamp(window: *Window, red: []const u16, green: []const u16, blue: []const u16) !void {
    std.debug.assert(red.len >= 256);
    std.debug.assert(green.len >= 256);
    std.debug.assert(blue.len >= 256);
    if (c.SDL_SetWindowGammaRamp(window, red.ptr, green.ptr, blue.ptr) < 0)
        return error.SDL2_Video;
}

pub fn getWindowGammaRamp(window: *Window, red: []u16, green: []u16, blue: []u16) !void {
    std.debug.assert(red.len >= 256);
    std.debug.assert(green.len >= 256);
    std.debug.assert(blue.len >= 256);
    if (c.SDL_SetWindowGammaRamp(window, red.ptr, green.ptr, blue.ptr) < 0)
        return error.SDL2_Video;
}

pub const HitTestResult = enum(u32) {
    /// Region is normal. No special properties.
    normal             = c.SDL_HITTEST_NORMAL,

    /// Region can drag entire window.
    draggable          = c.SDL_HITTEST_DRAGGABLE,

    resize_topleft     = c.SDL_HITTEST_RESIZE_TOPLEFT,
    resize_top         = c.SDL_HITTEST_RESIZE_TOP,
    resize_topright    = c.SDL_HITTEST_RESIZE_TOPRIGHT,
    resize_right       = c.SDL_HITTEST_RESIZE_RIGHT,
    resize_bottomright = c.SDL_HITTEST_RESIZE_BOTTOMRIGHT,
    resize_bottom      = c.SDL_HITTEST_RESIZE_BOTTOM,
    resize_bottomleft  = c.SDL_HITTEST_RESIZE_BOTTOMLEFT,
    resize_left        = c.SDL_HITTEST_RESIZE_LEFT
};

pub const HitTest = fn (window: *Window, areao: *const Point, data: ?*c_void) HitTestResult;

pub fn setWindowHitTest(window: *Window, callback: HitTest, callback_data: ?*c_void) !void {
    if (c.SDL_SetWindowHitTest(window, callback, callback_data) < 0)
        return error.SDL2_Video;
}
