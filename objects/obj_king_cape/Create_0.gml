image_speed = 0;
image_index = 0;

image_xscale = 2;
image_yscale = 2;
depth = obj_king.depth - 1; // adjust if it needs to draw behind him instead

back_offset_x = 46;
back_offset_y = 37;

ease_speed = 0.15;
merge_dist = 4;

depth = -99999; // draw on top of everything so the darken rect covers the whole scene

audio_play_sound(snd_boost, 10, false);