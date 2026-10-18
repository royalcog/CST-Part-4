var _cam = view_camera[0];
var _vx = camera_get_view_x(_cam), _vy = camera_get_view_y(_cam);
var _vw = camera_get_view_width(_cam), _vh = camera_get_view_height(_cam);

// the beam, from off the top of the screen down to the shield (or past the floor once it breaks)
if (beam_on && beam_w > 0)
{
    var _sy = _vy - 60;
    draw_beam(line_x(_sy), _sy, beam_ex, beam_ey, beam_w);

    // where it meets the shield
    if (shield.on)
    {
        gpu_set_blendmode(bm_add);
        draw_set_color(c_white);
        draw_set_alpha(0.7 + 0.3 * sin(beam_t * 0.5));
        draw_ellipse(beam_ex - 40, beam_ey - 12, beam_ex + 40, beam_ey + 12, false);
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
    }
}

// Ralsei's shield
if (shield.on)
{
    var _g  = 1 - power(1 - shield.grow, 3);
    var _ha = shield_arc * _g;   // grows out from its top
    var _p  = 0.75 + 0.25 * sin(shield.t * 0.2);
    var _n  = 32;
    var _th = shield_th;

    gpu_set_blendmode(bm_add);
    draw_set_color(shield_color);
    for (var _pass = 0; _pass < 2; _pass++)
    {
        var _w = (_pass == 0) ? _th * 2.2 : _th;
        draw_set_alpha((_pass == 0) ? 0.15 * _p : 0.4 * _p);
        draw_primitive_begin(pr_trianglestrip);
        for (var i = 0; i <= _n; i++)
        {
            var _a = lerp(-_ha, _ha, i / _n);
            var _in = shield_point(_a, -_w / 2), _out = shield_point(_a, _w / 2);
            draw_vertex(_in.x, _in.y);
            draw_vertex(_out.x, _out.y);
        }
        draw_primitive_end();
    }

    // bright edges
    draw_set_alpha(0.9 * _p);
    for (var i = 0; i < _n; i++)
    {
        var _a1 = lerp(-_ha, _ha, i / _n), _a2 = lerp(-_ha, _ha, (i + 1) / _n);
        var _o1 = shield_point(_a1, _th / 2),  _o2 = shield_point(_a2, _th / 2);
        var _i1 = shield_point(_a1, -_th / 2), _i2 = shield_point(_a2, -_th / 2);
        draw_line_width(_o1.x, _o1.y, _o2.x, _o2.y, 2);
        draw_line_width(_i1.x, _i1.y, _i2.x, _i2.y, 1);
    }

    // glints running along it
    draw_set_color(c_white);
    for (var k = 0; k < 3; k++)
    {
        var _q = shield_point(lerp(-_ha, _ha, frac(shield.t / 70 + k / 3)), 0);
        draw_set_alpha(0.6 * _p);
        draw_circle(_q.x, _q.y, 3, false);
    }

    // flash on hits / cracks
    if (shield.flash > 0)
    {
        draw_set_color(shield_color);
        draw_set_alpha(shield.flash * 0.7);
        draw_primitive_begin(pr_trianglestrip);
        for (var i = 0; i <= _n; i++)
        {
            var _a = lerp(-_ha, _ha, i / _n);
            var _in = shield_point(_a, -_th), _out = shield_point(_a, _th);
            draw_vertex(_in.x, _in.y);
            draw_vertex(_out.x, _out.y);
        }
        draw_primitive_end();
    }
    gpu_set_blendmode(bm_normal);

    // cracks
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    for (var k = 0; k < array_length(shield.cracks); k++)
    {
        var _pts = shield.cracks[k];
        for (var j = 0; j < array_length(_pts) - 1; j++)
        {
            var _a = shield_point(_pts[j][0], _pts[j][1]), _b = shield_point(_pts[j + 1][0], _pts[j + 1][1]);
            draw_line_width(_a.x, _a.y, _b.x, _b.y, 1);
        }
    }
    draw_set_alpha(1);
}

// shards + sparks
gpu_set_blendmode(bm_add);
draw_set_color(shield_color);
for (var i = 0; i < array_length(shards); i++)
{
    var _p = shards[i];
    draw_set_alpha(1 - _p.t / 45);
    draw_line_width(_p.x - lengthdir_x(_p.len, _p.rot), _p.y - lengthdir_y(_p.len, _p.rot),
                    _p.x + lengthdir_x(_p.len, _p.rot), _p.y + lengthdir_y(_p.len, _p.rot), 2);
}
for (var i = 0; i < array_length(sparks); i++)
{
    var _p = sparks[i];
    draw_set_color(merge_color(c_white, shield_color, _p.t / _p.life));
    draw_set_alpha(1 - _p.t / _p.life);
    draw_line_width(_p.x, _p.y, _p.x - _p.vx * 2, _p.y - _p.vy * 2, 2);
}
gpu_set_blendmode(bm_normal);

// white flash
if (flash > 0)
{
    draw_set_color(c_white);
    draw_set_alpha(flash);
    draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
}
draw_set_alpha(1);
draw_set_color(c_white);