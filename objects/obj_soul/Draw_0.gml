// draw_sprite() ignores image_blend entirely — that's why the invuln
// flash (which sets image_blend to red/white in Step) was never actually
// showing up visually, even though the underlying flash_visible/invuln
// data was toggling correctly the whole time. draw_sprite_ext respects it.
draw_sprite_ext(sprite_index, image_index, round(x), round(y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);