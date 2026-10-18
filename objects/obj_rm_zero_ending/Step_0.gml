st++;

switch (state)
{
    case "enter":   // up from below
    {
        var _a = move_feet(lancer, king_x + lancer_start_dx, arrive_y, enter_speed);
        var _b = move_feet(queen,  king_x + queen_start_dx,  arrive_y + 10, enter_speed);
        if (_b && queen.image_speed != 0) pose(queen, spr_queen_walk_up);
        if (_a && _b && (!instance_exists(obj_cutscenefade) || obj_cutscenefade.fade_alpha <= 0)) go("arrived");
    }
    break;

    case "arrived":
        if (st >= 20) { create_textbox("rm0_1"); go("t1"); }
    break;

    case "t1":   // he goes over to him
        if (!instance_exists(obj_textbox)) { pose(lancer, spr_lancer_right_sad); go("rush"); }
    break;

    case "rush":
        if (move_feet(lancer, king_x + lancer_by_king_dx, king_y + lancer_by_king_dy, lancer_rush_speed))
        {
            pose(queen, spr_queen_walk_right_unhappy);
            go("by_king");
        }
    break;

    case "by_king":
        if (st >= 20) { create_textbox("rm0_2"); go("t2"); }
    break;

    case "t2":   // he runs into the castle
        if (!instance_exists(obj_textbox)) { pose(lancer, spr_lancer_up); go("run"); }
    break;

    case "run":
        if (instance_exists(lancer))
        {
            var _f = scr_get_feet(lancer);
            lancer.image_alpha = clamp(point_distance(_f.x, _f.y, door_x, door_y) / door_fade, 0, 1);
            if (move_feet(lancer, door_x, door_y, lancer_run_speed)) { instance_destroy(lancer); lancer = noone; go("gone"); }
        }
        else go("gone");
    break;

    case "gone":
        if (st >= 30) { create_textbox("rm0_3"); go("t3"); }
    break;

    case "t3":   // she walks over to him, slowly
        if (!instance_exists(obj_textbox)) { pose(queen, spr_queen_walk_right_unhappy, queen_walk_anim); go("walk"); }
    break;

    case "walk":
        if (move_feet(queen, king_x + queen_by_king_dx, king_y + queen_by_king_dy, queen_walk_speed))
        {
            pose(queen, spr_queen_walk_right_unhappy);
            go("by_king2");
        }
    break;

    case "by_king2":
        if (st >= 30) { create_textbox("rm0_4"); go("t4"); }
    break;

    case "t4":   // his line gets cut off as she throws: straight to black
        if (!instance_exists(obj_textbox))
        {
            var _f = instance_create_depth(0, 0, -9999, obj_cutscenefade);
            _f.fade_back_same_room = true;
            _f.hold_black  = true;
            _f.fade_alpha  = 1;
            _f.fade_target = 1;
            audio_stop_all();
            if (end_sound != noone) audio_play_sound(end_sound, 1, false);
            go("end");
        }
    break;

    case "end":
        // END
    break;
}