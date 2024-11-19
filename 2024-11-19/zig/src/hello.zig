const std = @import("std");
//pub const Writer = std.io.Writer(File, WriteError, write);

// parse the CSV in some data structure
// two cities input (v0: hardcoded consts, v1: cli)
// calculate distance
//
// a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)`
// c = 2 ⋅ atan2( √a, √(1−a) )
// d = R ⋅ c
// # where: 	φ is latitude, λ is longitude, R is earth’s radius(if it wasn't flat, it would be somewhere around 6371 km).
// # note that angles need to be in radians to pass to trig functions!
// //

// "city","city_ascii","lat","lng","country","iso2","iso3","admin_name","capital","population","id"
// "Tokyo","Tokyo","35.6897","139.6922","Japan","JP","JPN","Tōkyō","primary","37732000","1392685764"

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"world"});
    try parseCsv();
}

const City = struct {
    name: []const u8, // 0
    lat: f32, // 2
    lng: f32, // 3
};

fn parseCsv() !void {
    const stdout = std.io.getStdOut().writer();
    const allocator = std.heap.page_allocator;

    var file = try std.fs.cwd().openFile("world-cities.csv", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try stdout.print("{s}!\n", .{line});
        var it = std.mem.split(u8, line, ",");

        var idx: usize = 0;
        const currentCityPtr = try allocator.create(City);
        defer allocator.destroy(currentCityPtr);

        var city: []const u8 = "";
        var lat: f32 = 0.0;
        var lng: f32 = 0.0;
        while (it.next()) |x| {
            std.debug.print("{s}{d}\n", .{ x.len, idx });
            const split: []const u8 = x[1..x.len];
            switch (idx) {
                0 => {
                    city = split;
                },
                2 => {
                    std.debug.print("{s}{d}\n", .{ split, idx });
                    lat = try std.fmt.parseFloat(f32, split);
                    // lat = try std.fmt.parseFloat(f32, tmp);
                },
                3 => {
                    lng = try std.fmt.parseFloat(f32, x);
                },
                else => {}
            }
            idx += 1;
        }
        currentCityPtr.* = .{ .name = "cityname", .lat = 0.1, .lng = 0.3 };
        // for (it, 0..) |x, i| {
        //     std.debug.print("{s}{s}\n", .{ x, i });
        // }
    }
}
