const std = @import("std");

fn useSdl(step: *std.build.LibExeObjStep) void {
    step.addIncludeDir("SDL/include");
    step.addLibPath("SDL/lib/x64");
    step.linkSystemLibrary("SDL2");
    step.linkSystemLibrary("c");
}

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("sdl2", "src/main.zig");
    lib.setBuildMode(mode);
    useSdl(lib);
    lib.install();

    var main_tests = b.addTest("src/test.zig");
    useSdl(main_tests);
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
