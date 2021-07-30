pub const Point = extern struct {
    x: c_int,
    y: c_int,

    pub fn inRect(point: Point, rect: Rect) bool {
        return c.SDL_PointInRect(&point, &rect) != 0;
    }
};

pub const FPoint = extern struct {
    x: c_float,
    y: c_float,
};

pub const Line = extern struct {
    x1: c_int,
    y1: c_int,
    x2: c_int,
    y2: c_int,

    pub fn intersectRect(line: Line, rect: Rect) ?Line {
        return rect.intersectLine(line);
    }
};

pub const Rect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,

    pub fn empty(rect: Rect) bool {
        return c.SDL_RectEmpty(&rect) != 0;
    }

    pub fn eql(left: Rect, right: Rect) bool {
        return c.SDL_RectEquals(&left, &right) != 0;
    }

    pub fn hasIntersection(first: Rect, second: Rect) bool {
        return c.SDL_HasIntersection(&first, second);
    }

    pub fn intersection(first: Rect, second: Rect) ?Rect {
        var result: Rect = undefined;
        if (c.SDL_IntersectRect(&first, &second, &result) == 0) return null;
        return result;
    }

    pub fn union_with(first: Rect, second: Rect) Rect {
        var result: Rect = undefined;
        c.SDL_UnionRect(&first, &second, &result);
        return result;
    }

    pub fn enclosing(points: []Point, clip: ?Rect) ?Rect {
        var result: Rect = undefined;
        if (c.SDL_EnclosePoints(points.ptr, @intCast(c_int, points.len),
                                if (clip) &clip else null, &result) == 0)
            return null;
        return result;
    }

    pub fn intersectLine(rect: Rect, line: Line) ?Line {
        var result = line;
        if (SDL_IntersectRectAndLine(&rect, &result.x1, &result.y1,
                                     &result.x2, &result.y2) == 0)
            return null;
        return result;
    }
};

pub const FRect = extern struct {
    x: c_float,
    y: c_float,
    w: c_float,
    h: c_float,
};
