for (var i = 0; i < array_length(swords); i++)
{
    var _s = swords[i];
    if (_s.gone || _s.delay > 0) continue;
    draw_sprite_ext(spr_roark_sword2, 0, _s.x, _s.y, sword_scale, sword_scale, 0, c_white, _s.alpha);
}