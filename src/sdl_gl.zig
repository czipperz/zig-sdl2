const c = @import("sdl_c.zig");

/// Opaque handle to an OpenGL context.
pub const Context = *c_void;

/// OpenGL configuration attributes.
pub const Attribute = enum(u32) {
    red_size                   = c.SDL_GL_RED_SIZE,
    green_size                 = c.SDL_GL_GREEN_SIZE,
    blue_size                  = c.SDL_GL_BLUE_SIZE,
    alpha_size                 = c.SDL_GL_ALPHA_SIZE,
    buffer_size                = c.SDL_GL_BUFFER_SIZE,
    doublebuffer               = c.SDL_GL_DOUBLEBUFFER,
    depth_size                 = c.SDL_GL_DEPTH_SIZE,
    stencil_size               = c.SDL_GL_STENCIL_SIZE,
    accum_red_size             = c.SDL_GL_ACCUM_RED_SIZE,
    accum_green_size           = c.SDL_GL_ACCUM_GREEN_SIZE,
    accum_blue_size            = c.SDL_GL_ACCUM_BLUE_SIZE,
    accum_alpha_size           = c.SDL_GL_ACCUM_ALPHA_SIZE,
    stereo                     = c.SDL_GL_STEREO,
    multisamplebuffers         = c.SDL_GL_MULTISAMPLEBUFFERS,
    multisamplesamples         = c.SDL_GL_MULTISAMPLESAMPLES,
    accelerated_visual         = c.SDL_GL_ACCELERATED_VISUAL,
    retained_backing           = c.SDL_GL_RETAINED_BACKING,
    context_major_version      = c.SDL_GL_CONTEXT_MAJOR_VERSION,
    context_minor_version      = c.SDL_GL_CONTEXT_MINOR_VERSION,
    context_egl                = c.SDL_GL_CONTEXT_EGL,
    context_flags              = c.SDL_GL_CONTEXT_FLAGS,
    context_profile_mask       = c.SDL_GL_CONTEXT_PROFILE_MASK,
    share_with_current_context = c.SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
    framebuffer_srgb_capable   = c.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
    context_release_behavior   = c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR,
    context_reset_notification = c.SDL_GL_CONTEXT_RESET_NOTIFICATION,
    context_no_error           = c.SDL_GL_CONTEXT_NO_ERROR,
};

pub const Profile = struct {
    const core:          u32 = c.SDL_GL_CONTEXT_PROFILE_CORE;
    const compatibility: u32 = c.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY;
    const es:            u32 = c.SDL_GL_CONTEXT_PROFILE_ES;
};

pub const ContextFlag = struct {
    const debug_flag:              u32 = c.SDL_GL_CONTEXT_DEBUG_FLAG;
    const forward_compatible_flag: u32 = c.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG;
    const robust_access_flag:      u32 = c.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG;
    const reset_isolation_flag:    u32 = c.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG;
};

pub const ContextResetNotification = struct {
    const no_notification: u32 = c.SDL_GL_CONTEXT_RESET_NO_NOTIFICATION;
    const lose_context:    u32 = c.SDL_GL_CONTEXT_RESET_LOSE_CONTEXT;
};
