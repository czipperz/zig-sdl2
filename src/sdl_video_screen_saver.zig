const c = @import("sdl_c.zig");

pub fn isEnabled() bool {
    return c.SDL_IsScreenSaverEnabled() != 0;
}

pub fn enable() void {
    c.SDL_ScreenSaverEnable();
}
pub fn disable() void {
    c.SDL_ScreenSaverDisable();
}
