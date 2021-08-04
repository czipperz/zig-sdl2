const std = @import("std");
const c = @import("sdl_c.zig");
pub usingnamespace @import("sdl_pixels.zig");
pub usingnamespace @import("sdl_rect.zig");
pub usingnamespace @import("sdl_rwops.zig");

/// `Surface.flags`:

/// For compatibility.
pub const SWSURFACE:    u32 = c.SDL_SWSURFACE;
/// Surface is using preallocated memory.
pub const PREALLOC:     u32 = c.SDL_PREALLOC;
/// Surface is RLE encoded.
pub const RLEACCEL:     u32 = c.SDL_RLEACCEL;
/// Surface is referenced internally.
pub const DONTFREE:     u32 = c.SDL_DONTFREE;
/// Surface uses aligned memory.
pub const SIMD_ALIGNED: u32 = c.SDL_SIMD_ALIGNED;

pub const ColorMod = struct {
    r: u8,
    g: u8,
    b: u8,
};

pub const BlitMap = c.SDL_BlitMap;

pub const Surface = extern struct {
    flags: u32,
    format: *PixelFormat,
    w: c_int,
    h: c_int,
    pitch: c_int,
    pixels: *c_void,

    userdata: *c_void,

    locked: c_int,
    lock_data: *c_void,

    clip_rect: Rect,

    map: *BlitMap,

    refcount: c_int,

    comptime {
        if (@sizeOf(Surface) != @sizeOf(c.SDL_Surface))
            @compileError("Surface must match size");
    }

    pub fn initNative(surface: *c.SDL_Surface) *Surface {
        return @ptrCast(*Surface, surface);
    }

    pub fn initMasks(flags: u32, w: i32, h: i32, depth: i32,
                     rmask: u32, gmask: u32, bmask: u32, amask: u32) !*Surface {
        const surface = c.SDL_CreateRGBSurface(flags, w, h, depth, rmask, gmask, bmask, amask);
        if (surface == null) return error.OutOfMemory;
        return initNative(surface);
    }

    pub fn initFormat(flags: u32, w: i32, h: i32, depth: i32, format: u32) !*Surface {
        const surface = c.SDL_CreateRGBSurfaceWithFormat(flags, w, h, depth, format);
        if (surface == null) return error.OutOfMemory;
        return initNative(surface);
    }

    pub fn initMasksBuffer(pixels: *c_void, w: i32, h: i32, depth: i32, pitch: i32,
                           rmask: u32, gmask: u32, bmask: u32, amask: u32) !*Surface {
        const surface = c.SDL_CreateRGBSurfaceFrom(pixels, w, h, depth, pitch,
                                                   rmask, gmask, bmask, amask);
        if (surface == null) return error.OutOfMemory;
        return initNative(surface);
    }

    pub fn initFormatBuffer(pixels: *c_void, w: i32, h: i32, depth: i32, pitch: i32,
                            format: u32) !*Surface {
        const surface = c.SDL_CreateRGBSurfaceWithFormatFrom(pixels, w, h, depth, pitch, format);
        if (surface == null) return error.OutOfMemory;
        return initNative(surface);
    }

    pub fn initBmpRW(src: *RWops) !*Surface {
        const surface = SDL_LoadBMP_RW(src);
        if (surface == null) return error.SDL2_FailedToLoadImage;
        return surface;
    }

    pub fn duplicate(surface: *Surface) !*Surface {
        return c.SDL_DuplicateSurface(surface) orelse error.OutOfMemory;
    }

    pub fn deinit(surface: *Surface) void {
        c.SDL_FreeSurface(surface);
    }

    pub fn native(surface: *Surface) *c.SDL_Surface {
        return @ptrCast(*c.SDL_Surface, surface);
    }

    pub fn mustLock(surface: *const Surface) bool {
        return (surface.flags & RLEACCEL) != 0;
    }

    pub fn setPalette(surface: *Surface, palette: *Palette) !void {
        if (c.SDL_SetSurfacePalette(surface.native(), palette) < 0)
            return error.SDL2_NoPalette;
    }

    pub fn lock(surface: *Surface) !void {
        if (c.SDL_LockSurface(surface.native()) < 0)
            error.SDL2_LockSurfaceFailed;
    }

    pub fn unlock(surface: *Surface) void {
        c.SDL_UnlockSurface(surface.native());
    }

    pub fn saveBmpRw(surface: *Surface, dest: *RWops) !void {
        if (c.SDL_SaveBMP_RW(surface.native(), dest, 0) < 0)
            return error.SDL2_FailedToWrite;
    }

    pub fn saveBmp(surface: *Surface, file: []const u8) !void {
        var dest = try rwFromFile(file, "wb");
        defer rwClose(dest);
        return saveBmpRw(surface, dest);
    }

    pub fn setRle(surface: *Surface, flag: c_int) !void {
        if (c.SDL_SetSurfaceRLE(surface.native(), flag) < 0)
            return error.SDL2_InvalidSurface;
    }

    pub fn setColorKey(surface: *Surface, enable: bool, key: u32) !void {
        if (c.SDL_SetColorKey(surface.native(), @boolToInt(enable), key) < 0)
            return error.SDL2_InvalidSurface;
    }

    pub fn hasColorKey(surface: *Surface) bool {
        return c.SDL_HasColorKey(surface.native()) != 0;
    }

    pub fn getColorKey(surface: *Surface) ?u32 {
        var key: u32 = undefined;
        if (c.SDL_GetColorKey(surface.native(), &key) < 0) {
            // This could be an invalid surface as well but it's more likely no color key.
            return null;
        }
        return key;
    }

    pub fn setColorMod(surface: *Surface, mod: ColorMod) !void {
        if (c.SDL_SetSurfaceColorMod(surface.native(), mod.r, mod.g, mod.b) < 0)
            return error.SDL2_InvalidSurface;
    }

    pub fn getColorMod(surface: *Surface) !ColorMod {
        var mod: ColorMod = undefined;
        if (c.SDL_SetSurfaceColorMod(surface.native(), &mod.r, &mod.g, &mod.b) < 0)
            return error.SDL2_InvalidSurface;
        return mod;
    }

    pub fn setAlphaMod(surface: *Surface, alpha: u8) !void {
        if (c.SDL_SetSurfaceAlphaMod(surface.native(), alpha) < 0)
            return error.SDL2_InvalidSurface;
    }

    pub fn getAlphaMod(surface: *Surface) !u8 {
        var alpha: u8 = undefined;
        if (c.SDL_SetSurfaceAlphaMod(surface.native(), &alpha) < 0)
            return error.SDL2_InvalidSurface;
        return alpha;
    }

    pub fn setBlendMode(surface: *Surface, blend_mode: BlendMode) !void {
        if (c.SDL_SetSurfaceBlendMode(surface.native(), @enumToInt(blend_mode)) < 0)
            return error.SDL2_InvalidSurface;
    }

    pub fn getBlendMode(surface: *Surface) !BlendMode {
        var blend_mode: u32 = undefined;
        if (c.SDL_GetSurfaceBlendMode(surface.native(), &blend_mode) < 0)
            return error.SDL2_InvalidSurface;
        return @intToEnum(BlendMode, blend_mode);
    }

    /// Set the clip rectangle (or disable if `rect == null`).
    /// Returns if the rectangle intersects with the surface.
    pub fn setClipRect(surface: *Surface, rect: ?Rect) bool {
        if (c.SDL_SetSurfaceClipRect(surface.native(), rectconv(&rect)) < 0)
            return error.SDL2_InvalidSurface;
    }

    pub fn getClipRect(surface: *Surface) Rect {
        var rect: Rect = undefined;
        c.SDL_GetSurfaceClipRect(surface.native(), @ptrCast(*c.SDL_Rect, &rect));
        return rect;
    }

    pub fn fill(surface: *Surface, color: u32) !void {
        if (c.SDL_FillRect(surface.native(), null, color) < 0)
            return error.SDL2_Video;
    }

    pub fn fillRect(surface: *Surface, rect: Rect, color: u32) !void {
        if (c.SDL_FillRect(surface.native(), @ptrCast(*const c.SDL_Rect, &rect), color) < 0)
            return error.SDL2_Video;
    }

    pub fn fillRects(surface: *Surface, rects: []const Rect, color: u32) !void {
        if (c.SDL_FillRects(surface.native(), @ptrCast(*const c.SDL_Rect, rects.ptr), @intCast(c_int, rects.len), color) < 0)
            return error.SDL2_Video;
    }
};

/// Copy and convert a block of pixels from one format to another.
pub fn convertPixels(w: c_int, h: c_int, src_format: u32, src: *const c_void, src_pitch: c_int,
                     dst_format: u32, dst: *c_void, dst_pitch: c_int) !void {
    if (c.SDL_ConvertPixels(w, h, src_format, src, src_pitch,
                            dst_format, dst, dst_pitch) < 0)
        return error.SDL2_ConvertPixels;
}

/// Function type used for blitting.
pub const Blit = fn (src: *Surface, src_rect: ?*Rect,
                     dest: *Surface, dest_rect: ?*Rect) c_int;

/// Blit source onto destination.
pub fn blitSurface(src: *Surface, srcrect: ?Rect, dst: *Surface, dstpoint: ?Point) !Rect {
    // Expand the point to a rectangle.  Default is 0, 0.
    var result = if (dstpoint) |dp| Rect{ .x=dp.x, .y=dp.y, .w=0, .h=0 }
                 else Rect{ .x=0, .y=0, .w=0, .h=0 };
    if (c.SDL_BlitSurface(src.native(), rectconv(&srcrect), dst.native(), @ptrCast(*c.SDL_Rect, &result)) < 0)
        return error.SDL2_Video;
    return result;
}

/// Blit source onto destination but don't clip or validate the rectangles.
pub fn blitSurfaceNoClip(src: *Surface, srcrect: ?Rect, dst: *Surface, dstpoint: ?Point) !Rect {
    // For some reason it takes the rectangle as mutable so make a local copy.
    var local_srcrect = srcrect;

    // Expand the point to a rectangle.  Default is 0, 0.
    var result = if (dstpoint) Rect{ .x=dstpoint.x, .y=dstpoint.y, .w=0, .h=0 }
                 else Rect{ .x=0, .y=0, .w=0, .h=0 };

    if (c.SDL_LowerBlit(src.native(), rectconv(&local_srcrect), dst.native(), @ptrCast(*c.SDL_Rect, &result)) < 0)
        return error.SDL2_Video;
    return result;
}

/// Blit source onto destination, stretching the source to fit
/// the destination.  Fast and low quality.  Not thread safe.
pub fn blitSurfaceStretch(src: *Surface, srcrect: ?Rect, dst: *Surface, dstrect: ?Rect) !void {
    if (c.SDL_SoftStretch(src.native(), rectconv(&srcrect), dst.native(), &dstrect) < 0)
        return error.SDL2_Video;
}



/// Blit source onto destination.
pub fn blitSurfaceScaled(src: *Surface, srcrect: ?Rect, dst: *Surface, dstpoint: ?Point) !Rect {
    // Expand the point to a rectangle.  Default is 0, 0.
    var result = if (dstpoint) Rect{ .x=dstpoint.x, .y=dstpoint.y, .w=0, .h=0 }
                 else Rect{ .x=0, .y=0, .w=0, .h=0 };
    if (c.SDL_BlitScaled(src.native(), rectconv(&srcrect), dst.native(), &result) < 0)
        return error.SDL2_Video;
    return result;
}

/// Blit source onto destination but don't clip or validate the rectangles.
pub fn blitSurfaceScaledNoClip(src: *Surface, srcrect: ?Rect, dst: *Surface, dstpoint: ?Point) !Rect {
    // For some reason it takes the rectangle as mutable so make a local copy.
    var local_srcrect = srcrect;

    // Expand the point to a rectangle.  Default is 0, 0.
    var result = if (dstpoint) Rect{ .x=dstpoint.x, .y=dstpoint.y, .w=0, .h=0 }
                 else Rect{ .x=0, .y=0, .w=0, .h=0 };

    if (c.SDL_LowerBlitScaled(src.native(), rectconv(&local_srcrect), dst.native(), &result) < 0)
        return error.SDL2_Video;
    return result;
}




/// Formula used to convert between YUV and RGB.
pub const YuvConversionMode = enum(u32) {
    /// Full range JPEG.
    jpeg,
    /// BT.601 (default).
    bt601,
    /// BT.709.
    bt709,
    /// BT.601 for SD content, BT.709 for HD content.
    automatic,
};

pub fn setYuvConversionMode(mode: YuvConversionMode) void {
    c.SDL_SetYuvConversionMode(@enumToInt(mode));
}
pub fn getYuvConversionMode() YuvConversionMode {
    return @intToEnum(YuvConversionMode, c.SDL_GetYuvConversionMode());
}
pub fn getYuvConversionModeForResolution(w: c_int, h: c_int) YuvConversionMode {
    return @intToEnum(YuvConversionMode, c.SDL_GetYuvConversionModeForResolution(w, h));
}
