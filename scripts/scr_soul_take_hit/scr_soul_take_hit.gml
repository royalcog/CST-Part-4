function scr_soul_take_hit(_amount, _color_top, _color_bottom)
{
    if (instance_exists(obj_soul) && !obj_soul.invulnerable)
    {
        scr_trigger_damage_popup(obj_soul, _amount, _color_top, _color_bottom);
        scr_party_damage(_amount); // soul shows the hit; a random living ally actually loses the HP
        obj_soul.invulnerable = true;
        obj_soul.invuln_timer = obj_soul.invuln_duration;
    }
}