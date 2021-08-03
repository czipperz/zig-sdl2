const std = @import("std");
const c = @import("sdl_c.zig");

comptime { std.debug.assert(@sizeOf(Scancode) == @sizeOf(c.SDL_Scancode)); }

pub const Scancode = enum(u32) {
    unknown            = c.SDL_SCANCODE_UNKNOWN,

    /// \name Usage page 0x07
    ///
    /// These values are from usage page 0x07 (USB keyboard page).
    ///
    /// @{ *//* Usage page 0x07

    a                  = c.SDL_SCANCODE_A,
    b                  = c.SDL_SCANCODE_B,
    c                  = c.SDL_SCANCODE_C,
    d                  = c.SDL_SCANCODE_D,
    e                  = c.SDL_SCANCODE_E,
    f                  = c.SDL_SCANCODE_F,
    g                  = c.SDL_SCANCODE_G,
    h                  = c.SDL_SCANCODE_H,
    i                  = c.SDL_SCANCODE_I,
    j                  = c.SDL_SCANCODE_J,
    k                  = c.SDL_SCANCODE_K,
    l                  = c.SDL_SCANCODE_L,
    m                  = c.SDL_SCANCODE_M,
    n                  = c.SDL_SCANCODE_N,
    o                  = c.SDL_SCANCODE_O,
    p                  = c.SDL_SCANCODE_P,
    q                  = c.SDL_SCANCODE_Q,
    r                  = c.SDL_SCANCODE_R,
    s                  = c.SDL_SCANCODE_S,
    t                  = c.SDL_SCANCODE_T,
    u                  = c.SDL_SCANCODE_U,
    v                  = c.SDL_SCANCODE_V,
    w                  = c.SDL_SCANCODE_W,
    x                  = c.SDL_SCANCODE_X,
    y                  = c.SDL_SCANCODE_Y,
    z                  = c.SDL_SCANCODE_Z,

    digit1             = c.SDL_SCANCODE_1,
    digit2             = c.SDL_SCANCODE_2,
    digit3             = c.SDL_SCANCODE_3,
    digit4             = c.SDL_SCANCODE_4,
    digit5             = c.SDL_SCANCODE_5,
    digit6             = c.SDL_SCANCODE_6,
    digit7             = c.SDL_SCANCODE_7,
    digit8             = c.SDL_SCANCODE_8,
    digit9             = c.SDL_SCANCODE_9,
    digit0             = c.SDL_SCANCODE_0,

    return_            = c.SDL_SCANCODE_RETURN,
    escape             = c.SDL_SCANCODE_ESCAPE,
    backspace          = c.SDL_SCANCODE_BACKSPACE,
    tab                = c.SDL_SCANCODE_TAB,
    space              = c.SDL_SCANCODE_SPACE,

    minus              = c.SDL_SCANCODE_MINUS,
    equals             = c.SDL_SCANCODE_EQUALS,
    leftbracket        = c.SDL_SCANCODE_LEFTBRACKET,
    rightbracket       = c.SDL_SCANCODE_RIGHTBRACKET,

    /// Located at the lower left of the return key on ISO keyboards and at the right
    /// end of the QWERTY row on ANSI keyboards.  Produces REVERSE SOLIDUS (backslash) and
    /// VERTICAL LINE in a US layout, REVERSE SOLIDUS and VERTICAL LINE in a UK Mac layout,
    /// NUMBER SIGN and TILDE in a UK Windows layout, DOLLAR SIGN and POUND SIGN in a Swiss
    /// German layout, NUMBER SIGN and APOSTROPHE in a German layout, GRAVE ACCENT and POUND
    /// SIGN in a French Mac layout, and ASTERISK and MICRO SIGN in a French Windows layout.
    backslash          = c.SDL_SCANCODE_BACKSLASH,

    /// ISO USB keyboards actually use this code instead of 49 for the same key, but all OSes
    /// I've seen treat the two codes identically.  So, as an implementor, unless your
    /// keyboard generates both of those codes and your OS treats them differently, you
    /// should generate SDL_SCANCODE_BACKSLASH instead of this code.  As a user, you should
    /// not rely on this code because SDL will never generate it with most (all?)  keyboards.
    nonushash          = c.SDL_SCANCODE_NONUSHASH,

    semicolon          = c.SDL_SCANCODE_SEMICOLON,
    apostrophe         = c.SDL_SCANCODE_APOSTROPHE,

    /// Located in the top left corner (on both ANSI and ISO keyboards).  Produces GRAVE ACCENT
    /// and TILDE in a US Windows layout and in US and UK Mac layouts on ANSI keyboards, GRAVE
    /// ACCENT and NOT SIGN in a UK Windows layout, SECTION SIGN and PLUS-MINUS SIGN in US and
    /// UK Mac layouts on ISO keyboards, SECTION SIGN and DEGREE SIGN in a Swiss German layout
    /// (Mac: only on ISO keyboards), CIRCUMFLEX ACCENT and DEGREE SIGN in a German layout (Mac:
    /// only on ISO keyboards), SUPERSCRIPT TWO and TILDE in a French Windows layout, COMMERCIAL
    /// AT and NUMBER SIGN in a French Mac layout on ISO keyboards, and LESS-THAN SIGN and
    /// GREATER-THAN SIGN in a Swiss German, German, or French Mac layout on ANSI keyboards.
    grave              = c.SDL_SCANCODE_GRAVE,

    comma              = c.SDL_SCANCODE_COMMA,
    period             = c.SDL_SCANCODE_PERIOD,
    slash              = c.SDL_SCANCODE_SLASH,

    capslock           = c.SDL_SCANCODE_CAPSLOCK,

    f1                 = c.SDL_SCANCODE_F1,
    f2                 = c.SDL_SCANCODE_F2,
    f3                 = c.SDL_SCANCODE_F3,
    f4                 = c.SDL_SCANCODE_F4,
    f5                 = c.SDL_SCANCODE_F5,
    f6                 = c.SDL_SCANCODE_F6,
    f7                 = c.SDL_SCANCODE_F7,
    f8                 = c.SDL_SCANCODE_F8,
    f9                 = c.SDL_SCANCODE_F9,
    f10                = c.SDL_SCANCODE_F10,
    f11                = c.SDL_SCANCODE_F11,
    f12                = c.SDL_SCANCODE_F12,

    printscreen        = c.SDL_SCANCODE_PRINTSCREEN,
    scrolllock         = c.SDL_SCANCODE_SCROLLLOCK,
    pause              = c.SDL_SCANCODE_PAUSE,

    /// insert on PC, help on some Mac keyboards (but does send code 73, not 117)
    insert             = c.SDL_SCANCODE_INSERT,

    home               = c.SDL_SCANCODE_HOME,
    pageup             = c.SDL_SCANCODE_PAGEUP,
    delete_            = c.SDL_SCANCODE_DELETE,
    end                = c.SDL_SCANCODE_END,
    pagedown           = c.SDL_SCANCODE_PAGEDOWN,
    right              = c.SDL_SCANCODE_RIGHT,
    left               = c.SDL_SCANCODE_LEFT,
    down               = c.SDL_SCANCODE_DOWN,
    up                 = c.SDL_SCANCODE_UP,

    /// num lock on PC, clear on Mac keyboards
    numlockclear       = c.SDL_SCANCODE_NUMLOCKCLEAR,

    kp_divide          = c.SDL_SCANCODE_KP_DIVIDE,
    kp_multiply        = c.SDL_SCANCODE_KP_MULTIPLY,
    kp_minus           = c.SDL_SCANCODE_KP_MINUS,
    kp_plus            = c.SDL_SCANCODE_KP_PLUS,
    kp_enter           = c.SDL_SCANCODE_KP_ENTER,
    kp_1               = c.SDL_SCANCODE_KP_1,
    kp_2               = c.SDL_SCANCODE_KP_2,
    kp_3               = c.SDL_SCANCODE_KP_3,
    kp_4               = c.SDL_SCANCODE_KP_4,
    kp_5               = c.SDL_SCANCODE_KP_5,
    kp_6               = c.SDL_SCANCODE_KP_6,
    kp_7               = c.SDL_SCANCODE_KP_7,
    kp_8               = c.SDL_SCANCODE_KP_8,
    kp_9               = c.SDL_SCANCODE_KP_9,
    kp_0               = c.SDL_SCANCODE_KP_0,
    kp_period          = c.SDL_SCANCODE_KP_PERIOD,

    /// This is the additional key that ISO keyboards have over ANSI ones, located between
    /// left shift and Y.  Produces GRAVE ACCENT and TILDE in a US or UK Mac layout,
    /// REVERSE SOLIDUS (backslash) and VERTICAL LINE in a US or UK Windows layout, and
    /// LESS-THAN SIGN and GREATER-THAN SIGN in a Swiss German, German, or French layout.
    nonusbackslash     = c.SDL_SCANCODE_NONUSBACKSLASH,

    /// windows contextual menu, compose
    application        = c.SDL_SCANCODE_APPLICATION,

    /// The USB document says this is a status flag, not a
    /// physical key - but some Mac keyboards do have a power key.
    power              = c.SDL_SCANCODE_POWER,

    kp_equals          = c.SDL_SCANCODE_KP_EQUALS,
    f13                = c.SDL_SCANCODE_F13,
    f14                = c.SDL_SCANCODE_F14,
    f15                = c.SDL_SCANCODE_F15,
    f16                = c.SDL_SCANCODE_F16,
    f17                = c.SDL_SCANCODE_F17,
    f18                = c.SDL_SCANCODE_F18,
    f19                = c.SDL_SCANCODE_F19,
    f20                = c.SDL_SCANCODE_F20,
    f21                = c.SDL_SCANCODE_F21,
    f22                = c.SDL_SCANCODE_F22,
    f23                = c.SDL_SCANCODE_F23,
    f24                = c.SDL_SCANCODE_F24,
    execute            = c.SDL_SCANCODE_EXECUTE,
    help               = c.SDL_SCANCODE_HELP,
    menu               = c.SDL_SCANCODE_MENU,
    select             = c.SDL_SCANCODE_SELECT,
    stop               = c.SDL_SCANCODE_STOP,

    /// redo
    again              = c.SDL_SCANCODE_AGAIN,

    undo               = c.SDL_SCANCODE_UNDO,
    cut                = c.SDL_SCANCODE_CUT,
    copy               = c.SDL_SCANCODE_COPY,
    paste              = c.SDL_SCANCODE_PASTE,
    find               = c.SDL_SCANCODE_FIND,
    mute               = c.SDL_SCANCODE_MUTE,
    volumeup           = c.SDL_SCANCODE_VOLUMEUP,
    volumedown         = c.SDL_SCANCODE_VOLUMEDOWN,

    // not sure whether there's a reason to enable these
    // SDL_SCANCODE_LOCKINGCAPSLOCK = 130,
    // SDL_SCANCODE_LOCKINGNUMLOCK = 131,
    // SDL_SCANCODE_LOCKINGSCROLLLOCK = 132,

    kp_comma           = c.SDL_SCANCODE_KP_COMMA,
    kp_equalsas400     = c.SDL_SCANCODE_KP_EQUALSAS400,

    /// used on Asian keyboards, see footnotes in USB doc
    international1     = c.SDL_SCANCODE_INTERNATIONAL1,
    international2     = c.SDL_SCANCODE_INTERNATIONAL2,
    /// Yen
    international3     = c.SDL_SCANCODE_INTERNATIONAL3,
    international4     = c.SDL_SCANCODE_INTERNATIONAL4,
    international5     = c.SDL_SCANCODE_INTERNATIONAL5,
    international6     = c.SDL_SCANCODE_INTERNATIONAL6,
    international7     = c.SDL_SCANCODE_INTERNATIONAL7,
    international8     = c.SDL_SCANCODE_INTERNATIONAL8,
    international9     = c.SDL_SCANCODE_INTERNATIONAL9,
    /// Hangul/English toggle
    lang1              = c.SDL_SCANCODE_LANG1,
    /// Hanja conversion
    lang2              = c.SDL_SCANCODE_LANG2,
    /// Katakana
    lang3              = c.SDL_SCANCODE_LANG3,
    /// Hiragana
    lang4              = c.SDL_SCANCODE_LANG4,
    /// Zenkaku/Hankaku
    lang5              = c.SDL_SCANCODE_LANG5,
    /// reserved
    lang6              = c.SDL_SCANCODE_LANG6,
    /// reserved
    lang7              = c.SDL_SCANCODE_LANG7,
    /// reserved
    lang8              = c.SDL_SCANCODE_LANG8,
    /// reserved
    lang9              = c.SDL_SCANCODE_LANG9,

    /// Erase-Eaze
    alterase           = c.SDL_SCANCODE_ALTERASE,
    sysreq             = c.SDL_SCANCODE_SYSREQ,
    cancel             = c.SDL_SCANCODE_CANCEL,
    clear              = c.SDL_SCANCODE_CLEAR,
    prior              = c.SDL_SCANCODE_PRIOR,
    return2            = c.SDL_SCANCODE_RETURN2,
    separator          = c.SDL_SCANCODE_SEPARATOR,
    out                = c.SDL_SCANCODE_OUT,
    oper               = c.SDL_SCANCODE_OPER,
    clearagain         = c.SDL_SCANCODE_CLEARAGAIN,
    crsel              = c.SDL_SCANCODE_CRSEL,
    exsel              = c.SDL_SCANCODE_EXSEL,

    kp_00              = c.SDL_SCANCODE_KP_00,
    kp_000             = c.SDL_SCANCODE_KP_000,
    thousandsseparator = c.SDL_SCANCODE_THOUSANDSSEPARATOR,
    decimalseparator   = c.SDL_SCANCODE_DECIMALSEPARATOR,
    currencyunit       = c.SDL_SCANCODE_CURRENCYUNIT,
    currencysubunit    = c.SDL_SCANCODE_CURRENCYSUBUNIT,
    kp_leftparen       = c.SDL_SCANCODE_KP_LEFTPAREN,
    kp_rightparen      = c.SDL_SCANCODE_KP_RIGHTPAREN,
    kp_leftbrace       = c.SDL_SCANCODE_KP_LEFTBRACE,
    kp_rightbrace      = c.SDL_SCANCODE_KP_RIGHTBRACE,
    kp_tab             = c.SDL_SCANCODE_KP_TAB,
    kp_backspace       = c.SDL_SCANCODE_KP_BACKSPACE,
    kp_a               = c.SDL_SCANCODE_KP_A,
    kp_b               = c.SDL_SCANCODE_KP_B,
    kp_c               = c.SDL_SCANCODE_KP_C,
    kp_d               = c.SDL_SCANCODE_KP_D,
    kp_e               = c.SDL_SCANCODE_KP_E,
    kp_f               = c.SDL_SCANCODE_KP_F,
    kp_xor             = c.SDL_SCANCODE_KP_XOR,
    kp_power           = c.SDL_SCANCODE_KP_POWER,
    kp_percent         = c.SDL_SCANCODE_KP_PERCENT,
    kp_less            = c.SDL_SCANCODE_KP_LESS,
    kp_greater         = c.SDL_SCANCODE_KP_GREATER,
    kp_ampersand       = c.SDL_SCANCODE_KP_AMPERSAND,
    kp_dblampersand    = c.SDL_SCANCODE_KP_DBLAMPERSAND,
    kp_verticalbar     = c.SDL_SCANCODE_KP_VERTICALBAR,
    kp_dblverticalbar  = c.SDL_SCANCODE_KP_DBLVERTICALBAR,
    kp_colon           = c.SDL_SCANCODE_KP_COLON,
    kp_hash            = c.SDL_SCANCODE_KP_HASH,
    kp_space           = c.SDL_SCANCODE_KP_SPACE,
    kp_at              = c.SDL_SCANCODE_KP_AT,
    kp_exclam          = c.SDL_SCANCODE_KP_EXCLAM,
    kp_memstore        = c.SDL_SCANCODE_KP_MEMSTORE,
    kp_memrecall       = c.SDL_SCANCODE_KP_MEMRECALL,
    kp_memclear        = c.SDL_SCANCODE_KP_MEMCLEAR,
    kp_memadd          = c.SDL_SCANCODE_KP_MEMADD,
    kp_memsubtract     = c.SDL_SCANCODE_KP_MEMSUBTRACT,
    kp_memmultiply     = c.SDL_SCANCODE_KP_MEMMULTIPLY,
    kp_memdivide       = c.SDL_SCANCODE_KP_MEMDIVIDE,
    kp_plusminus       = c.SDL_SCANCODE_KP_PLUSMINUS,
    kp_clear           = c.SDL_SCANCODE_KP_CLEAR,
    kp_clearentry      = c.SDL_SCANCODE_KP_CLEARENTRY,
    kp_binary          = c.SDL_SCANCODE_KP_BINARY,
    kp_octal           = c.SDL_SCANCODE_KP_OCTAL,
    kp_decimal         = c.SDL_SCANCODE_KP_DECIMAL,
    kp_hexadecimal     = c.SDL_SCANCODE_KP_HEXADECIMAL,

    lctrl              = c.SDL_SCANCODE_LCTRL,
    lshift             = c.SDL_SCANCODE_LSHIFT,
    /// alt, option
    lalt               = c.SDL_SCANCODE_LALT,
    /// windows, command (apple), meta
    lgui               = c.SDL_SCANCODE_LGUI,
    rctrl              = c.SDL_SCANCODE_RCTRL,
    rshift             = c.SDL_SCANCODE_RSHIFT,
    /// alt gr, option
    ralt               = c.SDL_SCANCODE_RALT,
    /// windows, command (apple), meta
    rgui               = c.SDL_SCANCODE_RGUI,

    /// I'm not sure if this is really not covered by any of the above,
    /// but since there's a special KMOD_MODE for it I'm adding it here
    mode               = c.SDL_SCANCODE_MODE,

    /// @} *//* Usage page 0x07

    ///
    /// \name Usage page 0x0C
    ///
    /// These values are mapped from usage page 0x0C (USB consumer page).
    ///
    /// @{ *//* Usage page 0x0C

    audionext          = c.SDL_SCANCODE_AUDIONEXT,
    audioprev          = c.SDL_SCANCODE_AUDIOPREV,
    audiostop          = c.SDL_SCANCODE_AUDIOSTOP,
    audioplay          = c.SDL_SCANCODE_AUDIOPLAY,
    audiomute          = c.SDL_SCANCODE_AUDIOMUTE,
    mediaselect        = c.SDL_SCANCODE_MEDIASELECT,
    www                = c.SDL_SCANCODE_WWW,
    mail               = c.SDL_SCANCODE_MAIL,
    calculator         = c.SDL_SCANCODE_CALCULATOR,
    computer           = c.SDL_SCANCODE_COMPUTER,
    ac_search          = c.SDL_SCANCODE_AC_SEARCH,
    ac_home            = c.SDL_SCANCODE_AC_HOME,
    ac_back            = c.SDL_SCANCODE_AC_BACK,
    ac_forward         = c.SDL_SCANCODE_AC_FORWARD,
    ac_stop            = c.SDL_SCANCODE_AC_STOP,
    ac_refresh         = c.SDL_SCANCODE_AC_REFRESH,
    ac_bookmarks       = c.SDL_SCANCODE_AC_BOOKMARKS,

    /// @} *//* Usage page 0x0C

    ///
    /// \name Walther keys
    ///
    /// These are values that Christian Walther added (for mac keyboard?).
    ///
    /// @{ *//* Walther keys

    brightnessdown     = c.SDL_SCANCODE_BRIGHTNESSDOWN,
    brightnessup       = c.SDL_SCANCODE_BRIGHTNESSUP,

    /// display mirroring/dual display switch, video mode switch
    displayswitch      = c.SDL_SCANCODE_DISPLAYSWITCH,

    kbdillumtoggle     = c.SDL_SCANCODE_KBDILLUMTOGGLE,
    kbdillumdown       = c.SDL_SCANCODE_KBDILLUMDOWN,
    kbdillumup         = c.SDL_SCANCODE_KBDILLUMUP,
    eject              = c.SDL_SCANCODE_EJECT,
    sleep              = c.SDL_SCANCODE_SLEEP,

    app1               = c.SDL_SCANCODE_APP1,
    app2               = c.SDL_SCANCODE_APP2,

    /// @} *//* Walther keys

    ///
    /// \name Usage page 0x0C (additional media keys)
    ///
    /// These values are mapped from usage page 0x0C (USB consumer page).
    ///
    /// @{ *//* Usage page 0x0C (additional media keys)

    audiorewind        = c.SDL_SCANCODE_AUDIOREWIND,
    audiofastforward   = c.SDL_SCANCODE_AUDIOFASTFORWARD,

    /// @} *//* Usage page 0x0C (additional media keys)

    // Add any other keys here.

    /// not a key, just marks the number of scancodes for array bounds
    scancodes          = c.SDL_NUM_SCANCODES,
};
