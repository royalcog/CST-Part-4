// --- Ralsei's barrier ---
if (barrier.on)
{
    var _g  = 1 - power(1 - barrier.grow, 3);
    var _cy = (barrier.y1 + barrier.y2) / 2;
    var _hh = (barrier.y2 - barrier.y1) / 2 * _g;
    var _ya = _cy - _hh, _yb = _cy + _hh;
    var _h  = max(_yb - _ya, 1);
    var _p  = 0.75 + 0.25 * sin(barrier.t * 0.2);

    gpu_set_blendmode(bm_add);
    draw_set_color(ralsei_color);
    draw_set_alpha(0.25 * _p);
    draw_rectangle(barrier.x1 - 4, _ya, barrier.x2 + 4, _yb, false); // soft glow
    draw_set_alpha(0.35 * _p);
    draw_rectangle(barrier.x1, _ya, barrier.x2, _yb, false);

    // bands sweeping down it
    draw_set_alpha(0.3);
    for (var k = 0; k < 4; k++)
    {
        var _yy = _ya + ((barrier.t * 1.5 + k * _h / 4) mod _h);
        draw_line_width(barrier.x1, _yy, barrier.x2, _yy, 2);
    }

    // bright edges
    draw_set_alpha(0.9 * _p);
    draw_line_width(barrier.x1, _ya, barrier.x1, _yb, 2);
    draw_line_width(barrier.x2, _ya, barrier.x2, _yb, 2);
    draw_line_width(barrier.x1, _ya, barrier.x2, _ya, 2);
    draw_line_width(barrier.x1, _yb, barrier.x2, _yb, 2);

    // flash on every hit
    if (barrier.flash > 0)
    {
        draw_set_color(c_white);
        draw_set_alpha(barrier.flash * 0.8);
        draw_rectangle(barrier.x1 - 4, _ya, barrier.x2 + 4, _yb, false);
    }
    gpu_set_blendmode(bm_normal);

    // cracks
    draw_set_color(c_white);
    draw_set_alpha(0.9);
    for (var k = 0; k < array_length(barrier.cracks); k++)
    {
        var _ck = barrier.cracks[k];
        if (_ck.y1 < _ya || _ck.y2 > _yb) continue;
        draw_line_width(_ck.x1, _ck.y1, _ck.x2, _ck.y2, 1);
    }
}

// --- barrier shards ---
gpu_set_blendmode(bm_add);
draw_set_color(ralsei_color);
for (var i = 0; i < array_length(shards); i++)
{
    var _p = shards[i];
    draw_set_alpha(1 - _p.t / 45);
    draw_line_width(_p.x - lengthdir_x(_p.len, _p.rot), _p.y - lengthdir_y(_p.len, _p.rot),
                    _p.x + lengthdir_x(_p.len, _p.rot), _p.y + lengthdir_y(_p.len, _p.rot), 2);
}
gpu_set_blendmode(bm_normal);
draw_set_alpha(1);
draw_set_color(c_white);

// --- spades + chunks ---
for (var i = 0; i < array_length(spades); i++)
{
    var _s = spades[i];
    draw_sprite_ext(spr_spade, 0, _s.x, _s.y, spade_scale, spade_scale, _s.rot, c_white, 1);
}
for (var i = 0; i < array_length(chunks); i++)
{
    var _c = chunks[i];
    draw_sprite_ext(spr_spadechunk, 0, _c.x, _c.y, 0.35, 0.35, _c.rot, c_white, 1 - _c.t / 30);
}

// --- heal beam ---
if (beam.on)
{
    var _n = array_length(beam.trail);
    for (var j = _n - 1; j >= 0; j--)
    {
        var _tr = beam.trail[j];
        draw_sprite_ext(spr_healbeam, floor(beam.frame) mod sprite_get_number(spr_healbeam), _tr.x, _tr.y,
                        beam_scale, beam_scale, beam.dir, c_white, 0.35 * (1 - (j + 1) / (_n + 1)));
    }
    gpu_set_blendmode(bm_add);
    draw_set_color(ralsei_color);
    draw_set_alpha(0.35);
    draw_circle(beam.x, beam.y, 10, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_sprite_ext(spr_healbeam, floor(beam.frame) mod sprite_get_number(spr_healbeam), beam.x, beam.y,
                    beam_scale, beam_scale, beam.dir, c_white, 1);
}

// --- the Knight's ball heading into the door ---
if (ball.on && ball.alpha > 0)
{
    var _w = sprite_get_width(spr_roark_ball), _h = sprite_get_height(spr_roark_ball);
    var _sx = ball.scale * ball.xs;
    // the sprite's origin is its top-left, so offset to draw it centred on ball.x/ball.y
    var _dx = ball.x - (_w / 2) * _sx;
    var _dy = ball.y - (_h / 2) * ball.scale;
    draw_sprite_ext(spr_roark_ball, floor(ball.frame) mod sprite_get_number(spr_roark_ball), _dx, _dy,
                    _sx, ball.scale, 0, c_white, ball.alpha);
}