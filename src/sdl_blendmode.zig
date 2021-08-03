const std = @import("std");
const c = @import("sdl_c.zig");

pub const BlendMode = enum(u32) {
    /// no blending
    /// `dstRGBA = srcRGBA`
    none    = c.SDL_BLENDMODE_NONE,

    /// alpha blending
    /// `dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))`
    /// `dstA = srcA + (dstA * (1-srcA))`
    blend   = c.SDL_BLENDMODE_BLEND,

    /// additive blending
    /// `dstRGB = (srcRGB * srcA) + dstRGB`
    /// `dstA = dstA`
    add     = c.SDL_BLENDMODE_ADD,

    /// color modulate
    /// `dstRGB = srcRGB * dstRGB`
    /// `dstA = dstA`
    mod     = c.SDL_BLENDMODE_MOD,

    /// color multiply
    /// `dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA))`
    /// `dstA = (srcA * dstA) + (dstA * (1-srcA))`
    mul     = c.SDL_BLENDMODE_MUL,

    invalid = c.SDL_BLENDMODE_INVALID,

    /// Other blend modes can be returned by `composeCustomBlendMode`.
    _,
};

pub const BlendOperation = enum(u32) {
    /// `dst + src`: supported by all renderers
    add          = c.SDL_BLENDOPERATION_ADD,

    /// `dst - src`: supported by D3D9, D3D11, OpenGL, OpenGLES
    subtract     = c.SDL_BLENDOPERATION_SUBTRACT,

    /// `src - dst`: supported by D3D9, D3D11, OpenGL, OpenGLES
    rev_subtract = c.SDL_BLENDOPERATION_REV_SUBTRACT,

    /// `min(dst, src)`: supported by D3D11
    minimum      = c.SDL_BLENDOPERATION_MINIMUM,

    /// `max(dst, src)`: supported by D3D11
    maximum      = c.SDL_BLENDOPERATION_MAXIMUM,
};

pub const BlendFactor = enum(u32) {
    /// 0, 0, 0, 0
    zero                = c.SDL_BLENDFACTOR_ZERO,
    /// 1, 1, 1, 1
    one                 = c.SDL_BLENDFACTOR_ONE,
    /// srcR, srcG, srcB, srcA
    src_color           = c.SDL_BLENDFACTOR_SRC_COLOR,
    /// 1-srcR, 1-srcG, 1-srcB, 1-srcA
    one_minus_src_color = c.SDL_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
    /// srcA, srcA, srcA, srcA
    src_alpha           = c.SDL_BLENDFACTOR_SRC_ALPHA,
    /// 1-srcA, 1-srcA, 1-srcA, 1-srcA
    one_minus_src_alpha = c.SDL_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
    /// dstR, dstG, dstB, dstA
    dst_color           = c.SDL_BLENDFACTOR_DST_COLOR,
    /// 1-dstR, 1-dstG, 1-dstB, 1-dstA
    one_minus_dst_color = c.SDL_BLENDFACTOR_ONE_MINUS_DST_COLOR,
    /// dstA, dstA, dstA, dstA
    dst_alpha           = c.SDL_BLENDFACTOR_DST_ALPHA,
    /// 1-dstA, 1-dstA, 1-dstA, 1-dstA
    one_minus_dst_alpha = c.SDL_BLENDFACTOR_ONE_MINUS_DST_ALPHA
};

pub fn composeCustomBlendMode(
        src_color_factor: BlendFactor, dest_color_factor: BlendFactor, color_operation: BlendOperation,
        src_alpha_factor: BlendFactor, dest_alpha_factor: BlendFactor, alpha_operation: BlendOperation)
        BlendMode {
    return @intToEnum(BlendMode,
        c.SDL_ComposeCustomBlendMode(src_color_factor, dest_color_factor, color_operation,
                                     src_alpha_factor, dest_alpha_factor, alpha_operation));
}
