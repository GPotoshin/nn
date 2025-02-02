const std = @import("std");
const testing = std.testing;

extern fn showImage(b: [*c]u8) void;

pub fn playing() !void {
    const file_name = "../Data/data_batch_1.bin";

    const file_data = std.fs.cwd().openFile(
        file_name,
        .{},
    ) catch {
        std.debug.print("Could not open the file {s}\n", .{file_name});
        std.process.exit(1);
    };
    defer file_data.close();

    var buffer: [3073]u8 = undefined;
    const read_num = file_data.read(&buffer) catch {
        std.debug.print("Could not fetch first 3073 bytes\n", .{});
        std.process.exit(1);
    };
    _ = read_num;

    std.debug.print("type: {}\n", .{buffer[0]});
    showImage(@ptrCast(&buffer));
}
