// 1. anyone sitting on a hidden managed depth layer (set depth = in Create, like Susie/Ralsei)
//    gets moved onto a real layer at the exact same depth, so draw order doesn't change
with (all)
{
    if (array_contains(other.skip_objs, object_index)) continue;
    if (depth <= other.front_depth || depth >= other.back_depth) continue;

    var _ln = layer_exists(layer) ? layer_get_name(layer) : "";
    if (array_contains(other.room_layer_names, _ln)) continue;  // already on a room layer
    if (string_pos("shadow_", _ln) == 1) continue;             // already moved

    var _d    = depth;
    var _name = "shadow_" + string(_d);
    var _l    = layer_exists(_name) ? layer_get_id(_name) : layer_create(_d, _name);
    layer = _l;
}

// 2. hook the tint onto every layer in range (room layers + the shadow_ ones)
var _layers = layer_get_all();
for (var i = 0; i < array_length(_layers); i++)
{
    var _l = _layers[i];
    var _d = layer_get_depth(_l);
    if (_d <= front_depth || _d >= back_depth) continue;
    if (array_contains(skip_layers, layer_get_name(_l))) continue;

    layer_script_begin(_l, scr_shadow_tint_begin);
    layer_script_end(_l, scr_shadow_tint_end);
}