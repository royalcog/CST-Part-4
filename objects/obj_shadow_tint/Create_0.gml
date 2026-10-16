// darkish blue shadow over everything between the UI and the fountain
tint_r = 0.32;
tint_g = 0.36;
tint_b = 0.70;
strength = 1;          // 0-1, how much of the shadow applies

front_depth = -9000;   // layers at or in front of this are skipped (fades, textbox, UI)
back_depth  = 350;     // layers at or behind this are skipped (the fountain, the background)
skip_layers = ["Fountain", "Background", "UI", "Blackbox"];
skip_objs   = [obj_dark_fountain, obj_shadow_tint, obj_cutscenefade, obj_textbox];

// the room's own layers (anything else an instance sits on is a hidden "managed" depth layer)
room_layer_names = [];
var _all = layer_get_all();
for (var i = 0; i < array_length(_all); i++)
{
    var _n = layer_get_name(_all[i]);
    if (string_char_at(_n, 1) != "_") array_push(room_layer_names, _n);
}

if (!shader_is_compiled(shd_shadow_tint)) show_debug_message("shd_shadow_tint did NOT compile");