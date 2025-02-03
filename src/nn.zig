const std = @import("std");
const testing = std.testing;

pub extern fn openMyWindow() void;


extern fn showImage(b: [*c]u8) void;

pub fn playing1() !void {
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
//
//
// pub fn playing() !void {
//     var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//     defer arena.deinit();
//     const allocator = arena.allocator();
//     const exe_dir = try std.fs.selfExeDirPathAlloc(allocator);
//
//     var data_batches: [6][]u8 = undefined; 
//
//     const file_names: [6][]const u8 = .{
//         "/../Data/data_batch_1.bin",
//         "/../Data/data_batch_2.bin",
//         "/../Data/data_batch_3.bin",
//         "/../Data/data_batch_4.bin",
//         "/../Data/data_batch_5.bin",
//         "/../Data/test_batch.bin",
//     };
//
//     for (&data_batches, file_names) |*batch, name| {
//         batch.* = allocator.alloc(u8, 30730000) catch {
//             std.debug.print("Could not allocate memory\n", .{});
//             std.process.exit(1);
//         };
//         const arr: [2][]const u8 = .{exe_dir, name};
//         const file_loc = try std.mem.concat(allocator, u8, &arr);
//         const file = std.fs.cwd().openFile(
//             file_loc,
//             .{},
//         ) catch {
//             std.debug.print("Could not open the file {s}\n", .{name});
//             std.process.exit(1);
//         };
//         defer file.close();
//
//         const read_num = file.read(batch.*) catch {
//             std.debug.print("Could not fetch first 3073 bytes\n", .{});
//             std.process.exit(1);
//         };
//         if (read_num != 30730000) {
//             std.debug.print("Not all the data was read!\n", .{});
//             std.process.exit(1);
//         }
//     }
//     std.debug.print("type: {}\n", .{data_batches[0][0]});
//     showImage(@ptrCast(data_batches[0]));
// }
