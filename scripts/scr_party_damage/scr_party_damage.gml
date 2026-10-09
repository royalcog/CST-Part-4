function scr_party_damage(_amount)
{
    var _candidates = [];
    with (obj_battle_ui_box)
    {
        if (hp > 0) array_push(_candidates, id);
    }

    if (array_length(_candidates) == 0) exit; // whole party's down

    var _target = _candidates[irandom(array_length(_candidates) - 1)];

    with (_target)
    {
        hp = max(hp - _amount, 0);
        hurt_timer = hurt_flash_time;
        scr_party_body_hurt();
    }
}

// runs from inside an obj_battle_ui_box
function scr_party_body_hurt()
{
    if (body == noone || body_hurt_sprite == -1) exit;

    var _inst = instance_find(body, 0);
    if (!instance_exists(_inst)) exit;

    // only save the pose if they're not already mid-hurt, so a second hit
    // doesn't save the hurt sprite as the one to go back to
    if (body_hurt_timer <= 0)
    {
        body_inst = _inst;
        body_saved = {
            sprite: _inst.sprite_index,
            index:  _inst.image_index,
            spd:    _inst.image_speed,
            loop:   _inst.anim_loop,
            x:      _inst.x
        };
    }

    with (_inst)
    {
        sprite_index = other.body_hurt_sprite;
        image_index = 0;
        image_speed = 0;
    }

    body_hurt_timer = body_hurt_time;
}