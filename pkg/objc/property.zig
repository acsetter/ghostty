const std = @import("std");
const c = @import("c.zig");
const objc = @import("main.zig");

pub const Property = extern struct {
    value: c.objc_property_t,

    /// Returns the name of a property.
    pub fn getName(self: Property) [:0]const u8 {
        return std.mem.sliceTo(c.property_getName(self.value), 0);
    }
};

test {
    // Critical properties because we ptrCast C pointers to this.
    const testing = std.testing;
    try testing.expect(@sizeOf(Property) == @sizeOf(c.objc_property_t));
    try testing.expect(@alignOf(Property) == @alignOf(c.objc_property_t));
}

test {
    const testing = std.testing;
    const NSObject = objc.Class.getClass("NSObject").?;

    const prop = NSObject.getProperty("className").?;
    try testing.expectEqualStrings("className", prop.getName());
}
