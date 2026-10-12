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