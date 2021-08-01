const c = @cImport(@cInclude("SDL.h"));
const std = @import("std");

pub const StreamType = enum(u32) {
    unknown   = c.SDL_RWOPS_UNKNOWN,
    winfile   = c.SDL_RWOPS_WINFILE,
    stdfile   = c.SDL_RWOPS_STDFILE,
    jnifile   = c.SDL_RWOPS_JNIFILE,
    memory    = c.SDL_RWOPS_MEMORY,
    memory_ro = c.SDL_RWOPS_MEMORY_RO,
};

pub const Whence = enum(c_int) {
    set,
    current,
    end,
};

pub const RWops = c.SDL_RWops;

///////////////// Constructors //////////////////

pub fn rwFromFile(file: [*:0]const u8, mode: [*:0]const u8) !*RWops {
    return c.SDL_RWFromFile(file, mode)
           orelse error.SDL2_FailedToOpenFile;
}

pub fn rwFromStdioFile(file: *std.c.FILE, take_ownership: bool) !*RWops {
    return c.SDL_RWFromFP(file, take_ownership)
           orelse error.OutOfMemory;
}

pub fn rwFromMem(buffer: []u8) !*RWops {
    return c.SDL_RWFromMem(@ptrCast(*c_void, buffer.ptr), @intCast(c_int, buffer.len))
           orelse error.OutOfMemory;
}

pub fn rwFromConstMem(buffer: []const u8) !*RWops {
    return c.SDL_RWFromConstMem(@ptrCast(*const c_void, buffer.ptr), @intCast(c_int, buffer.len))
           orelse error.OutOfMemory;
}

pub fn rwAlloc() !*RWops {
    return c.SDL_AllowRW() orelse error.OutOfMemory;
}

pub fn rwFree(context: *RWops) void {
    c.SDL_FreeRW(context);
}

///////////////// Functions //////////////////

pub fn rwSize(context: *RWops) ?u64 {
    const size = c.SDL_RWsize(context);
    if (size < 0) return null;
    return @as(u64, size);
}

pub fn rwSeek(context: *RWops, offset: i64, whence: Whence) !u64 {
    const result = c.SDL_RWseek(context, offset, @enumToInt(whence));
    if (result < 0) return error.SDL2_FailedToSeek;
    return @as(u64, result);
}

pub fn rwTell(context: *RWops) !u64 {
    const result = c.SDL_RWtell(context);
    if (result < 0) return error.SDL2_FailedToSeek;
    return @as(u64, result);
}

pub fn rwRead(context: *RWops, buffer: *c_void, size: usize, maxnum: usize) usize {
    return c.SDL_RWread(context, buffer, size, maxnum);
}

pub fn rwReadSlice(context: *RWops, buffer: anytype) usize {
    const size = @sizeOf(@typeInfo(buffer).Pointer.child);
    return rwRead(context, @ptrCast(*c_void, buffer.ptr), size, buffer.len);
}

pub fn rwWrite(context: *RWops, buffer: *const c_void, size: usize, maxnum: usize) usize {
    return c.SDL_RWwrite(context, buffer, size, maxnum);
}

pub fn rwWriteSlice(context: *RWops, buffer: anytype) usize {
    const size = @sizeOf(@typeInfo(buffer).Pointer.child);
    return rwWrite(context, @ptrCast(*const c_void, buffer.ptr), size, buffer.len);
}

pub fn rwClose(context: *RWops) !void {
    if (c.SDL_RWclose(context) < 0)
        return error.SDL2_FailedToWrite;
}

///////////////// Read to string //////////////////

pub fn loadFile(file: [*:0]const u8) ![:0]u8 {
    var datasize: usize = undefined;
    const ptr = c.SDL_LoadFile(file, &datasize);
    if (!ptr) return error.SDL2_FailedToLoadFile;
    return ptr[0..datasize];
}

pub fn rwLoad(src: *RWops) ![:0]u8 {
    var datasize: usize = undefined;
    const ptr = c.SDL_LoadFile_RW(src, &datasize);
    if (!ptr) return error.SDL2_FailedToLoadFile;
    return ptr[0..datasize];
}

///////////////// Encode/decode numbers //////////////////

pub fn readU8(src: *RWops) u8 { return c.SDL_ReadU8(src); }
pub fn readLE16(src: *RWops) u16 { return c.SDL_ReadLE16(src); }
pub fn readLE32(src: *RWops) u32 { return c.SDL_ReadLE32(src); }
pub fn readLE64(src: *RWops) u64 { return c.SDL_ReadLE64(src); }
pub fn readBE16(src: *RWops) u16 { return c.SDL_ReadBE16(src); }
pub fn readBE32(src: *RWops) u32 { return c.SDL_ReadBE32(src); }
pub fn readBE64(src: *RWops) u64 { return c.SDL_ReadBE64(src); }

pub fn writeU8(src: *RWops, value: u8) usize { return c.SDL_WriteU8(src, value); }
pub fn writeLE16(src: *RWops, value: u16) usize { return c.SDL_WriteLE16(src, value); }
pub fn writeLE32(src: *RWops, value: u32) usize { return c.SDL_WriteLE32(src, value); }
pub fn writeLE64(src: *RWops, value: u64) usize { return c.SDL_WriteLE64(src, value); }
pub fn writeBE16(src: *RWops, value: u16) usize { return c.SDL_WriteBE16(src, value); }
pub fn writeBE32(src: *RWops, value: u32) usize { return c.SDL_WriteBE32(src, value); }
pub fn writeBE64(src: *RWops, value: u64) usize { return c.SDL_WriteBE64(src, value); }
