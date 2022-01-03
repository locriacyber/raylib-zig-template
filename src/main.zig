const std = @import("std");
const rl = @import("raylib.zig");

pub fn main() anyerror!void {
    rl.InitWindow(600, 600, "<Untitled>");
    defer rl.CloseWindow();
    rl.SetTargetFPS(60);
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        defer rl.EndDrawing();
        rl.DrawText("This is a raylib game template", 20, 20, 20, rl.BLACK);
    }
}

test "test raylib version" {
    try std.testing.expect(std.mem.startsWith(u8, rl.RAYLIB_VERSION, "4."));
}
