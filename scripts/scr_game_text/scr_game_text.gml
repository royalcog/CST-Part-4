// scr_text_shake(23, 28); -> Shake the letters between (and indcluding) x and y
// scr_text_color(23, 28, color, color, color, color); -> Turn the letters between (and indcluding) x and y different colors
// scr_text_face_spr(LEFT, spr_noelle_left_happy); -> Turning a sprite a direction (4-directional only)
// scr_obj_spawn_after_textbox(obj_desscircle, 680, 215, "Instances"); -> Spawning an object after the full textbox is done
// scr_obj_sprite_after_textbox(obj_dess, spr_dess_intro_body, false, snd_appear, 0.7); -> Sprite animation after textbox is done
// scr_obj_sprite_after_textbox_delayed(obj_dess, spr_dess_drool, true, 60); -> Same as above, but with a delay
// scr_text_speaker_shake(.5, 1); -> Shake the speaker during the line of text
// scr_text_cutoff_slow(11, 11, 0.1); -> Slows down the text, and cuts it off at letter x

/// @param text_id
function scr_game_text(_text_id)
{
	switch (_text_id)
	{
		case "self_1":
			// both walk up together
			scr_queue_movement_group_after_textbox([
				   { obj: obj_susie,  sprite: spr_susie_walk_up,  loop: true, dx: 0, dy: -4, speed: .9, duration: 90 },
				   { obj: obj_ralsei, sprite: spr_ralsei_walk_up, loop: true, dx: 0, dy: -4, speed: .8, duration: 90 }
			]);
			// once both are done: Susie turns right, Ralsei walks left
			scr_queue_movement_group_after_textbox([
				   { obj: obj_susie,  sprite: spr_susie_walk_right_upset,   loop: false, dx: 0,  dy: 0, speed: 0,  duration: 0 },
				   { obj: obj_ralsei, sprite: spr_ralsei_walk_left_neutral, loop: true,  dx: -4, dy: 0, speed: .8, duration: 60 }
			]);
			// once Ralsei stops: he turns right
			scr_queue_movement_group_after_textbox([
				   { obj: obj_ralsei, sprite: spr_ralsei_right_neutral, loop: false, dx: 0, dy: 0, speed: 0, duration: 0 }
			]);
		break;
		
		
		case "self_2":
			scr_text("* Please...|* Don't do this...", "ralsei", 34);
			scr_text("* There's no gain to any of this...", "ralsei", 35);
			scr_text("* All you're doing is hurting everything and everyone, and...", "ralsei", 41);
			scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_head_down_sad, false);
			scr_text("* What's it all for???", "susie", 39);
			scr_text("* How do you live with yourself???", "susie", 37);
			scr_text("* There is... no gain...", "knight");
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_right_neutral, false);
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* This is all... just...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* Just what, huh?", "susie", 32);
			scr_text("* ...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* ...", "susie", 31);
			scr_text("* Fine.", "susie", 31);
			scr_text("* You want a chance at us?|* Again?", "susie", 32);
			scr_text("* After we kicked your ass the last time?", "susie", 33);
			scr_text("* Fine.", "susie", 31);
			scr_text("* Fine fine fine.|* By all means.", "susie", 32);
			scr_text("* Susie, I don't think...", "ralsei", 27);
			scr_text("* Too late.|* Already made up my mind.", "susie", 33);
			scr_text("* Is that... so...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);

				// Susie draws her weapon (plays once, holds the last frame)
				scr_custom_call_after_textbox_delayed(function()
				{
				    scr_set_battle_sprite(obj_susie, spr_susie_battle_intro, spr_susie_battle_idle, false);
				    audio_play_sound(snd_taking_out_sword, 1, false);
				}, 0);
		break;
		
		case "self_3":
			scr_text("* Hell yeah it is.", "susie", 34);
			scr_text("* ...", "ralsei", 45);

				// Ralsei draws (Susie already did at the end of self_2), then the battle starts
				scr_custom_call_after_textbox_delayed(function()
				{
				    scr_set_battle_sprite(obj_ralsei, spr_ralsei_battle_intro, spr_ralsei_battle_idle, false);
				    audio_play_sound(snd_taking_out_sword, 1, false);

				    scr_call_on_anim_frame(obj_ralsei, spr_ralsei_battle_intro, sprite_get_number(spr_ralsei_battle_intro) - 1, function()
				    {
				        scr_call_after_frames(function()
				        {
				            scr_set_battle_sprite(obj_susie,  spr_susie_battle_idle,  noone, true);
				            scr_set_battle_sprite(obj_ralsei, spr_ralsei_battle_idle, noone, true);

				            scr_duo_ui_setup();

				            scr_start_knight_battle();
				        }, 15);
				    });
				}, 0);
		break;
		
/*

*/


		/*array_push(obj_cutscenehandler_midfightattacks.after_textbox_queue, {
			type: "tenna_battle_intro"
			});*/
				
	
		/* Warp Code:
		if (instance_exists(obj_cutscenehandler_midfightattacks))
			    {
			        obj_cutscenehandler_midfightattacks.waiting_for_warp = true;
			    }
		*/
		
		/* Pitching Music:
			global.song = { sound: sng_?, bpm: ?, beats: ? };
			global.music = audio_play_sound(sng_?, 1, true);
			audio_sound_pitch(global.music, 0.7);
			global.song_start = current_time;
		*/
		/* Summoning UI (Not in battle):
			if (instance_exists(obj_UI))
			{
			    instance_destroy(obj_UI);
			}
			instance_create_depth(0, 0, -5000, obj_UI);
		    audio_stop_all();
		    global.song = { sound: sng_cmmm, bpm: 130, beats: 9999 };
			global.music = audio_play_sound(sng_cmmm, 1, true);
			audio_sound_pitch(global.music, 1.25);
			global.song_start = current_time;
		*/
		
		/* Movement Queue:
			scr_queue_movement_group_after_textbox([
				   { obj: obj_gerson, sprite: spr_gerson_hammer_walkright_lantern, loop: true, dx: 15, dy: 3, speed: .2, duration: 75 },
				   { obj: obj_mewmew, sprite: spr_ghost_shocked_left, loop: false, dx: 0, dy: -10, speed: .2, duration: 75 }
			]);
		*/
		
		// Battle Example:
		/* case "self_18":
			if (instance_exists(obj_UI))
			{
			    instance_destroy(obj_UI);
			}
			instance_create_depth(0, 0, -5000, obj_UI);
		    obj_UI.sprite_index = spr_UI_Pink;
			obj_mewmew.sprite_index = spr_ghost_shocked_left;
		    var pink = obj_mewmew;
		    var _seq = instance_create_depth(0, 0, 0, obj_fight_sequencer);
		    _seq.sequence = [
				{
			        type: "ui_sequence",
			        steps: [
			            { sprite: spr_UI_Pink, delay: 30 },
			            { sprite: spr_UI_Pink_Defend, snd: snd_select_reverb, delay: 30 },
			        ]
			    },
		        { type: "talk", batch: [ { speaker: pink, text: "Hey! Hey!!! HEY!!!"} ] },
				{ type: "talk", batch: [ { speaker: pink, text: "GERSON!!! I'M ON YOUR SIDE!!!" } ] },
				{ type: "talk", batch: [ { speaker: pink, text: "WHAT'S GOING ON???" } ] },
		        { type: "attack", attacker: obj_sound_of_justice, data: global.atk_sound_of_justice_hammers },
				{
			        type: "ui_sequence",
			        steps: [
			            { sprite: spr_UI_Pink, delay: 30 },
			            { sprite: spr_UI_Pink_Defend, snd: snd_select_reverb, delay: 30 },
			        ]
			    },
		        { type: "talk", batch: [ { speaker: pink, text: "DIDN'T WE PLAN TO DO THIS???" } ] },
				{ type: "talk", batch: [ { speaker: pink, text: "WHY ARE YOU ATTACKING ME???" } ] },
		        { type: "attack", kind: "custom", start_func: scr_start_giant_hammer_attack },
				{
			        type: "ui_sequence",
			        steps: [
			            { sprite: spr_UI_Pink, delay: 30 },
			            { sprite: spr_UI_Pink_Defend, snd: snd_select_reverb, delay: 30 },
			        ]
			    },
				{ type: "talk", batch: [ { speaker: pink, text: "You know I can't take damage... right???" } ] },
				{ type: "talk", batch: [ { speaker: pink, text: "So... quit it!!!" } ] },
				{ type: "attack", kind: "custom", start_func: scr_start_falling_hammer_attack },
				{
			        type: "ui_sequence",
			        steps: [
			            { sprite: spr_UI_Pink, delay: 30 },
			            { sprite: spr_UI_Pink_Defend, snd: snd_select_reverb, delay: 30 },
			        ]
			    },
				{ type: "sprite", target: obj_mewmew, new_sprite: spr_ghost_wistful },
				{ type: "talk", batch: [ { speaker: pink, text: "We need to... find my body..." } ] },
				{ type: "sprite", target: obj_mewmew, new_sprite: spr_ghost_yelling_right },
				{ type: "talk", batch: [ { speaker: pink, text: "Damn it, Gerson, don't you double-cross me too!!!" } ] },
				{ type: "sprite", target: obj_mewmew, new_sprite: spr_ghost_shocked_left },
				{ type: "attack", kind: "custom", start_func: scr_start_gavel_slam_attack },
				{
			        type: "ui_sequence",
			        steps: [
			            { sprite: spr_UI_Pink, delay: 30 },
			            { sprite: spr_UI_Pink_Defend, snd: snd_select_reverb, delay: 30 },
			        ]
			    },
				{ type: "sprite", target: obj_mewmew, new_sprite: spr_ghost_wistful },
				{ type: "talk", batch: [ { speaker: pink, text: "Come on, Gerson. I don't want to fight you." } ] },
				{ type: "talk", batch: [ { speaker: pink, text: "So stop fighting me..." } ] },
		        // add more talk/attack pairs as you write more dialogue/attacks
		    ];		
		break;
		
		case "self_19":
			scr_ui_reverse(sng_empty);
			audio_stop_all();
			scr_text("* Please...", "mewmewghost");
				scr_portrait_on_page(spr_pinkghost_scared);
	        scr_portrait_tail_off();
	        scr_snd_after_textbox(snd_sojlaugh, 1);
	        scr_obj_sprite_after_textbox(obj_sound_of_justice, spr_sound_of_justice_laugh, true);
	        scr_custom_call_after_textbox_delayed(scr_spawn_soj_hit_hammer, 113); // mid-laugh hammer hit
			scr_obj_sprite_after_textbox_delayed(obj_mewmew, spr_ghost_shocked_left, false, 120);
	        scr_custom_call_after_textbox_delayed(scr_start_pan_and_reveal_left, 150); // shortly after the hit
		break;
	*/
	}
}