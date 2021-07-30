const c = @cImport(@cInclude("SDL.h"));
const std = @import("std");
usingnamespace @import("sdl_general.zig");

/// Control which SDL subsystems are initialized.
pub const InitFlags = struct {
    timer: bool = false,
    audio: bool = false,
    video: bool = false,  //< video implies events
    joystick: bool = false,  //< joystick implies events
    haptic: bool = false,
    gamecontroller: bool = false,  //< gamecontroller implies joystick
    events: bool = false,
    sensor: bool = false,

    fn toU32(flags: InitFlags) u32 {
        var x: u32 = 0;
        if (flags.timer)          x |= c.SDL_INIT_TIMER;
        if (flags.audio)          x |= c.SDL_INIT_AUDIO;
        if (flags.video)          x |= c.SDL_INIT_VIDEO;
        if (flags.joystick)       x |= c.SDL_INIT_JOYSTICK;
        if (flags.haptic)         x |= c.SDL_INIT_HAPTIC;
        if (flags.gamecontroller) x |= c.SDL_INIT_GAMECONTROLLER;
        if (flags.events)         x |= c.SDL_INIT_EVENTS;
        if (flags.sensor)         x |= c.SDL_INIT_SENSOR;
        return x;
    }
};

/// All subsystems.
pub const InitEverything = InitFlags {
    .timer          = true,
    .audio          = true,
    .video          = true,
    .joystick       = true,
    .haptic         = true,
    .gamecontroller = true,
    .events         = true,
    .sensor         = true,
};

/// Initialize all specified subsystems.
pub fn init(flags: InitFlags) Error!void {
    if (c.SDL_Init(flags.toU32()) != 0) {
        return error.SDL2_Init;
    }
}

/// Initialize all specified subsystems.
pub fn initSubSystem(flags: InitFlags) Error!void {
    if (c.SDL_InitSubSystem(flags.toU32()) != 0) {
        return error.SDL2_Init;
    }
}

/// Quit all specified subsystems.
pub fn quitSubSystem(flags: InitFlags) void {
    c.SDL_QuitSubSystem(flags.toU32());
}

/// Returns the subset of the passed subsystems that are enabled.
/// If no subsystems are enabled in `flags` then returns all subsystems that are enabled.
pub fn wasInit(flags: InitFlags) InitFlags {
    const out = c.SDL_WasInit(flags.toU32());

    return .{
        .timer          = out & c.SDL_INIT_TIMER,
        .audio          = out & c.SDL_INIT_AUDIO,
        .video          = out & c.SDL_INIT_VIDEO,
        .joystick       = out & c.SDL_INIT_JOYSTICK,
        .haptic         = out & c.SDL_INIT_HAPTIC,
        .gamecontroller = out & c.SDL_INIT_GAMECONTROLLER,
        .events         = out & c.SDL_INIT_EVENTS,
        .sensor         = out & c.SDL_INIT_SENSOR,
    };
}

/// Quit all subsystems.
pub fn quit() void {
    c.SDL_Quit();
}
