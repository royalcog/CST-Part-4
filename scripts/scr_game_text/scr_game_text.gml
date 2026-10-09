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
			scr_text("* How Do You Like Your Smoothie", "queen", 13);
			scr_text("* It's good...", "lancer", 0);
		break;
		
		case "self_2":
			scr_text("* You've Barely Touched It", "queen", 11);
			scr_text("* ...", "lancer", 6);
		break;
		
		case "self_3":
			scr_text("* Girldad?", "lancer", 7);
			scr_text("* Yes Dearie", "queen", 1);
			scr_text("* Why... would he do that?", "lancer", 11);
			scr_text("* Because Your Dad Is A Bad Guy", "queen", 10);
			scr_text("* Or So He Proclaims", "queen", 0);
			scr_text("* But I don't want him to just be the bad guy.", "lancer", 5);
			scr_text("* I want him to be my dad...", "lancer", 10);
			scr_text("* You're supposed to trust your family.", "lancer", 11);
			scr_text("* I trust you, I hope you trust me...", "lancer", 12);
			scr_text("* How Can I Not You're A Little Bouncy Dude", "queen", 25);
			scr_text("* ...", "lancer", 5);
			scr_text("* So why is it so hard to trust him?", "lancer", 10);
			scr_text("* He Clearly Struggles With Keeping Promises", "queen", 11);
			scr_text("* ...", "queen", 4);
				scr_obj_sprite_on_page(obj_queen, spr_queen_wine_right_unhappy, false);
			scr_text("* I'm Sorry You Have To: Deal With This", "queen", 3);
			scr_text("* If It Makes You Feel Any Better, I Don't Have A Dad", "queen", 5);
			scr_text("* I Kinda Just", "queen", 4);
			scr_text("* Existed|* Or Something", "queen", 0);
			scr_text("* Even If Your Dad Sucks", "queen", 15);
				scr_text_secondary("Which He Really Does", "queen", 13);
			scr_text("* At Least You Have A Parental Figure In Your Life", "queen", 10);
				scr_obj_sprite_on_page(obj_queen, spr_queen_wine_right, false);
			scr_text("* I know, I just...", "lancer", 4);
			scr_text("* I want him to act like my parental figure too.|* Not just be it.", "lancer", 12);
			scr_text("* That's A Valid Request", "queen", 30);
			scr_text("* Unfortunately Your Dad Does Not Seem Very Interested In The Whole Family Ordeal", "queen", 11);
			scr_text("* ...", "lancer", 11);
			scr_text("* Do you think... Is someone gonna get hurt?", "lancer", 7);
			scr_text("* I Wouldn't Be Surprised Based On Your Dad And Susie's Personalities", "queen", 15);
			scr_text("* Hopefully Ralsei Can Pacify Him, But If He Can't Then", "queen", 2);
			scr_text("* Uh", "queen", 3);
				scr_obj_sprite_on_page(obj_queen, spr_queen_wine_right_unhappy, false);
			scr_text("* ...", "queen", 5);
			scr_text("* Let Me Buy You Another Drink", "queen", 1);
				scr_obj_sprite_on_page(obj_queen, spr_queen_wine_right, false);
			scr_text("* ...", "lancer", 10);
		break;
		
		case "self_4":
			scr_fade_warp_with_music(rm_empty, 240, sng_empty, 1, 1000, 2000);
		break;
		
		case "self_5":
			scr_snd_after_textbox(snd_phone_ring, 1);
		break;
		
		case "self_6":
			scr_text("* Where are you?", "king", , , , true);
			scr_text("* ...", "king", , , , true);
			scr_text("* No, I am not rushing you, but", "king", , , , true);
				scr_text_cutoff_skip(31);
			scr_text("* ...", "king", , , , true);
			scr_text("* What?", "king", , , , true);
			scr_text("* ...", "king", , , , true);
			scr_text("* But that's not possible!", "king", , , , true);
			scr_text("* He was locked up", "king", , , , true);
				scr_text_cutoff_skip(18);
			scr_text("* ...", "king", , , , true);
			scr_text("* I am sorry.|* Please forgive me.", "king", , , , true);
			scr_text("* I...", "king", , , , true);
			scr_text("* Hey!!!", "susie", , , , true);
			scr_text("* ...", "king", , , , true);
			scr_text("* I must go.", "king", , , , true);
			scr_text("* I hope to see you soon.", "king", , , , true);
			scr_text("* (Click...)", "empty");
		break;
		
		case "self_7":
			scr_fade_warp_with_music(rm_one, 240, sng_cardjail, 1, 2000);
		break;
		
		case "self_8":
			scr_queue_movement_group_after_textbox([
				   { obj: obj_susie, sprite: spr_susie_walk_right_neutral, loop: true, dx: 4, dy: 0, speed: .8, duration: 75 },
				   { obj: obj_ralsei, sprite: spr_ralsei_walk_right_neutral, loop: true, dx: 4, dy: 0, speed: .8, duration: 75 }
			]);
		break;
		
		case "self_9":
			scr_text("* Where do you think you're going???", "susie", 19);
				scr_obj_sprite_on_page(obj_susie, spr_susie_pointright, false);
			scr_text("* I'm right where I need to be, Lightner.", "king", 0);
				scr_obj_sprite_on_page(obj_susie, spr_susie_right_neutral, false);
			scr_text("* King, please just go back to your cell.", "ralsei", 40);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_smile_right, false);
			scr_text("* Even if not that, at least stay in the castle a bit longer", "ralsei", 35);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_right, false);
				scr_text_cutoff_skip(60);
			scr_text("* I am done following your rules, Prince.", "king", 5);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_surprised, false);
			scr_text("* Your kingdom has nothing to offer me.", "king", 0);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_right_neutral, false);
			scr_text("* Not even an ex-royalty package.", "king", 4);
			scr_text("* You think this is a joke?", "susie", 18);
				scr_obj_sprite_on_page(obj_susie, spr_susie_angry, false);
			scr_text("* Isn't that how you go through life, Lightner?|* Everything being a joke?", "king", 0);
				scr_obj_sprite_on_page(obj_susie, spr_susie_surprised, false);
			scr_text("* All the friends you've made along your journey...", "king", 1);
				scr_obj_sprite_on_page(obj_susie, spr_susie_right_neutral, false);
			scr_text("* All the Darkners that you've helped, that you've battled...", "king", 2);
			scr_text("* Have you ever taken any of it seriously?", "king", 0);
			scr_text("* Has this week of adventure just been a satire for you?", "king", 4);
			scr_text("* The way you all prance around, interacting with the other dark worlds...", "king", 5);
			scr_text("* How do you sleep at night knowing you don't have this in your OWN world", "king", 4);
				scr_text_cutoff_skip(73);
			scr_text("* ENOUGH.", "susie", 33);
				scr_obj_sprite_on_page(obj_susie, spr_susie_angry, false);
			scr_text("* You think you're so special?", "susie", 32);
			scr_text("* Well, why don't I just go back up to the Light World...", "susie", 31);
			scr_text("* And tear your card in half, huh???", "susie", 33);
			scr_text("* How would you like that???", "susie", 36);
			scr_text("* Susie, you can't get to the card unless you seal the fountain...", "ralsei", 41);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_head_down_sad, false);
			scr_text("* ...Damn it.", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_walk_right_upset, false);
			scr_text("* What a foolish Lightner.", "king", 4);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_right_neutral, false);
				scr_obj_sprite_on_page(obj_susie, spr_susie_right_neutral, false);
			scr_text("* I bet your ice friend isn't much smarter than", "king", 0);
				scr_text_cutoff_skip(46);
			scr_text("* Don't you DARE talk about Noelle.", "susie", 61);
				scr_obj_sprite_on_page(obj_susie, spr_susie_angry, false);
			scr_text("* Or what, Susie?", "king", 0);
			scr_text("* Are you going to go back to your blissful ignorance of the true world?", "king", 7);
			scr_text("* Or will you bring her here and watch her di", "king", 4);
				scr_text_cutoff_skip(45);

				global.cutscene_lock = true;

				// remember where Susie's feet are so she gets knocked back to the same spot
				var _home = scr_get_feet(obj_susie);
				obj_susie.leap_home_x = _home.x;
				obj_susie.leap_home_y = _home.y;
				
				scr_obj_sprite_after_textbox(obj_ralsei, spr_ralsei_shocked_behind, false);
				scr_char_move_after_textbox(obj_susie, spr_susie_clash_jump, false, 5, -6, 1, 24, false, 0.05, "out");
				scr_snd_after_textbox(snd_boost, 1);

				// shortly after snd_boost's main hit dies down: swoon, then knockback when it ends
				scr_custom_call_after_textbox_delayed(function()
				{
				    // Card Jail cuts out hard right as the swoon lands
				    if (global.music != noone)
				    {
				        audio_stop_sound(global.music);
				        global.music = noone;
				        global.song = noone;
				    }
				    scr_swoon(spr_roark_slash_susie_1, 180, scr_susie_knockback);
				}, 40);
		break;

		case "self_10":
			global.cutscene_lock = true;
			scr_text("* N-No...", "ralsei", 34);
				scr_text_shake(1, 99);
			scr_text("* You...", "ralsei", 35);
				scr_text_shake(1, 99);
			scr_text("* What have you do", "ralsei", 41);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_head_down_sad, false);
				scr_text_shake(1, 99);
				scr_text_cutoff_skip(18);

			scr_custom_call_after_textbox_delayed(function()
			{
			    scr_swoon(spr_roark_slash_ralsei, 180, function()
			    {
			        scr_set_sprite_keep_feet(obj_ralsei, spr_ralsei_defeat);
			        scr_swoon_fall_sounds();
			        scr_camera_shake(4, 20);
			        global.cutscene_lock = false;
			    });
			}, 1);
		break;
			
		case "self_11":
			global.cutscene_lock = true;
			scr_text("* My Knight...", "king", 0);
				scr_custom_call_after_textbox_delayed(function()
				{
				    var _spot = scr_knight_spot_by_king();
				    scr_knight_fly_in(_spot.x, _spot.y);
				}, 1);
		break;
		
		case "self_12":
			global.cutscene_lock = true;
			scr_text("* Kneel...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* Of course.", "king", 5);
				scr_custom_call_after_textbox_delayed(scr_king_kneel, 0);
				scr_custom_call_after_textbox_delayed(function() {
				    scr_knighting_pose(spr_roark_knight_king);
				    global.cutscene_lock = false;
				}, 120);
		break;
		
		case "self_13":
			scr_text("* It is an honor.", "king", 0);
				scr_obj_sprite_on_page(obj_knight, spr_roark_knight_king_hand, false);
			scr_text("* Rise...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
				scr_custom_call_after_textbox_delayed(scr_knighting_rise, 0);
		break;
		
		case "self_14":
			scr_text("* Where is the other one?", "knight");
				scr_text_slow(0.3);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* I do not know, my Knight.|* They did not arrive with the rest of their party.", "king", 5);
			scr_text("* I need... all 3...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
				
				// stir for ~1 second
				scr_custom_call_after_textbox_delayed(function() {
				    scr_char_jolt(obj_susie, 1, 60);
				}, 0);
				
				// then switch to the landed (crouched) pose, keeping her feet planted
				scr_custom_call_after_textbox_delayed(function() {
				    scr_set_sprite_keep_feet(obj_susie, spr_susie_landed);
				    audio_play_sound(snd_hurt, 1, false);
				    global.cutscene_lock = false;
				}, 61);
		break;
		
		case "self_15":
			global.cutscene_lock = true;
			scr_text("* You...", "susie", 31);
			scr_text("* You won't... get Kris...", "susie", 31);
				// Knight turns around when this line shows up
				scr_call_on_page(function() {
				    with (obj_knight)
				    {
				        x += sprite_get_width(sprite_index) * image_xscale; // keep it in place (origin is top-left)
				        image_xscale = -image_xscale;
				    }
				}, 1, global.page_number - 1);
			
				// get up (3 frames at 6fps = 30 game frames)
				scr_custom_call_after_textbox_delayed(function() {
				    with (obj_susie)
				    {
				        sprite_index = spr_susie_getup;
				        image_index = 0;
				        image_speed = 1;
				        anim_loop = false;
				    }
				}, 0);
				
				// walk right a little (4 * 0.8 * 10 = 32px)
				scr_custom_call_after_textbox_delayed(function() {
				    scr_char_move_now(obj_susie, spr_susie_walk_right_neutral, true, 4, 0, 0.8, 10);
				}, 35);
				
				// then down to Ralsei (4 * 0.8 * 15 = 48px)
				scr_custom_call_after_textbox_delayed(function() {
				    scr_char_move_now(obj_susie, spr_susie_walk_down_neutral, true, 0, 4, 0.8, 12);
				}, 46);
				
				// heal, with the charge fading in
				scr_custom_call_after_textbox_delayed(function() {
				    // remember where her feet were next to downed Ralsei, so the second heal lines up the same
					var _sf = scr_get_feet(obj_susie);
				    var _rb = scr_get_body(obj_ralsei);
				    global.susie_heal_offset = { dx: _sf.x - _rb.x, dy: _sf.y - _rb.y };
				    
				    with (obj_susie)
				    {
				        sprite_index = spr_susie_heal;
				        image_index = 0;
				        image_speed = 1;
				        anim_loop = false; // freezes on her last frame
				        charge_snd = scr_audio_fade_in(snd_charge, 1000, 1, true);
				    }
				    
				    // the heal lands on frame 14
				    scr_call_on_anim_frame(obj_susie, spr_susie_heal, 14, function() {
				        audio_play_sound(snd_heal, 1, false);
				        
				        var _f = instance_create_depth(0, 0, obj_ralsei.depth - 1, obj_heal_flash);
				        _f.target = obj_ralsei;
				        _f.duration = 60;
				        _f.on_finish = function() {
				            // Ralsei gets up
				            scr_set_sprite_keep_feet(obj_ralsei, spr_ralsei_shocked);
				            
				            // his body sits ~21px left of center in spr_ralsei_defeat,
				            // so pull him back to where he was actually lying
				            var _ralsei_shift = 21;
				            obj_ralsei.x -= _ralsei_shift * obj_ralsei.image_xscale;
				            
				            // Susie finishes her heal, and the charge fades out
				            with (obj_susie)
				            {
				                sprite_index = spr_susie_heal_end;
				                image_index = 0;
				                image_speed = 1;
				                anim_loop = false;
				                audio_sound_gain(charge_snd, 0, 400); // fade out over 0.4s
				            }
				            scr_call_after_frames(function() {
				                audio_stop_sound(obj_susie.charge_snd);
				            }, 24); // 400ms = 24 frames, stop once it's silent
				            
				            // then turns to face him once heal_end is done (4 frames at 6fps = 40 game frames)
				            scr_call_after_frames(function() {
				                with (obj_susie)
				                {
				                    sprite_index = spr_susie_left_neutral;
				                    image_index = 0;
				                    image_speed = 0;
				                    anim_loop = true;
				                }
				                global.cutscene_lock = false;
				            }, 40);
				        };
				    });
				}, 62);
		break;
		
		case "self_16":
			scr_text("* You hear me?", "susie", 32);
				scr_char_move_on_page(obj_susie, spr_susie_walk_up, true, 0, -4, 0.8, 15)
				scr_obj_sprite_on_page_delayed(obj_susie, spr_susie_walk_up, false, 0, 15);
			scr_text("* You won't get Kris.|* You won't get any of us.", "susie", 33);
				scr_obj_sprite_on_page(obj_susie, spr_susie_walk_right_upset, false);
			scr_text("* This game you play?|* It won't stand.", "susie", 32);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_right_neutral, false);
			scr_text("* We close every fountain you open, no matter how many people you kidnap.", "susie", 33);
			scr_text("* Face it.|* We're too much for you to handle.", "susie", 34);
			scr_text("* Together, maybe...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* But without your... leader...", "knight");
				scr_text_slow(0.3);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* You are nothing...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* Nothing?", "susie", 32);
			scr_text("* Sorry to break it to you, pal, but we can ACT on our own.", "susie", 30);
			scr_text("* Haven't needed Kris to do that in a few days now.", "susie", 29);
			scr_text("* You are... helpless...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
				scr_text("* She... will die...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* I...", "susie", 24);
			scr_text("* ...", "susie", 31);
			scr_text("* Ralsei, I'm sorry, but...", "susie", 27);
			scr_text("* Try to hold them off for a bit.", "susie", 41);
			scr_text("* ???", "ralsei", 50);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_shocked, false);
			scr_text("* I need to go.", "susie", 31);
				// remember where she was standing, she walks back to this exact spot later
				scr_call_on_page(function() {
				    global.susie_battle_home = { x: obj_susie.x, y: obj_susie.y };
				}, 1, global.page_number - 1);
				scr_set_var_on_page(obj_susie, "depth", "-3001")
				scr_char_move_after_textbox(obj_susie, spr_susie_walk_down_upset, true, 0, 4, .8, 17);
				scr_char_move_after_textbox(obj_susie, spr_susie_walk_left_upset, true, -4, 0, .8, 85);
				scr_obj_sprite_after_textbox_delayed(obj_susie, spr_susie_walk_left_upset, false, 162);
				scr_obj_sprite_after_textbox_delayed(obj_ralsei, spr_ralsei_walk_left_neutral, false, 112);
		break;
		
		case "self_17":
			scr_text("* S-Susie! Wait!", "ralsei", 42);
				scr_set_var_on_page(obj_susie, "depth", "-2000")
			scr_text("* Coward.", "king", 0);
			scr_text("* ...", "ralsei", 45);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_left_annoyed_little, false);
			scr_text("* Nobody calls my friend a coward.", "ralsei", 44);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_right_annoyed_more, false);
				
				global.fight_seq_starting = true; // blocks Z until the battle's sequencer takes over
				scr_custom_call_after_textbox_delayed(function() {
				    obj_cutscenehandler_midfightattacks.ralsei_solo_state = 1;
				}, 0);
		break;
		
		case "self_18":
			scr_snd_after_textbox(snd_phone_ring, 1);
			scr_snd_after_textbox_delayed(snd_phone_ring, 1, 120);
			scr_snd_after_textbox_delayed(snd_phone_ring, 1, 240);
			scr_snd_after_textbox_delayed(snd_item, 1, 400);
		break;
		
		case "self_19":
			scr_text("* ...", "susie", 24);
			scr_text("* Hey.", "susie", 23);
			scr_text("* I assume you're asleep now, but...", "susie", 27);
			scr_text("* You can listen to this in the morning.", "susie", 28);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
		break;
		
		case "self_20":
			scr_text("* She'll be safe.", "susie", 32);
				// Play the track starting silent (gain 0), looping
				global.music_inst = audio_play_sound(sng_doalg, 10, true, 0);

				// Fade up to full volume over 2000 ms (2 seconds)
				audio_sound_gain(global.music_inst, 1, 2000);
			scr_text("* She's gotta be safe, right?", "susie", 27);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* I didn't see her fight, but...", "susie", 13);
			scr_text("* She can handle herself well.", "susie", 23);
			scr_text("* Or at least, that's what you made it seem like the other day.", "susie", 27);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* I can't...", "susie", 24);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* I won't be able to live with myself if she...", "susie", 23);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* But she won't, right?", "susie", 32);
			scr_text("* She managed to make it, even when she didn't know where she was...", "susie", 27);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* Damn it, Kris...", "susie", 31);
			scr_text("* She wasn't there against our battle with Queen.", "susie", 39);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* She wasn't there when we fought Spamton...", "susie", 37);
			scr_text("* How do I know?", "susie", 39);
			scr_text("* How do I know she's strong enough?", "susie", 38);
			scr_text("* She doesn't...", "susie", 36);
			scr_text("* She doesn't have any armor, or weapons, or anything...", "susie", 38);
			scr_text("* And how...", "susie", 40);
			scr_text("* How did King know she was coming???", "susie", 42);
			scr_text("* How did he know she has ice powers??? ", "susie", 43);
			scr_text("* I don't even think...", "susie", 24);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* I don't think I knew that.", "susie", 32);
			scr_text("* Did...", "susie", 32);
			scr_text("* ...", "susie", 31);
			scr_text("* Did you?", "susie", 62);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* I don't know if I can do this, Kris.", "susie", 32);
			scr_text("* She's too fragile, and...", "susie", 13);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* I know she's brave,", "susie", 56);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_happy_dark, false);
				scr_text_cutoff_skip(21);
			scr_text("* and funny,", "susie", 56);
				scr_text_cutoff_skip(12);
			scr_text("* and smart,", "susie", 56);
				scr_text_cutoff_skip(12);
			scr_text("* and sweet,", "susie", 56);
				scr_text_cutoff_skip(12);
			scr_text("* and caring,", "susie", 56);
				scr_text_cutoff_skip(13);
			scr_text("* and kind,", "susie", 56);
				scr_text_cutoff_skip(11);
			scr_text("* and everything you want in a person, but...", "susie", 56);
			scr_text("* ...", "susie", 24);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* Heh, this message is pretty long already.", "susie", 20);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_happy_dark, false);
			scr_text("* I'll, uh...", "susie", 13);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* You'll tell me what you think of all of this, won't you?", "susie", 23);
			scr_text("* ...", "susie", 24);
			scr_text("* And, uh...", "susie", 27);
			scr_text("* Thank you, Kris.", "susie", 28);
			scr_text("* For...", "susie", 27);
			scr_text("* For staying on our side.|* Through everything.", "susie", 23);
			scr_text("* See you in the morning.", "susie", 9);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_happy_dark, false);
			scr_text("* (Click...)", "empty");
		break;
		
		case "self_21":
			scr_text("* ...", "susie", 31);
				audio_sound_gain(global.music_inst, 0, 2000);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* I...", "susie", 32);
			scr_text("* ...", "susie", 31);
			scr_text("* Noelle...", "susie", 31);
			scr_text("* I don't really pray, but...", "susie", 32);
			scr_text("* Please be okay.", "susie", 28);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_dark, false);
			scr_text("* Let the Angel make it so.", "susie", 27);
			scr_text("* ...", "susie", 31);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_upset_dark, false);
			scr_text("* Wait, crap!|* Ralsei's still alone!", "susie", 15);
				scr_obj_sprite_on_page(obj_susie, spr_susie_sit_head_down_surprised_dark, false);
				scr_char_move_after_textbox(obj_susie, spr_susie_walk_left_l_dark, true, -4, 0, .8, 40);
				scr_char_move_after_textbox(obj_susie, spr_susie_walk_down_l_dark, true, 0, 4, 1.2, 90);
		break;
		
		case "self_22":
			scr_fade_warp_with_music(rm_empty, 240, sng_empty);
		break;
		
		case "self_23":
			scr_text("* Your worlds, your adventures, are all just corrupted visions of reality.", "friend");
			scr_text("* The Prince of Darkness...|* Oh, the Prince of Darkness.", "friend");
			scr_text("* He has been withholding countless scraps of information the heroes need.", "friend");
			scr_text("* His true power is soon to be reckoned with.", "friend");
			scr_text("* ...", "friend");
			scr_text("* The Cage...", "friend");
			scr_text("* Well, you know how the Cage fits into the Prophecy, don't you?", "friend");
			scr_text("* ...", "friend");
			scr_text("* And the MONSTER that accompanies them...", "friend");
						scr_text("* ...", "friend");
			
				// back to the stall fight: Knight gets re-spawned while it's still black,
				// and its setup rebuilds the battle exactly how it was left
				scr_fade_warp_with_music(rm_one, 360, noone, 1, 1000, 500, 0, [
				    scr_make_warp_spawn(obj_knight, 0, 0, "Instances", function(_k) {
				        scr_ralsei_battle_restore(_k);
				    })
				]);
		break;
		
		case "self_24":
			scr_text("* Y-You can't just...", "ralsei", 55);
			scr_text("* How did you...", "ralsei", 57);
			scr_text("* You know... what they call me...", "knight");
				scr_text_slow(0.35);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* What're they talking about???", "susie", 42);
				scr_obj_sprite_on_page(obj_susie, spr_susie_right_neutral_lookback, false);
			scr_text("* ...", "ralsei", 45);
				scr_obj_sprite_on_page(obj_ralsei, spr_ralsei_head_down_sad, false);
			scr_text("* Now...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
				
				global.cutscene_lock = true; // no Z until both of them are down
				
				// swoon on Ralsei -> he crashes down -> half a second later, swoon on Susie
				// (which cuts Ralsei's crash off) -> she crashes down
				scr_custom_call_after_textbox_delayed(function()
				{
				    scr_swoon(spr_roark_slash_ralsei, 180, function()
				    {
						scr_set_sprite_keep_feet(obj_ralsei, spr_ralsei_fall_wince);
						scr_set_sprite_keep_feet(obj_susie, spr_susie_shocked);
				        var _crash = scr_swoon_fall_sounds();
				        scr_camera_shake(4, 20);
				        
				        scr_call_after_frames(method({ crash: _crash }, function()
				        {
				            scr_stop_sounds(crash);
				            scr_swoon(spr_roark_slash_susie_2, 180, function()
				            {
								scr_set_sprite_keep_feet(obj_susie, spr_susie_landed);
				                scr_swoon_fall_sounds();
				                scr_camera_shake(4, 20);
				                global.cutscene_lock = false;
				            });
				        }), 30); // ~0.5s
				    });
				}, 1);
		break;
		
		case "self_25":
			scr_text("* Shall we do what was planned, my Knight?", "king", 0);
			scr_text("* Stay here...", "knight");
				scr_text_slow(0.2);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* Stand guard until we are prepared...", "knight");
				scr_text_slow(0.3);
				scr_text_shake(1, 99);
				scr_snd_on_page(snd_knight_phone_call, 1);
			scr_text("* Of course.", "king", 4);
			
				global.cutscene_lock = true; // locked until he's fully gone
				
				// back into the ball, then off the way he came in
				scr_custom_call_after_textbox_delayed(function()
				{
				    if (!instance_exists(obj_knight)) { global.cutscene_lock = false; exit; }
				    obj_knight.on_exit = function() { global.cutscene_lock = false; };
				    scr_knight_to_ball();
				}, 1);
		break;
		
		case "self_26":
			scr_text("* D-Damn it...", "susie", 31);
			scr_text("* Your time is over, Lightner.", "king", 0);
			scr_text("* Your world is long overdue for a change of scenery.", "king", 5);
			scr_text("* Or, in more definitive terms, a blanket of shadow.", "king", 4);
			scr_text("* King, please...|* You don't need to do this...", "ralsei", 34);
			scr_text("* Everyone is happy here...|* Lancer is happy here...", "ralsei", 35);
			scr_text("* Why do you want to destroy everything we've built here...?", "ralsei", 41);
			scr_text("* Before you jump to dull conclusions, Prince, not everyone is happy here.", "king", 5);
			scr_text("* How selfish can you be?", "susie", 33);
				// she gets back up (anim plays once, holds on the last frame)
				scr_call_on_page(function() {
				    with (obj_susie)
				    {
				        sprite_index = spr_susie_getup;
				        image_index = 0;
				        image_speed = 1;
				        anim_loop = false;
				    }
				}, 1, global.page_number - 1);
			scr_text("* Selfish?|* I am not the sole proprietor of unhappiness down here.", "king", 4);
			scr_text("* Find us one other person.", "susie", 32);
				scr_obj_sprite_on_page(obj_susie, spr_susie_walk_right_upset, false);
			scr_text("* ...", "king", 0);
			scr_text("* Cat got your tongue, King", "susie", 34);
				scr_text_cutoff_skip(27);
			scr_text("* Quiet.", "king", 0);
			scr_text("* Permit me time to think.", "king", 5);
			scr_text("* You...", "ralsei", 44);
			scr_text("* ...", "susie", 31);
			scr_text("* Lancer?", "susie", 42);
			scr_text("* Lancer...", "king", 2);
				// King turns around to look -> Susie slips over to Ralsei and heals him
				scr_call_on_page(function() {
				    scr_set_sprite_keep_body(obj_king, spr_king_walk_right);
				    
				    scr_call_after_frames(function() {
						// same spot next to his body as the first heal (fallback: just to his right)
				        var _off = variable_global_exists("susie_heal_offset") ? global.susie_heal_offset : { dx: 44, dy: 6 };
				        var _rb  = scr_get_body(obj_ralsei);
				        var _tx  = _rb.x + _off.dx;
				        var _ty  = _rb.y + _off.dy;
				        
				        global.susie_heal_busy = true; // the run-off waits on this, even during the walk over
				        global.susie_heal_then = undefined;
				        scr_walk_feet_to(obj_susie,
				            spr_susie_walk_left_upset, spr_susie_walk_right_upset,
				            spr_susie_walk_up, spr_susie_walk_down_upset,
				            _tx, _ty, 3.2,
				            function() { scr_susie_heal_ralsei(global.susie_heal_then); });
				    }, 20);
				}, 1, global.page_number - 1);
			scr_text("* C'mon, dude.", "susie", 30);
			
				global.cutscene_lock = true; // until they're both gone
				
				// both run off left — waits for the heal to finish if it's still going
				scr_custom_call_after_textbox_delayed(function()
				{
				    var _run = function()
				    {
				        scr_run_off_left([
				            { obj: obj_susie,  sprite: spr_susie_walk_left_upset },
				            { obj: obj_ralsei, sprite: spr_ralsei_walk_left_neutral }
				        ], 4, function() { global.cutscene_lock = false; });
				    };
				    
				    if (variable_global_exists("susie_heal_busy") && global.susie_heal_busy)
				    {
				        global.susie_heal_then = _run;
				    }
				    else
				    {
				        _run();
				    }
				}, 1);
		break;
		
		case "self_27":
			scr_text("* ...", "king", 6);
				scr_obj_sprite_on_page(obj_king, spr_king_walk_left, false);
			scr_text("* Damn it.", "king", 5);
		break;
		
		case "self_28":
			scr_fade_warp_with_music(rm_empty, 240, sng_empty);
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