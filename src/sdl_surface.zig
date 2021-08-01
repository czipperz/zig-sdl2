const c = @cImport(@cInclude("SDL.h"));
const std = @import("std");
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
        if (c.SDL_SetSurfaceBlendMode(surface.native(), &blend_mode) < 0)
            return error.SDL2_InvalidSurface;
        return @intToEnum(BlendMode, blend_mode);
    }

};

/// Function type used for blitting.
pub const Blit = fn (src: *Surface, src_rect: ?*Rect,
                     dest: *Surface, dest_rect: ?*Rect) c_int;

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
