function scr_party_init(_members)
{
    global.party = _members;

    with (obj_battle_ui_box) instance_destroy(); // clear any leftover boxes from a previous fight

    for (var i = 0; i < array_length(_members); i++)
    {
        var _m = _members[i];
        var _box = instance_create_depth(0, 0, -100, obj_battle_ui_box);

        _box.char_name        = _m.name;
        _box.hp               = _m.hp;
        _box.max_hp           = _m.max_hp;
        _box.hp_current_x     = _m.hp_current_x;
		_box.hp_max_x         = _m.hp_max_x;
		_box.hp_text_offset_y = _m.hp_text_offset_y;
        _box.sprite_frame     = _m.sprite_frame;
		_box.hurt_frame       = _m.hurt_frame;
		_box.frame_scale      = _m.frame_scale;
		_box.bar_offset_x     = _m.bar_offset_x;
		_box.bar_offset_y     = _m.bar_offset_y;
		_box.bar_width        = _m.bar_width;
		_box.bar_height       = _m.bar_height;
		_box.bar_fill_color   = _m.bar_fill_color;
		_box.hp_current_x     = _m.hp_current_x;
		_box.hp_max_x         = _m.hp_max_x;
		_box.hp_text_offset_y = _m.hp_text_offset_y;
		_box.hurt_flash_time  = _m.hurt_flash_time;
		_box.box_offset_x     = _m.box_offset_x;
		_box.box_offset_y     = _m.box_offset_y;
		_box.divider_y	      = _m.divider_y;
		_box.icon_rect_x      = _m.icon_rect_x;
		_box.icon_rect_y      = _m.icon_rect_y;
		_box.icon_rect_w      = _m.icon_rect_w;
		_box.icon_rect_h      = _m.icon_rect_h;
		_box.hurt_icon_scale  = _m.hurt_icon_scale;
		_box.attack_frame     = variable_struct_exists(_m, "attack_frame") ? _m.attack_frame : _m.sprite_frame;
		_box.body             = variable_struct_exists(_m, "body") ? _m.body : noone;
		_box.body_hurt_sprite = variable_struct_exists(_m, "body_hurt_sprite") ? _m.body_hurt_sprite : -1;
		
		if (i == 0) obj_UI.active_box = _box;
    }

    obj_UI.use_party_boxes = true; // tell obj_UI to stop drawing its own sprite and let the boxes handle it
}

// ===================== RALSEI SOLO BATTLE (stall fight) =====================

/// UI + Ralsei's lone box, centered. _instant = already in place (coming back mid-battle)
function scr_ralsei_solo_ui_setup(_instant = false, _hp = 210)
{
    with (obj_UI) instance_destroy();
    instance_create_depth(0, 0, -100, obj_UI);

    // only Ralsei's box, same box_offset_x as the full-party layout,
    // so it sits in the middle slot as if Susie and Queen were on either side
    scr_party_init([
    {
        name: "Ralsei", hp: _hp, max_hp: 210, body: obj_ralsei, body_hurt_sprite: spr_ralsei_shocked,
        box_offset_x: 236, box_offset_y: 0,
        sprite_frame: spr_ralseibox_empty, hurt_frame: spr_ralseibox_hurtempty,
        frame_scale: 42 / 153, divider_y: 153,
        bar_offset_x: 513, bar_offset_y: 85, bar_width: 304, bar_height: 36,
        bar_fill_color: make_color_rgb(1, 255, 0),
        hp_current_x: 639, hp_max_x: 698, hp_text_offset_y: 33,
        hurt_flash_time: 20,
        attack_frame: spr_ralseibox_attack_empty,
        icon_rect_x: 36, icon_rect_y: 21, icon_rect_w: 137, icon_rect_h: 101, hurt_icon_scale: 0.95
    }
    ]);
    obj_UI.active_box = noone; // nobody's turn, box rests lowered the whole time

    // the full 3-box panel sits ~42px right of center; with only Ralsei's box showing
    // that's obvious, so center his box on screen for this fight
    var _cam_cx = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
    var _box_w  = sprite_get_width(spr_ralseibox_empty) * (42 / 153);
    var _box_cx = obj_UI.target_x + 236 + obj_UI.boxes_x_correction + _box_w / 2;
    var _ui_shift = _cam_cx - _box_cx; // ≈ -42
    obj_UI.target_x   += _ui_shift;
    obj_UI.onscreen_x += _ui_shift;

    // panel behind, box on top, both above everything else in the GUI layer
    // (TALKbox -9999, textbox -10000, swoon -10001)
    obj_UI.depth = -10002;
    obj_UI.panel_full_width = true;
    with (obj_battle_ui_box) depth = -10003;

    if (_instant) obj_UI.x = obj_UI.target_x; // no slide-in, the battle never "started" again
}

/// grabs everything about an instance a non-persistent room would throw away
function scr_inst_snapshot(_obj)
{
    if (!instance_exists(_obj)) return undefined;
    var _i = instance_find(_obj, 0);

    var _s = {
        x: _i.x, y: _i.y,
        sprite_index: _i.sprite_index, image_index: _i.image_index, image_speed: _i.image_speed,
        image_xscale: _i.image_xscale, image_yscale: _i.image_yscale,
        depth: _i.depth, visible: _i.visible,
        extra: {}
    };
    // object-specific state (Knight's hover, anim freeze flags, etc.) — only if the instance has it
    var _names = ["anim_loop", "start_y", "ball_phase", "bob_angle", "ball_target_x", "ball_speed", "exit_dir"];
    for (var n = 0; n < array_length(_names); n++)
    {
        if (variable_instance_exists(_i, _names[n]))
        {
            _s.extra[$ _names[n]] = variable_instance_get(_i, _names[n]);
        }
    }
    return _s;
}

function scr_inst_snapshot_apply(_inst, _s)
{
    if (_s == undefined || !instance_exists(_inst)) exit;
    with (_inst)
    {
        x = _s.x; y = _s.y;
        sprite_index = _s.sprite_index; image_index = _s.image_index; image_speed = _s.image_speed;
        image_xscale = _s.image_xscale; image_yscale = _s.image_yscale;
        depth = _s.depth; visible = _s.visible;
        last_sprite = sprite_index; // restored as-is, scr_auto_keep_feet shouldn't nudge it

        var _names = variable_struct_get_names(_s.extra);
        for (var n = 0; n < array_length(_names); n++)
        {
            variable_instance_set(id, _names[n], _s.extra[$ _names[n]]);
        }
    }
}

/// called by the stall fight's sequencer right before it fades out of rm_one
function scr_ralsei_battle_snapshot()
{
    var _hp = 210;
    with (obj_battle_ui_box) if (char_name == "Ralsei") _hp = hp;

    global.ralsei_battle_snap = {
        king:      scr_inst_snapshot(obj_king),
        ralsei:    scr_inst_snapshot(obj_ralsei),
        knight:    scr_inst_snapshot(obj_knight),
        ralsei_hp: _hp
    };
}

/// runs while the screen is still black after fading back into rm_one.
/// _knight is the fresh obj_knight from the warp's spawn_list.
function scr_ralsei_battle_restore(_knight)
{
    var _snap = variable_global_exists("ralsei_battle_snap") ? global.ralsei_battle_snap : undefined;
    var _hp = 210;

    if (_snap != undefined)
    {
        scr_inst_snapshot_apply(obj_king,   _snap.king);
        scr_inst_snapshot_apply(obj_ralsei, _snap.ralsei);
        scr_inst_snapshot_apply(_knight,    _snap.knight);
        _hp = _snap.ralsei_hp;
    }
    else
    {
        // testing fallback (warped here without playing the stall fight first):
        // King as placed, Ralsei in battle stance, Knight hovering by King, turned around
        with (obj_ralsei)
        {
            x += 240; // self_8's walk right
            sprite_index = spr_ralsei_battle_idle; last_sprite = sprite_index;
            image_index = 0; image_speed = 1; anim_loop = true;
        }
        var _spot = scr_knight_spot_by_king();
        with (_knight)
        {
            x = _spot.x; y = _spot.y;
            sprite_index = spr_roark_ball_to_knight;
            image_index = image_number - 1; image_speed = 0; anim_loop = false;
            x += sprite_get_width(sprite_index) * image_xscale; // same turn-around as self_15
            image_xscale = -image_xscale;
            start_y = y; bob_angle = 0; ball_phase = 3;
        }
    }

    // Susie waits just off the left edge, at the height she left from
    var _home = variable_global_exists("susie_battle_home") ? global.susie_battle_home
              : { x: obj_susie.x + 272, y: obj_susie.y - 10 }; // fallback guess
    var _walk_spd = 4 * 0.8; // same pace she ran off at
    var _dur = 0;
    with (obj_susie)
    {
        sprite_index = spr_susie_walk_right_upset; last_sprite = sprite_index;
        image_index = 0; image_speed = 0; anim_loop = false;
        depth = -2000;
        visible = true; image_alpha = 1;
        y = _home.y;

        var _off_x = camera_get_view_x(view_camera[0])
                   - (sprite_get_bbox_right(sprite_index) + 1 - sprite_get_xoffset(sprite_index)) * image_xscale - 8;
        _dur = ceil((_home.x - _off_x) / _walk_spd);
        x = round(_home.x - _dur * _walk_spd);
    }

    // battle UI already up, music back on (fading in with the picture)
    scr_ralsei_solo_ui_setup(true, _hp);
    global.song = noone; // or start_battle_music() thinks it's still playing
    start_battle_music();
    audio_sound_gain(global.music, 0, 0);
    audio_sound_gain(global.music, 1, 1500);

    // keep the UI under the black while the room fades in (UI is -10002/-10003)
    with (obj_cutscenefade) depth = -10004;

    global.fight_seq_starting = true; // no Z until the talk starts

    // once the fade-in's done (~100 frames), Susie walks back to her spot
    scr_call_after_frames(method({ home: _home, dur: _dur, spd: _walk_spd }, function()
    {
        scr_char_move_now(obj_susie, spr_susie_walk_right_upset, true, 4, 0, 0.8, dur);

        // arrived: lock exactly onto her spot, first frame, no loop, then the talk
        scr_call_after_frames(method(self, function()
        {
            with (obj_susie)
            {
                x = other.home.x;
                y = other.home.y;
                sprite_index = spr_susie_walk_right_upset;
                image_index = 0;
                image_speed = 0;
                anim_loop = false;
            }
            scr_ralsei_battle_resume_talk();
        }), dur + 2);
    }), 110);
}

/// Susie's back — the rest of the stall fight, ending with the Knight stopping the battle
function scr_ralsei_battle_resume_talk()
{
    with (obj_king_turn_sequencer) instance_destroy();
    var _seq = instance_create_depth(0, 0, 0, obj_king_turn_sequencer);
    _seq.dialogue_only   = true;
    _seq.end_warp_room   = noone;
    _seq.end_stop_battle = true;
    _seq.end_revert      = [ { obj: obj_ralsei, sprite: spr_ralsei_right_annoyed_more } ]; // his pose before the fight
    _seq.timer = 30; // short beat after she stops, before she speaks

    var _rk_cps = 0.15;
    _seq.rounds = [
        {
            attackers: [],
            dialogue_batch: [
                { speaker: obj_susie,  text: "Ralsei, you okay?" },
                { speaker: obj_ralsei, text: "I'm fine, Susie. I'm just stalling them." },
                { speaker: obj_king,   text: "You will get bored eventually, Prince. You can't stand here forever." },
                { speaker: obj_ralsei, text: "I waited so long for Kris and Susie to come here..." },
                { speaker: obj_ralsei, text: "Just watch me." },
                { speaker: obj_king,   text: "..." },
                { speaker: obj_knight, text: "Enough... of this...", cps: _rk_cps, snd: snd_knight_phone_call }
            ]
        }
    ];

    global.fight_seq_starting = false;
}

// ===================== SUSIE + RALSEI BATTLE (2-box layout) =====================

/// UI with just Susie's and Ralsei's boxes, the pair centered on screen
function scr_duo_ui_setup(_instant = false, _susie_hp = 290, _ralsei_hp = 210)
{
    with (obj_UI) instance_destroy();
    instance_create_depth(0, 0, -100, obj_UI);

    // same box offsets as the full-party layout, Queen's slot just isn't there
    scr_party_init([
    {
        name: "Susie", hp: _susie_hp, max_hp: 290, body: obj_susie, body_hurt_sprite: spr_susie_hurt,
        box_offset_x: -1, box_offset_y: -1,
        sprite_frame: spr_susiebox_empty, hurt_frame: spr_susiebox_hurtempty,
        frame_scale: 43 / 156, divider_y: 156,
        bar_offset_x: 516, bar_offset_y: 88, bar_width: 304, bar_height: 36,
        bar_fill_color: make_color_rgb(255, 0, 255),
        hp_current_x: 642, hp_max_x: 701, hp_text_offset_y: 36,
        hurt_flash_time: 20,
        attack_frame: spr_susiebox_attack_empty,
        icon_rect_x: 51, icon_rect_y: 36, icon_rect_w: 147, icon_rect_h: 102, hurt_icon_scale: 1
    },
    {
        name: "Ralsei", hp: _ralsei_hp, max_hp: 210, body: obj_ralsei, body_hurt_sprite: spr_ralsei_shocked,
        box_offset_x: 236, box_offset_y: 0,
        sprite_frame: spr_ralseibox_empty, hurt_frame: spr_ralseibox_hurtempty,
        frame_scale: 42 / 153, divider_y: 153,
        bar_offset_x: 513, bar_offset_y: 85, bar_width: 304, bar_height: 36,
        bar_fill_color: make_color_rgb(1, 255, 0),
        hp_current_x: 639, hp_max_x: 698, hp_text_offset_y: 33,
        hurt_flash_time: 20,
        attack_frame: spr_ralseibox_attack_empty,
        icon_rect_x: 36, icon_rect_y: 21, icon_rect_w: 137, icon_rect_h: 101, hurt_icon_scale: 0.95
    }
    ]);

    // center the pair: midpoint between Susie's left edge and Ralsei's right edge
    var _cam_cx   = camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) / 2;
    var _left     = obj_UI.target_x + (-1)  + obj_UI.boxes_x_correction;
    var _right    = obj_UI.target_x + 236   + obj_UI.boxes_x_correction
                  + sprite_get_width(spr_ralseibox_empty) * (42 / 153);
    var _ui_shift = _cam_cx - (_left + _right) / 2;
    obj_UI.target_x   += _ui_shift;
    obj_UI.onscreen_x += _ui_shift;

    // panel stretched edge to edge so there's no gap where Queen's box was
    obj_UI.panel_full_width = true;
    obj_UI.depth = -10002;
    with (obj_battle_ui_box) depth = -10003;

    if (_instant) obj_UI.x = obj_UI.target_x;
}

// ===================== KNIGHT FIGHT =====================

function scr_knight_damage(_amount, _color_top = c_white, _color_bottom = c_white)
{
    if (!instance_exists(obj_knight)) return noone;
    obj_knight.knight_hp = max(obj_knight.knight_hp - _amount, 0);
    audio_play_sound(snd_damagetaken, 1, false);
    return scr_trigger_damage_popup(obj_knight, _amount, _color_top, _color_bottom, obj_knight.hit_offset_x, obj_knight.hit_offset_y);
}

function scr_start_knight_attack1()
{
    return instance_create_depth(0, 0, obj_battlebox.depth - 1, obj_knight_sword_attack);
}

/// music + turn sequencer for the Knight fight. Call right after scr_duo_ui_setup().
function scr_start_knight_battle()
{
    start_knight_battle_music();

    with (obj_king_turn_sequencer) instance_destroy();
    var _seq = instance_create_depth(0, 0, 0, obj_king_turn_sequencer);
    _seq.damage_func = scr_knight_damage;
    _seq.king_box_x_nudge = 0; // the 2-box panel is centered, so the box is too

    // only two party members this fight: rebuild the select order without Queen's empty slot
    var _sb = noone, _rb = noone;
    for (var i = 0; i < instance_number(obj_battle_ui_box); i++)
    {
        var _b = instance_find(obj_battle_ui_box, i);
        if (_b.char_name == "Susie")  _sb = _b;
        if (_b.char_name == "Ralsei") _rb = _b;
    }
    _seq.members = [_sb, _rb];

    var _rk_cps = 0.15; // the Knight's slow talk speed

    var _party = [
        { box_name: "Susie",  damage: 115, color_top: make_color_rgb(255, 0, 255), color_bottom: make_color_rgb(255, 0, 255),
          attacker: obj_susie, ready_sprite: spr_susie_attack_ready, attack_sprite: spr_susie_battle_intro, idle_sprite: spr_susie_battle_idle,
          attack_sound: snd_attack },
        { box_name: "Ralsei", damage: 80,  color_top: make_color_rgb(1, 255, 0),   color_bottom: make_color_rgb(1, 255, 0),
          attacker: obj_ralsei, ready_sprite: spr_ralsei_attack_ready, attack_sprite: spr_ralsei_attack, idle_sprite: spr_ralsei_battle_idle,
          attack_sound: snd_attack }
    ];

    _seq.rounds = [
        // ROUND 1 — opening + Attack 1 (tracking swords)
        {
            attackers: _party,
            dialogue_batch: [
                { speaker: obj_susie,  text: "I hope you had time to heal yourself before we tear you to shreds again." },

                // Knight turns around and droops
                { run: function() {
                      with (obj_knight)
                      {
                          sprite_index = spr_roark_faceaway_turning;
                          image_index = 0;
                          image_speed = 1;
                          anim_loop = true;
                          global.knight_turning = true;
                      }
                  },
                  wait_until: function() { return !instance_exists(obj_knight) || obj_knight.sprite_index != spr_roark_faceaway_turning; },
                  wait: 20 },

                { speaker: obj_knight, text: "I recall... a different outcome...", cps: _rk_cps, snd: snd_knight_phone_call },
                { speaker: obj_susie,  text: "Then clearly your memory sucks." },

                // Knight gets up and draws his sword
                { run: function() {
                      with (obj_knight)
                      {
                          droop_up_stops_audio = false;
                          turn_sword_sound_played = false;
                          sprite_index = spr_roark_droop_up;
                          image_index = 0;
                          image_speed = 1;
                          anim_loop = false;
                      }
                  },
                  wait_until: function() { return !instance_exists(obj_knight) || (obj_knight.sprite_index == spr_roark_sword_appear_new && obj_knight.image_speed == 0); },
                  wait: 20 },

                { speaker: obj_knight, text: "...", cps: _rk_cps }
            ],
            king_box_attack: scr_start_knight_attack1
        }
        // rounds 2+ go here as they're built
    ];
}