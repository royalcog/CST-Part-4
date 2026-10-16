// darkish blue shadow over everything between the UI and the fountain
tint_r = 0.32;
tint_g = 0.36;
tint_b = 0.70;
strength = 1;          // 0-1, how much of the shadow applies

front_depth = -9000;   // layers at or in front of this are skipped (fades, textbox, UI)
back_depth  = 350;     // layers at or behind this are skipped (the fountain, the background)
skip_layers = ["Fountain", "Background", "UI", "Blackbox"];