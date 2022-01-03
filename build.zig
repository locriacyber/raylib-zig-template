const std = @import("std");

const raylibDir = "raylib";

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("compress-4-game", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    linkRaylib(exe, raylibDir);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);
    linkRaylib(exe_tests, raylibDir);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

pub fn linkRaylib(exe: *std.build.LibExeObjStep, comptime sourceDir: []const u8) void {
    exe.addIncludeDir(sourceDir ++ "/src");
    exe.addObjectFile(sourceDir ++ "/raylib/libraylib.a");
    exe.linkLibC();
    for ([_][]const u8{"m", "pthread", "glfw", "dl", "X11", "xcb", "Xau", "Xdmcp"}) |libname| {
        exe.linkSystemLibrary(libname);
    }
}