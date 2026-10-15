// the castle door in Tiles_1 gets cut and smashed in. obj_rm_one_scene calls slash()
depth = 250; // over the tiles, under the cauldron and everyone

// the door panels in the tiles (the base of the door is 380,196)
door_x1 = 338;  door_y1 = 90;
door_x2 = 426;  door_y2 = 197;
open_radius  = 18;      // how round the top of the doorway is
open_color   = c_black;

// the cut: top-right to bottom-left across the door
cut_x1 = door_x2 + 16;  cut_y1 = door_y1 - 8;
cut_x2 = door_x1 - 16;  cut_y2 = door_y2 - 14;
cut_width   = 14;
cut_frames  = 12;       // how long the cut line stays
break_delay = 8;        // frames after the cut before the door goes
cut_sound   = snd_knight_cut;

// the panels getting smashed in
smash_frames = 26;
chunk_count  = 18;

// --- state ---
state  = "idle";   // idle -> cut -> broken
t      = 0;
door_spr  = -1;    // the door's own pixels, grabbed off the tilemap the first Draw
left_spr  = -1;
right_spr = -1;
chunks = [];
flash  = 0;

slash = function()
{
    if (state != "idle") return;
    state = "cut";
    t = 0;
    flash = 1;
    audio_play_sound(cut_sound, 1, false);
}

do_break = function()
{
    state = "broken";
    t = 0;
    audio_play_sound(snd_impact, 1, false);
    audio_play_sound(snd_closet_impact, 1, false);
    scr_camera_shake(5, 15);

    // bits of the door spat out along the cut
    for (var i = 0; i < chunk_count; i++)
    {
        var _k  = random(1);
        var _sz = irandom_range(5, 10);
        array_push(chunks, {
            x: lerp(cut_x1, cut_x2, _k), y: lerp(cut_y1, cut_y2, _k),
            vx: random_range(-3.5, 3.5), vy: random_range(-4, -1),
            rot: random(360), vr: random_range(-14, 14),
            sx: irandom(door_x2 - door_x1 - _sz), sy: irandom(door_y2 - door_y1 - _sz), sz: _sz,
            floor_y: door_y2 + random_range(4, 40), t: 0, landed: false
        });
    }
}