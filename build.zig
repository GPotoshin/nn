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

    exe.addLibraryPath(.{ .cwd_relative = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/swift" });
    exe.addRPath(.{ .cwd_relative = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/swift" });
    exe.linkSystemLibrary2("swiftCore", .{ .weak = true });
    exe.linkSystemLibrary2("swiftIOKit", .{ .weak = true });
    exe.linkSystemLibrary2("swiftCoreFoundation", .{ .weak = true });
    exe.linkSystemLibrary2("swiftXPC", .{ .weak = true });
    exe.linkSystemLibrary2("swiftunistd", .{ .weak = true });
    exe.linkSystemLibrary2("swiftUniformTypeIdentifiers", .{ .weak = true });
    exe.linkSystemLibrary2("swift_Builtin_float", .{ .weak = true });
    exe.linkSystemLibrary2("swiftos", .{ .weak = true });
    exe.linkSystemLibrary2("swift_math", .{ .weak = true });
    exe.linkSystemLibrary2("swiftsys_time", .{ .weak = true });
    exe.linkSystemLibrary2("swift_signal", .{ .weak = true });
    exe.linkSystemLibrary2("swiftSpatial", .{ .weak = true });
    exe.linkSystemLibrary2("swiftCoreImage", .{ .weak = true });
    exe.linkSystemLibrary2("swift_time", .{ .weak = true });
    exe.linkSystemLibrary2("swiftObjectiveC", .{ .weak = true });
    exe.linkSystemLibrary2("swiftOSLog", .{ .weak = true });
    exe.linkSystemLibrary2("swift_stdio", .{ .weak = true });
    exe.linkSystemLibrary2("swiftMetal", .{ .weak = true });
    exe.linkSystemLibrary2("swiftQuartzCore", .{ .weak = true });
    exe.linkSystemLibrary2("swiftsimd", .{ .weak = true });
    exe.linkSystemLibrary2("swiftDispatch", .{ .weak = true });
    exe.linkSystemLibrary2("swiftDarwin", .{ .weak = true });
    exe.linkSystemLibrary2("swift_errno", .{ .weak = true });

    exe.linkFrameworkWeak("swiftUI");
    exe.linkFrameworkWeak("appKit");
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
