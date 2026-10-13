move_speed = 2;
invulnerable = false;
invuln_timer = 0;
invuln_duration = 90; // ~1.5 seconds at 60fps — a bit more breathing room after getting hit
flash_visible = true;
flash_timer = 0;
flash_interval = 6; // frames between flash toggles — faster flicker, same total invuln window
hdir = 0;
vdir = 0;

split_controlled = false; // true while the split-box attack is moving/drawing the soul itself

external_move = false; // true while an attack moves the soul itself (still drawn normally)

// light blue mode (from the Knight's 5th attack on): 3x3 grid, 4 directions
base_sprite      = sprite_index;
lightblue_sprite = asset_get_index("spr_soul_lightblue"); // -1 until it exists; drawn tinted until then
lightblue_color  = make_color_rgb(66, 252, 255);
grid_lerp        = 0.35; // how quickly it glides to the next sector
grid_ready_dist  = 3;    // how close it has to be before the next move goes through
grid_c = 1;
grid_r = 1;
grid_buffer = -1;
soul_mode = "red";
scr_soul_set_mode(id, variable_global_exists("soul_mode") ? global.soul_mode : "red");

grid_alpha        = 0;
grid_alpha_moving = 0.3;  // while gliding to another sector
grid_alpha_idle   = 0.1;  // sitting still (0 = only shows while moving)
grid_line_w       = 2;