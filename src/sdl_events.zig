const std = @import("std");
const c = @import("sdl_c.zig");
usingnamespace @import("sdl_general.zig");
usingnamespace @import("sdl_keyboard.zig");

pub const Event = extern union {
    type: EventType,
    common: CommonEvent,
    display: DisplayEvent,
    window: WindowEvent,
    key: KeyboardEvent,
    edit: TextEditingEvent,
    text: TextInputEvent,
    motion: MouseMotionEvent,
    button: MouseButtonEvent,
    wheel: MouseWheelEvent,
    jaxis: JoyAxisEvent,
    jball: JoyBallEvent,
    jhat: JoyHatEvent,
    jbutton: JoyButtonEvent,
    jdevice: JoyDeviceEvent,
    caxis: ControllerAxisEvent,
    cbutton: ControllerButtonEvent,
    cdevice: ControllerDeviceEvent,
    adevice: AudioDeviceEvent,
    sensor: SensorEvent,
    quit: QuitEvent,
    user: UserEvent,
    syswm: SysWMEvent,
    tfinger: TouchFingerEvent,
    mgesture: MultiGestureEvent,
    dgesture: DollarGestureEvent,
    drop: DropEvent,
    padding: [56]u8,
};

comptime {
    std.debug.assert(@sizeOf(Event) == @sizeOf(c.SDL_Event));
}

pub const EventType = enum(u32) {
    /// Unused (do not remove)
    first = c.SDL_FIRSTEVENT,

    // Application events
    /// User-requested quit
    quit = c.SDL_QUIT,

    // These application events have special meaning on iOS, see README-ios.md for details
    /// The application is being terminated by the OS
    /// Called on iOS in applicationWillTerminate()
    /// Called on Android in onDestroy()
    app_terminating = c.SDL_APP_TERMINATING,
    /// The application is low on memory, free memory if possible.
    /// Called on iOS in applicationDidReceiveMemoryWarning()
    /// Called on Android in onLowMemory()
    app_lowmemory = c.SDL_APP_LOWMEMORY,
    /// The application is about to enter the background
    /// Called on iOS in applicationWillResignActive()
    /// Called on Android in onPause()
    app_will_enter_background = c.SDL_APP_WILLENTERBACKGROUND,
    /// The application did enter the background and may not get CPU for some time
    /// Called on iOS in applicationDidEnterBackground()
    /// Called on Android in onPause()
    app_did_enter_background = c.SDL_APP_DIDENTERBACKGROUND,
    /// The application is about to enter the foreground
    /// Called on iOS in applicationWillEnterForeground()
    /// Called on Android in onResume()
    app_will_enter_foreground = c.SDL_APP_WILLENTERFOREGROUND,
    /// The application is now interactive
    /// Called on iOS in applicationDidBecomeActive()
    /// Called on Android in onResume()
    app_did_enter_foreground = c.SDL_APP_DIDENTERFOREGROUND,

    // Display events
    /// Display state change
    display = c.SDL_DISPLAYEVENT,

    // Window events
    /// Window state change
    window = c.SDL_WINDOWEVENT,
    /// System specific event
    sys_wm = c.SDL_SYSWMEVENT,

    // Keyboard events
    /// Key pressed
    key_down = c.SDL_KEYDOWN,
    /// Key released
    key_up = c.SDL_KEYUP,
    /// Keyboard text editing (composition)
    text_editing = c.SDL_TEXTEDITING,
    /// Keyboard text input
    text_input = c.SDL_TEXTINPUT,
    /// Keymap changed due to a system event such as input language or keyboard layout change.
    keymap_changed = c.SDL_KEYMAPCHANGED,

    // Mouse events
    /// Mouse moved
    mouse_motion = c.SDL_MOUSEMOTION,
    /// Mouse button pressed
    mouse_button_down = c.SDL_MOUSEBUTTONDOWN,
    /// Mouse button released
    mouse_button_up = c.SDL_MOUSEBUTTONUP,
    /// Mouse wheel motion
    mouse_wheel = c.SDL_MOUSEWHEEL,

    // Joystick events
    /// Joystick axis motion
    joy_axis_motion = c.SDL_JOYAXISMOTION,
    /// Joystick trackball motion
    joy_ball_motion = c.SDL_JOYBALLMOTION,
    /// Joystick hat position change
    joy_hat_motion = c.SDL_JOYHATMOTION,
    /// Joystick button pressed
    joy_button_down = c.SDL_JOYBUTTONDOWN,
    /// Joystick button released
    joy_button_up = c.SDL_JOYBUTTONUP,
    /// A new joystick has been inserted into the system
    joy_device_added = c.SDL_JOYDEVICEADDED,
    /// An opened joystick has been removed
    joy_device_removed = c.SDL_JOYDEVICEREMOVED,

    // Game controller events
    /// Game controller axis motion
    controller_axis_motion = c.SDL_CONTROLLERAXISMOTION,
    /// Game controller button pressed
    controller_button_down = c.SDL_CONTROLLERBUTTONDOWN,
    /// Game controller button released
    controller_button_up = c.SDL_CONTROLLERBUTTONUP,
    /// A new Game controller has been inserted into the system
    controller_device_added = c.SDL_CONTROLLERDEVICEADDED,
    /// An opened Game controller has been removed
    controller_device_removed = c.SDL_CONTROLLERDEVICEREMOVED,
    /// The controller mapping was updated
    controller_device_remapped = c.SDL_CONTROLLERDEVICEREMAPPED,

    // Touch events
    finger_down = c.SDL_FINGERDOWN,
    finger_up = c.SDL_FINGERUP,
    finger_motion = c.SDL_FINGERMOTION,

    // Gesture events
    dollar_gesture = c.SDL_DOLLARGESTURE,
    dollar_record = c.SDL_DOLLARRECORD,
    multi_gesture = c.SDL_MULTIGESTURE,

    // Clipboard events
    /// The clipboard changed
    clipboard_update = c.SDL_CLIPBOARDUPDATE,

    // Drag and drop events
    /// The system requests a file open
    drop_file = c.SDL_DROPFILE,
    /// text/plain drag-and-drop event
    drop_text = c.SDL_DROPTEXT,
    /// A new set of drops is beginning (NULL filename)
    drop_begin = c.SDL_DROPBEGIN,
    /// Current set of drops is now complete (NULL filename)
    drop_complete = c.SDL_DROPCOMPLETE,

    // Audio hotplug events
    /// A new audio device is available
    audio_device_added = c.SDL_AUDIODEVICEADDED,
    /// An audio device has been removed.
    audio_device_removed = c.SDL_AUDIODEVICEREMOVED,

    // Sensor events
    /// A sensor was updated
    sensor_update = c.SDL_SENSORUPDATE,

    // Render events
    /// The render targets have been reset and their contents need to be updated
    render_targets_reset = c.SDL_RENDER_TARGETS_RESET,
    /// The device has been reset and all textures need to be recreated
    render_device_reset = c.SDL_RENDER_DEVICE_RESET,

    /// Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use,
    /// and should be allocated with SDL_RegisterEvents()
    user = c.SDL_USEREVENT,

    /// This last event is only for bounding internal arrays
    last = c.SDL_LASTEVENT,
};

/// \brief Fields shared by every event
pub const CommonEvent = extern struct {
    type: EventType,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
};

/// \brief Display state change event data (event.display.*)
pub const DisplayEvent = extern struct {
    /// ::SDL_DISPLAYEVENT
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The associated display index
    display: u32,
    /// ::SDL_DisplayEventID
    event: u8,
    padding1: u8,
    padding2: u8,
    padding3: u8,
    /// event dependent data
    data1: i32,

    // Event IDs:
    /// Never used
    const none = c.SDL_DISPLAYEVENT_NONE;
    /// Display orientation has changed to data1
    const orientation = c.SDL_DISPLAYEVENT_ORIENTATION;
};

/// \brief Window state change event data (event.window.*)
pub const WindowEvent = extern struct {
    /// ::SDL_WINDOWEVENT
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The associated window
    windowID: u32,
    /// ::SDL_WindowEventID
    event: u8,
    padding1: u8,
    padding2: u8,
    padding3: u8,
    /// event dependent data
    data1: i32,
    /// event dependent data
    data2: i32,

    // Event IDs:
    /// Never used
    const none = c.SDL_WINDOWEVENT_NONE;
    /// Window has been shown
    const shown = c.SDL_WINDOWEVENT_SHOWN;
    /// Window has been hidden
    const hidden = c.SDL_WINDOWEVENT_HIDDEN;
    /// Window has been exposed and should be redrawn
    const exposed = c.SDL_WINDOWEVENT_EXPOSED;
    /// Window has been moved to data1, data2
    const moved = c.SDL_WINDOWEVENT_MOVED;
    /// Window has been resized to data1xdata2
    const resized = c.SDL_WINDOWEVENT_RESIZED;
    /// The window size has changed, either as a result of an API
    /// call or through the system or user changing the window size.
    const size_changed = c.SDL_WINDOWEVENT_SIZE_CHANGED;
    /// Window has been minimized
    const minimized = c.SDL_WINDOWEVENT_MINIMIZED;
    /// Window has been maximized
    const maximized = c.SDL_WINDOWEVENT_MAXIMIZED;
    /// Window has been restored to normal size and position
    const restored = c.SDL_WINDOWEVENT_RESTORED;
    /// Window has gained mouse focus
    const enter = c.SDL_WINDOWEVENT_ENTER;
    /// Window has lost mouse focus
    const leave = c.SDL_WINDOWEVENT_LEAVE;
    /// Window has gained keyboard focus
    const focus_gained = c.SDL_WINDOWEVENT_FOCUS_GAINED;
    /// Window has lost keyboard focus
    const focus_lost = c.SDL_WINDOWEVENT_FOCUS_LOST;
    /// The window manager requests that the window be closed
    const close = c.SDL_WINDOWEVENT_CLOSE;
    /// Window is being offered a focus (should `SetWindowInputFocus()`
    /// on itself or a subwindow, or ignore)
    const take_focus = c.SDL_WINDOWEVENT_TAKE_FOCUS;
    /// Window had a hit test that wasn't SDL_HITTEST_NORMAL.
    const hit_test = c.SDL_WINDOWEVENT_HIT_TEST;
};

/// \brief Keyboard button event structure (event.key.*)
pub const KeyboardEvent = extern struct {
    /// ::SDL_KEYDOWN or ::SDL_KEYUP
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The window with keyboard focus, if any
    windowID: u32,
    /// ::SDL_PRESSED or ::SDL_RELEASED
    state: u8,
    /// Non-zero if this is a key repeat
    repeat: u8,
    padding2: u8,
    padding3: u8,
    /// The key that was pressed or released
    keysym: Keysym,
};

/// \brief Keyboard text editing event structure (event.edit.*)
pub const TextEditingEvent = extern struct {
    /// ::SDL_TEXTEDITING
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The window with keyboard focus, if any
    windowID: u32,
    /// The editing text
    text: [c.SDL_TEXTEDITINGEVENT_TEXT_SIZE:0]u8,
    /// The start cursor of selected editing text
    start: i32,
    /// The length of selected editing text
    length: i32,
};

/// \brief Keyboard text input event structure (event.text.*)
pub const TextInputEvent = extern struct {
    /// ::SDL_TEXTINPUT
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The window with keyboard focus, if any
    windowID: u32,
    /// The input text
    text: [c.SDL_TEXTINPUTEVENT_TEXT_SIZE:0]u8,
};

/// \brief Mouse motion event structure (event.motion.*)
pub const MouseMotionEvent = extern struct {
    /// ::SDL_MOUSEMOTION
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The window with mouse focus, if any
    windowID: u32,
    /// The mouse instance id, or SDL_TOUCH_MOUSEID
    which: u32,
    /// The current button state
    state: u32,
    /// X coordinate, relative to window
    x: i32,
    /// Y coordinate, relative to window
    y: i32,
    /// The relative motion in the X direction
    xrel: i32,
    /// The relative motion in the Y direction
    yrel: i32,
};

/// \brief Mouse button event structure (event.button.*)
pub const MouseButtonEvent = extern struct {
    /// ::SDL_MOUSEBUTTONDOWN or ::SDL_MOUSEBUTTONUP
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The window with mouse focus, if any
    windowID: u32,
    /// The mouse instance id, or SDL_TOUCH_MOUSEID
    which: u32,
    /// The mouse button index
    button: u8,
    /// ::SDL_PRESSED or ::SDL_RELEASED
    state: u8,
    /// 1 for single-click, 2 for double-click, etc.
    clicks: u8,
    padding1: u8,
    /// X coordinate, relative to window
    x: i32,
    /// Y coordinate, relative to window
    y: i32,
};

/// \brief Mouse wheel event structure (event.wheel.*)
pub const MouseWheelEvent = extern struct {
    /// ::SDL_MOUSEWHEEL
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The window with mouse focus, if any
    windowID: u32,
    /// The mouse instance id, or SDL_TOUCH_MOUSEID
    which: u32,
    /// The amount scrolled horizontally, positive to the right and negative to the left
    x: i32,
    /// The amount scrolled vertically, positive away from the user and negative toward the user
    y: i32,
    /// Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back
    direction: u32,
};

/// \brief Joystick axis motion event structure (event.jaxis.*)
pub const JoyAxisEvent = extern struct {
    /// ::SDL_JOYAXISMOTION
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick instance id
    which: c.SDL_JoystickID,
    /// The joystick axis index
    axis: u8,
    padding1: u8,
    padding2: u8,
    padding3: u8,
    /// The axis value (range: -32768 to 32767)
    value: i16,
    padding4: u16,
};

/// \brief Joystick trackball motion event structure (event.jball.*)
pub const JoyBallEvent = extern struct {
    /// ::SDL_JOYBALLMOTION
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick instance id
    which: c.SDL_JoystickID,
    /// The joystick trackball index
    ball: u8,
    padding1: u8,
    padding2: u8,
    padding3: u8,
    /// The relative motion in the X direction
    xrel: i16,
    /// The relative motion in the Y direction
    yrel: i16,
};

/// \brief Joystick hat position change event structure (event.jhat.*)
pub const JoyHatEvent = extern struct {
    /// ::SDL_JOYHATMOTION
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick instance id
    which: c.SDL_JoystickID,
    /// The joystick hat index
    hat: u8,

    /// The hat position value.
    /// \sa ::SDL_HAT_LEFTUP ::SDL_HAT_UP ::SDL_HAT_RIGHTUP
    /// \sa ::SDL_HAT_LEFT ::SDL_HAT_CENTERED ::SDL_HAT_RIGHT
    /// \sa ::SDL_HAT_LEFTDOWN ::SDL_HAT_DOWN ::SDL_HAT_RIGHTDOWN
    ///
    /// Note that zero means the POV is centered.
    value: u8,

    padding1: u8,
    padding2: u8,
};

/// \brief Joystick button event structure (event.jbutton.*)
pub const JoyButtonEvent = extern struct {
    /// ::SDL_JOYBUTTONDOWN or ::SDL_JOYBUTTONUP
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick instance id
    which: c.SDL_JoystickID,
    /// The joystick button index
    button: u8,
    /// ::SDL_PRESSED or ::SDL_RELEASED
    state: u8,
    padding1: u8,
    padding2: u8,
};

/// \brief Joystick device event structure (event.jdevice.*)
pub const JoyDeviceEvent = extern struct {
    /// ::SDL_JOYDEVICEADDED or ::SDL_JOYDEVICEREMOVED
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick device index for the ADDED event, instance id for the REMOVED event
    which: i32,
};

/// \brief Game controller axis motion event structure (event.caxis.*)
pub const ControllerAxisEvent = extern struct {
    /// ::SDL_CONTROLLERAXISMOTION
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick instance id
    which: c.SDL_JoystickID,
    /// The controller axis (SDL_GameControllerAxis)
    axis: u8,
    padding1: u8,
    padding2: u8,
    padding3: u8,
    /// The axis value (range: -32768 to 32767)
    value: i16,
    padding4: u16,
};

/// \brief Game controller button event structure (event.cbutton.*)
pub const ControllerButtonEvent = extern struct {
    /// ::SDL_CONTROLLERBUTTONDOWN or ::SDL_CONTROLLERBUTTONUP
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick instance id
    which: c.SDL_JoystickID,
    /// The controller button (SDL_GameControllerButton)
    button: u8,
    /// ::SDL_PRESSED or ::SDL_RELEASED
    state: u8,
    padding1: u8,
    padding2: u8,
};

/// \brief Controller device event structure (event.cdevice.*)
pub const ControllerDeviceEvent = extern struct {
    /// ::SDL_CONTROLLERDEVICEADDED, ::SDL_CONTROLLERDEVICEREMOVED, or ::SDL_CONTROLLERDEVICEREMAPPED
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event
    which: i32,
};

/// \brief Audio device event structure (event.adevice.*)
pub const AudioDeviceEvent = extern struct {
    /// ::SDL_AUDIODEVICEADDED, or ::SDL_AUDIODEVICEREMOVED
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The audio device index for the ADDED event (valid until next SDL_GetNumAudioDevices() call), SDL_AudioDeviceID for the REMOVED event
    which: u32,
    /// zero if an output device, non-zero if a capture device.
    iscapture: u8,
    padding1: u8,
    padding2: u8,
    padding3: u8,
};

/// \brief Touch finger event structure (event.tfinger.*)
pub const TouchFingerEvent = extern struct {
    /// ::SDL_FINGERMOTION or ::SDL_FINGERDOWN or ::SDL_FINGERUP
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The touch device id
    touchId: c.SDL_TouchID,
    fingerId: c.SDL_FingerID,
    /// Normalized in the range 0...1
    x: f32,
    /// Normalized in the range 0...1
    y: f32,
    /// Normalized in the range -1...1
    dx: f32,
    /// Normalized in the range -1...1
    dy: f32,
    /// Normalized in the range 0...1
    pressure: f32,
    /// The window underneath the finger, if any
    windowID: u32,
};

/// \brief Multiple Finger Gesture Event (event.mgesture.*)
pub const MultiGestureEvent = extern struct {
    /// ::SDL_MULTIGESTURE
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The touch device id
    touchId: c.SDL_TouchID,
    dTheta: f32,
    dDist: f32,
    x: f32,
    y: f32,
    numFingers: u16,
    padding: u16,
};

/// \brief Dollar Gesture Event (event.dgesture.*)
pub const DollarGestureEvent = extern struct {
    /// ::SDL_DOLLARGESTURE or ::SDL_DOLLARRECORD
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The touch device id
    touchId: c.SDL_TouchID,
    gestureId: c.SDL_GestureID,
    numFingers: u32,
    /// The difference between the gesture template and the actual performed gesture (lower is a better match)
    precision: f32,
    /// Normalized center of gesture
    x: f32,
    /// Normalized center of gesture
    y: f32,
};

/// \brief An event used to request a file open by the system (event.drop.*)
///        This event is enabled by default, you can disable it with SDL_EventState().
/// \note If this event is enabled, you must free the filename in the event.
pub const DropEvent = extern struct {
    /// ::SDL_DROPBEGIN or ::SDL_DROPFILE or ::SDL_DROPTEXT or ::SDL_DROPCOMPLETE
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The file name, which should be freed with SDL_free(), is NULL on begin/complete
    file: [*:0]u8,
    /// The window that was dropped on, if any
    windowID: u32,
};

/// \brief Sensor event structure (event.sensor.*)
pub const SensorEvent = extern struct {
    /// ::SDL_SENSORUPDATE
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The instance ID of the sensor
    which: i32,
    /// Up to 6 values from the sensor - additional values can be queried using SDL_SensorGetData()
    data: [6]f32,
};

/// \brief The "quit requested" event
pub const QuitEvent = extern struct {
    /// ::SDL_QUIT
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
};

/// \brief OS Specific event
pub const OSEvent = extern struct {
    /// ::SDL_QUIT
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
};

/// \brief A user-defined event type (event.user.*)
pub const UserEvent = extern struct {
    /// ::SDL_USEREVENT through ::SDL_LASTEVENT-1
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// The associated window if any
    windowID: u32,
    /// User defined event code
    code: i32,
    /// User defined data pointer
    data1: *c_void,
    /// User defined data pointer
    data2: *c_void,
};

/// \brief A video driver dependent system event (event.syswm.*)
///        This event is disabled by default, you can enable it with SDL_EventState()
///
/// \note If you want to use this event, you should include SDL_syswm.h.
pub const SysWMEvent = extern struct {
    /// ::SDL_SYSWMEVENT
    type: u32,
    /// In milliseconds, populated using SDL_GetTicks()
    timestamp: u32,
    /// driver dependent data, defined in SDL_syswm.h
    msg: *c.SDL_SysWMmsg,
};



/// Pumps the event loop, gathering events from the input devices.
pub fn pumpEvents() void { c.SDL_PumpEvents(); }



pub const EventAction = enum(c_uint) {
    AddEvent = c.SDL_ADDEVENT,
    PeekEvent = c.SDL_PEEKEVENT,
    GetEvent = c.SDL_GETEVENT,
};

/// Checks the event queue for messages and optionally returns them.
pub fn peepEvents(events: []Event, action: EventAction,
                  minType: EventType, maxType: EventType) Error!usize {
    const num = c.SDL_PeepEvents(@ptrCast(?[*]c.SDL_Event, events.ptr), @intCast(c_int, events.len),
                                 @enumToInt(action), @enumToInt(minType), @enumToInt(maxType));
    if (num == -1) return error.PeepEvents;
    std.debug.assert(num >= 0);
    return @intCast(usize, num);
}

/// Checks to see if certain event types are in the event queue.
pub fn hasEvent(type_: EventType) bool { return c.SDL_HasEvent(@enumToInt(type_)); }
pub fn hasEvents(minType: EventType, maxType: EventType) bool {
    return c.SDL_HasEvent(@enumToInt(minType), @enumToInt(maxType));
}

/// Clear events from the event queue
pub fn flushEvent(type_: EventType) void { c.SDL_FlushEvent(@enumToInt(type_)); }
pub fn flushEvents(minType: EventType, maxType: EventType) void {
    c.SDL_FlushEvents(@enumToInt(minType), @enumToInt(maxType));
}

/// Get the next event, or immediately return `null`.
pub fn pollEvent() ?Event {
    var event: Event = undefined;
    if (c.SDL_PollEvent(@ptrCast(*c.SDL_Event, &event)) == 0) return null;
    return event;
}

/// Get the next event or wait indefinitely.
pub fn waitEvent() ?Event {
    var event: Event = undefined;
    if (c.SDL_WaitEvent(@ptrCast(*c.SDL_Event, &event)) == 0) return null;
    return event;
}

/// Get the next event or wait up to timeout milliseconds.
pub fn waitEventTimeout(timeout: u32) ?Event {
    var event: Event = undefined;
    if (c.SDL_WaitEventTimeout(@ptrCast(*c.SDL_Event, &event), @intCast(c_int, timeout)) == 0) return null;
    return event;
}

pub fn pushEvent(event: Event) Error!bool {
    const res = c.SDL_PushEvent(@ptrCast(*c.SDL_Event, &event));
    if (res == -1) return error.PushEvent;
    return res == 1;
}

pub const EventFilter = struct {
    func: fn(?*c_void, *Event) c_int,
    userdata: ?*c_void,

    fn nfunc(self: EventFilter) c.SDL_EventFilter {
        return @ptrCast(c.SDL_EventFilter, self.func);
    }
};

/// Sets up a filter to process all events before they change
/// internal state and are posted to the internal event queue.
pub fn setEventFilter(filter: EventFilter) void {
    c.SDL_SetEventFilter(filter.nfunc(), filter.userdata);
}

pub fn getEventFilter() ?EventFilter {
    var func: c.SDL_EventFilter = undefined;
    var userdata: ?*c_void = undefined;
    if (c.SDL_GetEventFilter(&func, &userdata) == 0) return null;
    const func2 = @ptrCast(fn(?*c_void, *Event) c_int, func.?);
    return EventFilter { .func = func2, .userdata = userdata };
}

/// Add a function which is called when an event is added to the queue.
pub fn addEventWatch(filter: EventFilter) void {
    c.SDL_AddEventWatch(filter.nfunc(), filter.userdata);
}

/// Remove an event watch function added with `addEventWatch`.
pub fn deleteEventWatch(filter: EventFilter) void {
    c.SDL_DelEventWatch(filter.nfunc(), filter.userdata);
}

/// Remove all events currently in the queue that don't match the specified filter.
pub fn filterEvents(filter: EventFilter) void {
    c.SDL_FilterEvents(filter.nfunc(), filter.userdata);
}

/// Allow disabling specific event types.  They will then be skipped.
pub fn setEventDisabled(type_: EventType, disabled: bool) void {
    _ = c.SDL_EventState(@enumToInt(type_), @boolToInt(disabled));
}

/// Test if an event type is disabled.
pub fn isEventDisabled(type_: EventType) bool {
    return c.SDL_EventState(@enumToInt(type_), c.SDL_QUERY) == 1;
}

/// Allocates a set of user-defined events.
/// Fails if there aren't enough slots left.
pub fn registerEvents(num: u32) ?u32 {
    const result = SDL_RegisterEvents(@intCast(c_int, num));
    if (result == std.math.maxInt(u32)) return null;
    return result;
}
