const std = @import("std");
const testing = std.testing;

// extern fn showImage(b: [*c]u8) void;

const image_size: u32 = 3073;
const images_in_batch: u32 = 10000;

const file_names: [6][]const u8 = .{
    "/../Data/data_batch_1.bin",
    "/../Data/data_batch_2.bin",
    "/../Data/data_batch_3.bin",
    "/../Data/data_batch_4.bin",
    "/../Data/data_batch_5.bin",
    "/../Data/test_batch.bin",
};

// Benchmark 10x10000 iterations:
// fast: 30ms, debug: 1130ms 
fn dist1v1(img1: [*]u8, img2: [*]u8) u64 {
    var retval: u64 = 0;

    for (1..image_size) |i| {
        retval += @abs(@as(i32, @intCast(img1[i]))-@as(i32, @intCast(img2[i])));
    }

    return retval;
}

// No threads, fast full batch: 24922ms
// 4 threads: 10043ms
fn compare_against(test_slice: []u8, batch_data: [*]u8, out: *u32) void {
    var best_distance: u64 = (1<<64)-1;
    var best_guess: u8 = 0;

    for (0..test_slice.len/image_size) |test_ind| {
        const test_img: [*]u8 = test_slice.ptr + test_ind*image_size;
        const test_img_type: u8 = test_img[0];

        for (0..images_in_batch) |comp_ind| {
            const comp_img: [*]u8 = batch_data + comp_ind*image_size;
            const comp_img_type: u8 = comp_img[0];
            const dist = dist1v1(test_img, comp_img);

            if (dist < best_distance) {
                best_guess = comp_img_type;
                best_distance = dist;
            }
        }
        if (test_img_type == best_guess) {
            out.* += 1;
        }
    }
}

pub fn playing() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const exe_dir = try std.fs.selfExeDirPathAlloc(allocator);

    var data_batches: [6][]u8 = undefined; 


    for (&data_batches, file_names) |*batch, name| {
        const file_size: u32 = image_size*images_in_batch;
        batch.* = allocator.alloc(u8, file_size) catch {
            std.debug.print("Could not allocate memory\n", .{});
            std.process.exit(1);
        };
        const arr: [2][]const u8 = .{exe_dir, name};
        const file_loc = try std.mem.concat(allocator, u8, &arr);
        const file = std.fs.cwd().openFile(
            file_loc,
            .{},
        ) catch {
            std.debug.print("Could not open the file {s}\n", .{name});
            std.process.exit(1);
        };
        defer file.close();

        const read_num = file.read(batch.*) catch {
            std.debug.print("Could not fetch first 3073 bytes\n", .{});
            std.process.exit(1);
        };
        if (read_num != file_size) {
            std.debug.print("Not all the data was read!\n", .{});
            std.process.exit(1);
        }
    }

    std.debug.print("Comparing agains first batch ...\n", .{});
    var success_counter: u32 = 0;
    
    const threadCount: u32 = 5; 
    var subcounts: [threadCount]u32 = .{0} ** threadCount;
    var threads: [threadCount]std.Thread = undefined;

    const start_time = std.time.milliTimestamp();
    for (0..threadCount) |i| {
        const split_size: u32 = image_size*images_in_batch/threadCount;
        threads[i] = try std.Thread.spawn(.{}, compare_against, .{
            data_batches[5][i*split_size..(i+1)*split_size],
            data_batches[0].ptr,
            &subcounts[i]
        });
    }
    for (0..threadCount) |i| {
        threads[i].join();
        success_counter += subcounts[i];
    }
    const time_diff = std.time.milliTimestamp() - start_time;
    std.debug.print("time spend: {}ms\n", .{time_diff});

    std.debug.print("Success rate: {}/{}\n", .{success_counter, images_in_batch});

    // showImage(@ptrCast(data_batches[0]));
}

test "abs" {
    const a: u8 = 7;
    const b: u8 = 9;
    std.debug.print("7-9: {}\n", .{@abs(a-b)});
}
