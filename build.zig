const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "nn",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // exe.addLibraryPath(.{ .cwd_relative = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/swift" });
    // exe.addRPath(.{ .cwd_relative = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/swift" });

    // exe.linkSystemLibrary("swiftCore");
    // exe.linkSystemLibrary("swiftIOKit");
    // exe.linkSystemLibrary("swiftCoreFoundation");
    // exe.linkSystemLibrary("swiftXPC");
    // exe.linkSystemLibrary("swiftunistd");
    // exe.linkSystemLibrary("swiftUniformTypeIdentifiers");
    // exe.linkSystemLibrary("swift_Builtin_float");
    // exe.linkSystemLibrary("swiftos");
    // exe.linkSystemLibrary("swift_math");
    // exe.linkSystemLibrary("swiftsys_time");
    // exe.linkSystemLibrary("swift_signal");
    // exe.linkSystemLibrary("swiftSpatial");
    // exe.linkSystemLibrary("swiftCoreImage");
    // exe.linkSystemLibrary("swift_time");
    // exe.linkSystemLibrary("swiftObjectiveC");
    // exe.linkSystemLibrary("swiftOSLog");
    // exe.linkSystemLibrary("swift_stdio");
    // exe.linkSystemLibrary("swiftMetal");
    // exe.linkSystemLibrary("swiftQuartzCore");
    // exe.linkSystemLibrary("swiftsimd");
    // exe.linkSystemLibrary("swiftDispatch");
    // exe.linkSystemLibrary("swiftDarwin");
    // exe.linkSystemLibrary("swift_errno");

    exe.linkFramework("Cocoa");
    // exe.linkFramework("swiftUI");
    // exe.linkFramework("appKit");
    exe.addObjectFile(b.path("macos/linkmy.o"));


    const output = b.addInstallArtifact(exe, .{.dest_dir = .{
        .override = .{ .custom = "my.app/Contents/MacOS" }}});
    b.getInstallStep().dependOn(&output.step);


    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
