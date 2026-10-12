function scr_soul_take_hit(_amount, _color_top, _color_bottom)
{
    if (!instance_exists(obj_soul) || obj_soul.invulnerable) exit;

    // a random living ally actually loses the HP
    var _hit = scr_party_damage(_amount);

    // a Knight swoon shows SWOON over them instead of a number on the soul
    if (!_hit.swoon_popup)
    {
        scr_trigger_damage_popup(obj_soul, _amount, _color_top, _color_bottom);
    }

    obj_soul.invulnerable = true;
    obj_soul.invuln_timer = obj_soul.invuln_duration;
}