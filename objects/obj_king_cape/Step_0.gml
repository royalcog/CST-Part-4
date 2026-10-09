var _target_x = obj_king.x + back_offset_x;
var _target_y = obj_king.y + back_offset_y;

x += (_target_x - x) * ease_speed;
y += (_target_y - y) * ease_speed;

if (point_distance(x, y, _target_x, _target_y) <= merge_dist)
{
    // cape has "merged" - delete both current sprites and swap king to his laugh sprite
    obj_king.sprite_index = spr_king_laugh;
    obj_king.image_index = 0;
    obj_king.image_speed = 1;

    audio_play_sound(snd_kinglaugh, 10, false);

    instance_destroy();
}