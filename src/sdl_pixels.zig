const c = @cImport(@cInclude("SDL.h"));
const std = @import("std");
usingnamespace @import("sdl_general.zig");

pub const PixelType = enum(u32) {
    index1   = c.SDL_PIXELTYPE_INDEX1,
    index4   = c.SDL_PIXELTYPE_INDEX4,
    index8   = c.SDL_PIXELTYPE_INDEX8,
    packed8  = c.SDL_PIXELTYPE_PACKED8,
    packed16 = c.SDL_PIXELTYPE_PACKED16,
    packed32 = c.SDL_PIXELTYPE_PACKED32,
    arrayu8  = c.SDL_PIXELTYPE_ARRAYU8,
    arrayu16 = c.SDL_PIXELTYPE_ARRAYU16,
    arrayu32 = c.SDL_PIXELTYPE_ARRAYU32,
    arrayf16 = c.SDL_PIXELTYPE_ARRAYF16,
    arrayf32 = c.SDL_PIXELTYPE_ARRAYF32,
};

/// Bitmap pixel order, high bit -> low bit.
pub const BitmapOrder = enum(u32) {
    none = SDL_BITMAPORDER_NONE,
    o4321 = SDL_BITMAPORDER_4321,
    o1234 = SDL_BITMAPORDER_1234,
};

/// Packed component order, high bit -> low bit.
pub const PackedOrder = enum(u32) {
    none = c.SDL_PACKEDORDER_NONE,
    xrgb = c.SDL_PACKEDORDER_XRGB,
    rgbx = c.SDL_PACKEDORDER_RGBX,
    argb = c.SDL_PACKEDORDER_ARGB,
    rgba = c.SDL_PACKEDORDER_RGBA,
    xbgr = c.SDL_PACKEDORDER_XBGR,
    bgrx = c.SDL_PACKEDORDER_BGRX,
    abgr = c.SDL_PACKEDORDER_ABGR,
    bgra = c.SDL_PACKEDORDER_BGRA,
};

/// Array component order, low byte -> high byte.
pub const ArrayOrder = enum(u32) {
    none = c.SDL_ARRAYORDER_NONE,
    rgb  = c.SDL_ARRAYORDER_RGB,
    rgba = c.SDL_ARRAYORDER_RGBA,
    argb = c.SDL_ARRAYORDER_ARGB,
    bgr  = c.SDL_ARRAYORDER_BGR,
    bgra = c.SDL_ARRAYORDER_BGRA,
    abgr = c.SDL_ARRAYORDER_ABGR,
};

/// Packed component layout.
pub const PackedLayout = enum(u32) {
    none      = SDL_PACKEDLAYOUT_NONE,
    pl332     = SDL_PACKEDLAYOUT_332,
    pl4444    = SDL_PACKEDLAYOUT_4444,
    pl1555    = SDL_PACKEDLAYOUT_1555,
    pl5551    = SDL_PACKEDLAYOUT_5551,
    pl565     = SDL_PACKEDLAYOUT_565,
    pl8888    = SDL_PACKEDLAYOUT_8888,
    pl2101010 = SDL_PACKEDLAYOUT_2101010,
    pl1010102 = SDL_PACKEDLAYOUT_1010102,
};

pub const PixelFormatMasks = struct {
    bpp: i32,
    r: u32,
    g: u32,
    b: u32,
    a: u32,

    pub fn toEnum(masks: PixelFormatMasks) PixelFormatEnum {
        return c.SDL_MasksToPixelFormatEnum(masks.bpp, masks.r, masks.g, masks.b, masks.a);
    }
};

pub const PixelFormatEnum = enum(u32) {
    unknown     = c.SDL_PIXELFORMAT_UNKNOWN,
    index1lsb   = c.SDL_PIXELFORMAT_INDEX1LSB,
    index1msb   = c.SDL_PIXELFORMAT_INDEX1MSB,
    index4lsb   = c.SDL_PIXELFORMAT_INDEX4LSB,
    index4msb   = c.SDL_PIXELFORMAT_INDEX4MSB,
    index8      = c.SDL_PIXELFORMAT_INDEX8,
    rgb332      = c.SDL_PIXELFORMAT_RGB332,
    rgb444      = c.SDL_PIXELFORMAT_RGB444,
    rgb555      = c.SDL_PIXELFORMAT_RGB555,
    bgr555      = c.SDL_PIXELFORMAT_BGR555,
    argb4444    = c.SDL_PIXELFORMAT_ARGB4444,
    rgba4444    = c.SDL_PIXELFORMAT_RGBA4444,
    abgr4444    = c.SDL_PIXELFORMAT_ABGR4444,
    bgra4444    = c.SDL_PIXELFORMAT_BGRA4444,
    argb1555    = c.SDL_PIXELFORMAT_ARGB1555,
    rgba5551    = c.SDL_PIXELFORMAT_RGBA5551,
    abgr1555    = c.SDL_PIXELFORMAT_ABGR1555,
    bgra5551    = c.SDL_PIXELFORMAT_BGRA5551,
    rgb565      = c.SDL_PIXELFORMAT_RGB565,
    bgr565      = c.SDL_PIXELFORMAT_BGR565,
    rgb24       = c.SDL_PIXELFORMAT_RGB24,
    bgr24       = c.SDL_PIXELFORMAT_BGR24,
    rgb888      = c.SDL_PIXELFORMAT_RGB888,
    rgbx8888    = c.SDL_PIXELFORMAT_RGBX8888,
    bgr888      = c.SDL_PIXELFORMAT_BGR888,
    bgrx8888    = c.SDL_PIXELFORMAT_BGRX8888,
    argb8888    = c.SDL_PIXELFORMAT_ARGB8888,
    rgba8888    = c.SDL_PIXELFORMAT_RGBA8888,
    abgr8888    = c.SDL_PIXELFORMAT_ABGR8888,
    bgra8888    = c.SDL_PIXELFORMAT_BGRA8888,
    argb2101010 = c.SDL_PIXELFORMAT_ARGB2101010,
    rgba32      = c.SDL_PIXELFORMAT_RGBA32,
    argb32      = c.SDL_PIXELFORMAT_ARGB32,
    bgra32      = c.SDL_PIXELFORMAT_BGRA32,
    abgr32      = c.SDL_PIXELFORMAT_ABGR32,
    yv12        = c.SDL_PIXELFORMAT_YV12,
    iyuv        = c.SDL_PIXELFORMAT_IYUV,
    yuy2        = c.SDL_PIXELFORMAT_YUY2,
    uyvy        = c.SDL_PIXELFORMAT_UYVY,
    yvyu        = c.SDL_PIXELFORMAT_YVYU,
    nv12        = c.SDL_PIXELFORMAT_NV12,
    nv21        = c.SDL_PIXELFORMAT_NV21,

    pub fn toMasks(format: PixelFormatEnum) ?PixelFormatMasks {
        var bpp: c_int = undefined;
        var rmask: u32 = undefined;
        var gmask: u32 = undefined;
        var bmask: u32 = undefined;
        var amask: u32 = undefined;
        if (c.SDL_PixelFormatEnumToMasks(format, &bpp, &rmask, &gmask, &bmask, &amask) == 0)
            return null;
        return .{ bpp, rmask, gmask, bmask, amask };
    }
};

pub const Color = c.SDL_Color;
pub const Colour = Color;

pub const Palette = c.SDL_Palette;
pub const PixelFormat = c.SDL_PixelFormat;

pub fn getPixelFormatName(format: u32) [*:0]const u8 {
    return c.SDL_GetPixelFormatName(format);
}

pub fn allocFormat(format: PixelFormatEnum) ?*PixelFormat {
    return c.SDL_AllocFormat(@enumToInt(format));
}

pub fn freeFormat(format: *PixelFormat) void {
    c.SDL_FreeFormat(format);
}

pub fn allocPalette(num_colors: c_int) ?*Pallete {
    return c.SDL_AllocPalette(num_colors);
}

pub fn freePalette(palette: *Palette) void {
    return c.SDL_FreePalette(palette);
}

pub fn setPixelFormatPalette(format: *PixelFormat, palette: *Palette) Error!void {
    if (c.SDL_SetPixelFormatPalette(format, palette) < 0)
        return error.SDL2_Video;
}

pub fn setPaletteColors(palette: *Palette, colors: []const Color, offset: usize) Error!void {
    if (c.SDL_SetPaletteColors(palette, colors.ptr, offset, colors.len) < 0)
        return error.SDL2_Video;
}

pub fn mapRGB(format: *const PixelFormat, r: u8, g: u8, b: u8) u32 {
    return c.SDL_MapRGB(format, r, g, b);
}
pub fn mapRGBA(format: *const PixelFormat, r: u8, g: u8, b: u8, a: u8) u32 {
    return c.SDL_MapRGBA(format, r, g, b, a);
}
pub fn mapColor(format: *const PixelFormat, color: Color) u32 {
    return mapRGBA(format, color.r, color.g, color.b, color.a);
}

pub fn getRGB(format: *const PixelFormat, pixel: u32, r: *u8, g: *u8, b: *u8) void {
    c.SDL_GetRGB(pixel, format, r, g, b);
}
pub fn getRGBA(format: *const PixelFormat, pixel: u32, r: *u8, g: *u8, b: *u8, a: *u8) void {
    c.SDL_GetRGBA(pixel, format, r, g, b, a);
}
pub fn getColor(format: *const PixelFormat, pixel: u32) Color {
    var color: Color = undefined;
    getRGBA(pixel, format, &color.r, &color.b, &color.g, &color.a);
    return color;
}

pub fn calculateGammaRamp(gamma: f32, ramp: *[256]u16) void {
    c.SDL_CalculateGammaRamp(gamma, ramp.ptr);
}
