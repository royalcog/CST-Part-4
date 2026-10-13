if (split_controlled) exit; // obj_knight_split_attack draws the pieces

if (soul_mode == "lightblue" && lightblue_sprite == -1)
{
    // no light blue sprite yet: the normal soul, flat-tinted
    gpu_set_fog(true, lightblue_color, 0, 1);
    draw_sprite_ext(sprite_index, image_index, round(x), round(y), image_xscale, image_yscale, image_angle, c_white, image_alpha);
    gpu_set_fog(false, c_black, 0, 0);
}
else
{
    draw_sprite_ext(sprite_index, image_index, round(x), round(y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}