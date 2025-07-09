const std = @import("std");

const c = @cImport({
    @cInclude("cdt.h");
    @cInclude("cgraph.h");
    @cInclude("hello.h");
});

pub fn main() !void {
    _ = c.hello();
}
