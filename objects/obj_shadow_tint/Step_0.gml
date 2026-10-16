// re-hooked every frame so the hidden depth layers (Susie/Ralsei set depth in Create) get it too
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