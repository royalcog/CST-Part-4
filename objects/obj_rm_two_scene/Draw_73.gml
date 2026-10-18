// the white streak they drop through: a slanted bar that shrinks away.
// in Draw End so it's on top of the Knight and everyone else
if (flash_t >= 0)
{
    var _k   = flash_t / flash_time;
    var _cx  = (sword_x_from + sword_x_to) / 2;
    var _hw  = flash_w * (1 - _k) / 2;
    var _top = sword_y + flash_top;
    var _bot = edge_y;
    draw_set_color(c_white);
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(_cx - _hw - flash_skew, _top);
    draw_vertex(_cx + _hw - flash_skew, _top);
    draw_vertex(_cx - _hw + flash_skew, _bot);
    draw_vertex(_cx + _hw + flash_skew, _bot);
    draw_primitive_end();
    draw_set_color(c_white);
}