/// the end of the Knight fight. round 13's dialogue_batch is scr_knight_finale_batch(), and obj_knight_finale
/// does the heavy lifting for each beat (scr_knight_finale_play starts a beat, scr_knight_finale_idle says when it's done)

/// the battle stops for good: no more rounds, UI + music gone, anyone swooned gets back up for the scene
function scr_knight_finale_begin()
{
    with (obj_king_turn_sequencer) instance_destroy(); // so it never loops back to round 1
    scr_knight_stop_battle();
    if (instance_exists(obj_UI)) obj_UI.active_box = noone;
    with (obj_battle_ui_box)
    {
        selected_attack = false;
        if (hp <= 0) scr_party_revive(id);
    }
    global.knight_finale_done = false;
    if (!instance_exists(obj_knight_finale)) instance_create_depth(0, 0, -3500, obj_knight_finale);
}

function scr_knight_finale_play(_name)
{
    with (obj_knight_finale) play(_name);
}

function scr_knight_finale_idle()
{
    return !instance_exists(obj_knight_finale) || !obj_knight_finale.busy;
}

/// both of them made it inside
function scr_knight_finale_end()
{
    global.knight_finale_done = true;
    with (obj_knight_finale) instance_destroy();
    show_debug_message("Knight fight: finale done (next scene goes here)");
}

/// the whole scene, as round 13's dialogue
function scr_knight_finale_batch(_rk_cps)
{
    return [
        // the fight's over: UI + music go
        { run: scr_knight_finale_begin, wait: 30 },

        // the Knight swoons Susie, she blocks it
        { run: function() { scr_knight_swoon_block_susie(spr_roark_slash_susie_2, 50); },
          wait_until: function() { return global.knight_swoon_done; },
          wait: 15 },

        { speaker: obj_susie, text: "Nice try, as", instant_cutoff: true },

        // ...and again, and again, faster and faster
        { run: function() { scr_knight_finale_play("susie_rapid"); },    wait_until: scr_knight_finale_idle },

        // Ralsei throws up a barrier. the Knight stops for a second
        { run: function() { scr_knight_finale_play("ralsei_barrier"); }, wait_until: scr_knight_finale_idle, wait: 60 },

        // then hits it with everything
        { run: function() { scr_knight_finale_play("barrier_barrage"); }, wait_until: scr_knight_finale_idle },

        // King walks over, two spades, the barrier breaks
        { run: function() { scr_knight_finale_play("king_spades"); },    wait_until: scr_knight_finale_idle, wait: 15 },

        // both swooned
        { run: function() { scr_knight_finale_play("double_swoon"); },   wait_until: scr_knight_finale_idle, wait: 40 },

        { speaker: obj_knight, text: "Enough.", cps: _rk_cps, snd: snd_knight_phone_call },

        // back into the ball, into the castle door
        { run: function() { scr_knight_finale_play("knight_leave"); },   wait_until: scr_knight_finale_idle, wait: 30 },

        // they try to get up
        { run: function() { scr_knight_finale_play("struggle"); },       wait_until: scr_knight_finale_idle, wait: 20 },

        { speaker: obj_king,  text: "I admire your cleverness, heroes." },
        { speaker: obj_king,  text: "But your defense is nothing for our strategy." },
        { speaker: obj_susie, text: "C-Crap..." },

        // she gets up and starts for the castle
        { run: function() { scr_knight_finale_play("susie_getup"); },    wait_until: scr_knight_finale_idle },

        // King throws, she blocks and Rude Busters him back
        { run: function() { scr_knight_finale_play("king_counter"); },   wait_until: scr_knight_finale_idle, wait: 20 },

        // heals Ralsei from where she stands
        { run: function() { scr_knight_finale_play("heal_beam"); },      wait_until: scr_knight_finale_idle, wait: 15 },

        { speaker: obj_susie, text: "Come on!" },

        // to the castle door (this also starts the quick fade into the next room)
        { run: function() { scr_knight_finale_play("run_inside"); },     wait_until: scr_knight_finale_idle },

        { run: scr_knight_finale_end }
    ];
}