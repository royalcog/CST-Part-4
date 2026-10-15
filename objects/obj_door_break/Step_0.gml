t++;
flash = max(flash - 0.1, 0);

if (state == "cut" && t >= break_delay) do_break();

for (var i = array_length(chunks) - 1; i >= 0; i--)
{
    var _c = chunks[i];
    _c.t++;
    if (!_c.landed)
    {
        _c.vy += 0.35;
        _c.x  += _c.vx;
        _c.y  += _c.vy;
        _c.rot += _c.vr;
        if (_c.vy > 0 && _c.y >= _c.floor_y) { _c.y = _c.floor_y; _c.landed = true; }
    }
    if (_c.t >= 70) array_delete(chunks, i, 1);
}