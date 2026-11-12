// Original pixel art and the 224x288 frame. Nothing here is copied from a ROM.

function bb_glyph(_ch) {
    switch (_ch) {
        case "A": return ["#.#", "###", "#.#", "#.#", "#.#"];
        case "B": return ["##.", "#.#", "##.", "#.#", "##."];
        case "C": return ["###", "#..", "#..", "#..", "###"];
        case "D": return ["##.", "#.#", "#.#", "#.#", "##."];
        case "E": return ["###", "#..", "##.", "#..", "###"];
        case "F": return ["###", "#..", "##.", "#..", "#.."];
        case "G": return ["###", "#..", "#.#", "#.#", "###"];
        case "H": return ["#.#", "#.#", "###", "#.#", "#.#"];
        case "I": return [".#.", ".#.", ".#.", ".#.", ".#."];
        case "J": return ["..#", "..#", "..#", "#.#", "###"];
        case "K": return ["#.#", "##.", "#..", "##.", "#.#"];
        case "L": return ["#..", "#..", "#..", "#..", "###"];
        case "M": return ["#.#", "###", "#.#", "#.#", "#.#"];
        case "N": return ["#.#", "###", "###", "#.#", "#.#"];
        case "O": return ["###", "#.#", "#.#", "#.#", "###"];
        case "P": return ["###", "#.#", "###", "#..", "#.."];
        case "Q": return ["###", "#.#", "#.#", "##.", ".#."];
        case "R": return ["##.", "#.#", "##.", "#.#", "#.#"];
        case "S": return ["###", "#..", "###", "..#", "###"];
        case "T": return ["###", ".#.", ".#.", ".#.", ".#."];
        case "U": return ["#.#", "#.#", "#.#", "#.#", "###"];
        case "V": return ["#.#", "#.#", "#.#", "#.#", ".#."];
        case "W": return ["#.#", "#.#", "#.#", "###", "#.#"];
        case "X": return ["#.#", "#.#", ".#.", "#.#", "#.#"];
        case "Y": return ["#.#", "#.#", ".#.", ".#.", ".#."];
        case "Z": return ["###", "..#", ".#.", "#..", "###"];
        case "0": return ["###", "#.#", "#.#", "#.#", "###"];
        case "1": return [".#.", ".#.", ".#.", ".#.", ".#."];
        case "2": return ["###", "..#", "###", "#..", "###"];
        case "3": return ["###", "..#", "###", "..#", "###"];
        case "4": return ["#.#", "#.#", "###", "..#", "..#"];
        case "5": return ["###", "#..", "###", "..#", "###"];
        case "6": return ["###", "#..", "###", "#.#", "###"];
        case "7": return ["###", "..#", "..#", "..#", "..#"];
        case "8": return ["###", "#.#", "###", "#.#", "###"];
        case "9": return ["###", "#.#", "###", "..#", "###"];
        case "&": return ["#..", "#.#", ".#.", "#.#", ".#."];
        case ".": return ["...", "...", "...", "...", ".#."];
        case "!": return [".#.", ".#.", ".#.", "...", ".#."];
        case "-": return ["...", "...", "###", "...", "..."];
        case "'": return [".#.", ".#.", "...", "...", "..."];
    }
    return ["...", "...", "...", "...", "..."];
}

// This runtime does not paint the far edge of draw_rectangle, so a 1px rect never appears.
function bb_fill(_x1, _y1, _x2, _y2, _col) {
    if (_x2 < _x1 || _y2 < _y1) return;
    draw_set_color(_col);
    draw_rectangle(_x1, _y1, _x2 + 1, _y2 + 1, false);
}

function bb_text(_str, _x, _y, _scale, _col) {
    draw_set_color(_col);
    var _cx = _x;
    var _n = string_length(_str);
    for (var _i = 1; _i <= _n; _i++) {
        var _rows = bb_glyph(string_char_at(_str, _i));
        for (var _ry = 0; _ry < 5; _ry++) {
            var _row = _rows[_ry];
            for (var _rx = 0; _rx < 3; _rx++) {
                if (string_char_at(_row, _rx + 1) == "#") {
                    var _x0 = _cx + _rx * _scale;
                    var _y0 = _y + _ry * _scale;
                    draw_rectangle(_x0, _y0, _x0 + _scale, _y0 + _scale, false);
                }
            }
        }
        _cx += 4 * _scale;
    }
}

function bb_text_w(_str, _scale) {
    return string_length(_str) * 4 * _scale;
}

function bb_ink(_ch) {
    switch (_ch) {
        case "x": return make_color_rgb(28, 18, 34);
        case "h": return make_color_rgb(118, 146, 72);
        case "H": return make_color_rgb(78, 104, 48);
        case "w": return make_color_rgb(244, 236, 214);
        case "k": return make_color_rgb(224, 176, 138);
        case "n": return make_color_rgb(208, 112, 96);
        case "c": return make_color_rgb(226, 176, 58);
        case "C": return make_color_rgb(176, 124, 32);
        case "p": return make_color_rgb(196, 132, 58);
        case "b": return make_color_rgb(54, 40, 40);
        case "g": return make_color_rgb(240, 176, 48);
        case "G": return make_color_rgb(196, 120, 28);
        case "y": return make_color_rgb(255, 244, 210);
        case "q": return make_color_rgb(70, 40, 20);
        case "t": return make_color_rgb(56, 184, 168);
        case "T": return make_color_rgb(24, 112, 104);
        case "j": return make_color_rgb(236, 220, 196);
        case "f": return make_color_rgb(255, 122, 40);
        case "r": return make_color_rgb(138, 144, 152);
        case "R": return make_color_rgb(200, 206, 214);
        case "m": return make_color_rgb(84, 90, 98);
    }
    return -1;
}

function bb_art_rows(_name) {
    switch (_name) {
        case "digger0": return ["................", "................", ".....hhhhhh.....", "....hhHHHHHHh...", "....hhhxxhhh....", "....hhkkkkhh....", "....hhknnkwh....", ".....hhhhhh.....", "....cccccccc....", "...ccCppcccc....", "...cCxxpcccc....", "....cccccccc....", "....ccc..ccc....", "....bbb..bbb....", "................", "................"];
        case "digger1": return ["................", "................", ".....hhhhhh.....", "....hhHHHHHHh...", "....hhhxxhhh....", "....hhkkkkhh....", "....hhknnkwh....", ".....hhhhhh.....", "....cccccccc....", "...ccCppcccc....", "...cCxxpcccc....", "....cccccccc....", "....cc....cc....", "....bb....bb....", "................", "................"];
        case "diggeru": return ["................", "......pppp......", ".....pxxpxx.....", ".....pppppp.....", ".....hhhhhh.....", "....hhHHHHHh....", "....hhhhhhhh....", "....cccccccc....", "...cccccccccc...", "...ccCcccCcc....", "....cccccccc....", "....ccc..ccc....", "....bbb..bbb....", "................", "................", "................"];
        case "diggerd": return ["................", "................", ".....hhhhhh.....", "....hhHHHHHHh...", "....hhwwwwwh....", "....hhkxkxhh....", "....hhknnkhh....", ".....hhhhhh.....", "....cccccccc....", "...cccccccccc...", "....cccccccc....", "....cccxxccc....", "....cccppccc....", ".....pppppp.....", "......xxxx......", "................"];
        case "gulper0": return ["................", "................", ".....gggggg.....", "....ggGGGGgg....", "....gGywwyGg....", "...ggGqwwqGgg...", "...gGGGywwGGg...", "...gGGGGyyGGg...", "...ggGGGGggg....", "....gggggggg....", "....ggyyyygg....", ".....gggggg.....", "....gg....gg....", "....GG....GG....", "................", "................"];
        case "gulper1": return ["................", "................", ".....gggggg.....", "....ggGGGGgg....", "....gGywwyGg....", "...ggGqwwqGgg...", "...gGGGywwGGg...", "...gGGGGyyGGg...", "...ggGGGGggg....", "....gggggggg....", "....ggyyyygg....", ".....gggggg.....", "...gg......gg...", "...GG......GG...", "................", "................"];
        case "belcher0": return ["................", "................", "....tttt........", "...tTTTTtttt....", "..tTjjjjjjTtff..", "..tTjwwwwjTtf...", "..ttjqwwwwTt....", "...tTjjjjjTt....", "...tTTTTTTt.....", "....ttttttt.....", "....tt....tt....", "...TT......TT...", "................", "................", "................", "................"];
        case "belcher1": return ["................", "................", "................", "...tTTTTtttt....", "..tTjjjjjjTtff..", "..tTjwwwwjTtf...", "..ttjqwwwwTt....", "...tTjjjjjTt....", "...tTTTTTTt.....", "....ttttttt.....", "...tt......tt...", "...TT......TT...", "................", "................", "................", "................"];
        case "rock": return ["................", "................", "....rrrrrrrr....", "...rRRRRRRRRr...", "..rRRrrrrrrRRr..", "..rRrRRRRRrRRr..", "..rRrRmmmmRrRr..", "..rRrRmmmmRrRr..", "..rRrRRRRRrRRr..", "..rRrrrrrrrrRr..", "...rRRRRRRRRr...", "....rrrrrrrr....", "....rr....rr....", "................", "................", "................"];
    }
    return ["................", "................", "................", "................", "................", "................", "................", "................", "................", "................", "................", "................", "................", "................", "................", "................"];
}

function bb_bake_one(_name) {
    var _rows = bb_art_rows(_name);
    var _surf = surface_create(16, 16);
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);
    for (var _y = 0; _y < 16; _y++) {
        var _row = _rows[_y];
        for (var _x = 0; _x < 16; _x++) {
            var _col = bb_ink(string_char_at(_row, _x + 1));
            if (_col >= 0) draw_point_colour(_x, _y, _col);
        }
    }
    surface_reset_target();
    return _surf;
}

function bb_bake() {
    var _g = global.bb;
    _g.spr = {};
    var _names = ["digger0", "digger1", "diggeru", "diggerd", "gulper0", "gulper1", "belcher0", "belcher1", "rock"];
    for (var _i = 0; _i < array_length(_names); _i++) {
        var _n = _names[_i];
        _g.spr[$ _n] = bb_bake_one(_n);
    }
    _g.baked = true;
}

function bb_band_rgb(_band, _dark) {
    if (_band == 0) return _dark ? make_color_rgb(150, 102, 46) : make_color_rgb(206, 158, 78);
    if (_band == 1) return _dark ? make_color_rgb(136, 62, 34) : make_color_rgb(196, 104, 52);
    if (_band == 2) return _dark ? make_color_rgb(108, 34, 40) : make_color_rgb(168, 62, 54);
    return _dark ? make_color_rgb(70, 22, 48) : make_color_rgb(122, 44, 74);
}

function bb_draw_field() {
    var _g = global.bb;
    if (!surface_exists(_g.field_surf)) _g.field_surf = surface_create(BB_VW, BB_VH);
    surface_set_target(_g.field_surf);
    draw_clear(make_color_rgb(10, 8, 16));
    bb_fill(0, BB_HUD, BB_VW - 1, BB_HUD + 15, make_color_rgb(28, 34, 58));
    bb_fill(0, BB_HUD + 14, BB_VW - 1, BB_HUD + 15, make_color_rgb(92, 74, 48));
    var _tunnel = make_color_rgb(12, 8, 18);
    var _strata = [[1, 4], [5, 8], [9, 12], [13, 15]];
    for (var _b = 0; _b < 4; _b++) {
        var _y0 = BB_HUD + _strata[_b][0] * BB_CELL;
        var _y1 = BB_HUD + (_strata[_b][1] + 1) * BB_CELL - 1;
        bb_fill(0, _y0, BB_VW - 1, _y1, bb_band_rgb(_b, false));
        bb_fill(0, _y1 - 2, BB_VW - 1, _y1, bb_band_rgb(_b, true));
    }
    for (var _r = 1; _r < BB_ROWS; _r++) {
        for (var _c = 0; _c < BB_COLS; _c++) {
            if (_g.solid[_r][_c] != 1) continue;
            var _x = _c * BB_CELL;
            var _y = BB_HUD + _r * BB_CELL;
            var _dark = bb_band_rgb(bb_band_of(_r), true);
            var _n = (_c * 13 + _r * 7) mod 5;
            bb_fill(_x + 3 + _n, _y + 4, _x + 5 + _n, _y + 5, _dark);
            bb_fill(_x + 9, _y + 8 + (_n mod 3), _x + 11, _y + 10 + (_n mod 3), _dark);
        }
    }
    for (var _r = 1; _r < BB_ROWS; _r++) {
        for (var _c = 0; _c < BB_COLS; _c++) {
            var _x = _c * BB_CELL;
            var _y = BB_HUD + _r * BB_CELL;
            var _solid = _g.solid[_r][_c];
            if (_solid == 0) {
                bb_fill(_x, _y, _x + 15, _y + 15, _tunnel);
            } else if (_solid == 2) {
                var _rows = _g.mask[_r][_c];
                var _base = bb_band_rgb(bb_band_of(_r), false);
                var _dark = bb_band_rgb(bb_band_of(_r), true);
                for (var _ly = 0; _ly < 16; _ly++) {
                    var _bits = _rows[_ly];
                    for (var _lx = 0; _lx < 16; _lx++) {
                        if ((_bits & (1 << _lx)) != 0) {
                            draw_point_colour(_x + _lx, _y + _ly, ((_lx + _ly) mod 5 == 0) ? _dark : _base);
                        } else {
                            draw_point_colour(_x + _lx, _y + _ly, _tunnel);
                        }
                    }
                }
            }
        }
    }
    surface_reset_target();
}

function bb_blit(_name, _px, _py, _mirror, _sc, _alpha) {
    var _spr = global.bb.spr[$ _name];
    if (_spr == undefined || !surface_exists(_spr)) return;
    var _ox = _px + 8 - 8 * _sc;
    var _oy = _py + BB_HUD + 8 - 8 * _sc;
    if (_mirror) {
        draw_surface_ext(_spr, _ox + 16 * _sc + 1, _oy + 1, -_sc, _sc, 0, c_black, _alpha);
        draw_surface_ext(_spr, _ox + 16 * _sc, _oy, -_sc, _sc, 0, c_white, _alpha);
    } else {
        draw_surface_ext(_spr, _ox + 1, _oy + 1, _sc, _sc, 0, c_black, _alpha);
        draw_surface_ext(_spr, _ox, _oy, _sc, _sc, 0, c_white, _alpha);
    }
}

function bb_draw_flower() {
    var _g = global.bb;
    if (_g.flower <= 0) return;
    var _x = _g.flower_c * BB_CELL + 8;
    var _y = BB_HUD + _g.flower_r * BB_CELL + 14;
    bb_fill(_x - 1, _y - 4 - _g.flower * 2, _x, _y, make_color_rgb(70, 140, 64));
    if (_g.flower >= 2) {
        var _s = 1 + _g.flower;
        bb_fill(_x - _s, _y - 8 - _g.flower * 2, _x + _s, _y - 5 - _g.flower, make_color_rgb(236, 92, 128));
    }
    if (_g.flower >= 3) {
        bb_fill(_x - 1, _y - 8 - _g.flower * 2, _x, _y - 7 - _g.flower, make_color_rgb(255, 220, 90));
    }
}

function bb_draw_hose() {
    var _pump = global.bb.pump;
    if (_pump.state == "idle" || _pump.len <= 0) return;
    var _p = global.bb.player;
    var _x = _p.px + 8;
    var _y = _p.py + BB_HUD + 8;
    for (var _n = 0; _n < _pump.len; _n += 2) {
        var _sx = _x + bb_dc(_p.face) * _n;
        var _sy = _y + bb_dr(_p.face) * _n;
        bb_fill(_sx - 1, _sy - 1, _sx + 1, _sy + 1, make_color_rgb(236, 220, 170));
    }
    var _tx = _x + bb_dc(_p.face) * _pump.len;
    var _ty = _y + bb_dr(_p.face) * _pump.len;
    bb_fill(_tx - 3, _ty - 3, _tx + 3, _ty + 3, make_color_rgb(255, 214, 64));
}

function bb_draw_fire(_e) {
    if (_e.fire_t <= 0) return;
    var _x = _e.px + 8;
    var _y = _e.py + BB_HUD + 8;
    var _hot = ((_e.fire_t div 2) mod 2 == 0);
    var _flame = _hot ? make_color_rgb(255, 210, 70) : make_color_rgb(255, 120, 36);
    for (var _n = 8; _n <= 48; _n += 4) {
        var _sx = _x + bb_dc(_e.face) * _n;
        var _sy = _y;
        var _c = _sx div BB_CELL;
        var _r = (_sy - BB_HUD) div BB_CELL;
        if (!bb_walkable(_c, _r)) break;
        bb_fill(_sx - 2, _sy - 2, _sx + 3, _sy + 2, _flame);
    }
}

function bb_draw_round_marks() {
    var _n = min(global.bb.round_num, 8);
    var _y = BB_HUD + 1;
    for (var _i = 0; _i < _n; _i++) {
        var _x = 8 + _i * 26;
        bb_fill(_x + 5, _y + 8, _x + 6, _y + 13, make_color_rgb(70, 150, 64));
        bb_fill(_x + 2, _y + 3, _x + 9, _y + 8, make_color_rgb(236, 96, 132));
        bb_fill(_x + 5, _y + 4, _x + 6, _y + 5, make_color_rgb(255, 220, 90));
    }
}

function bb_draw_title() {
    var _g = global.bb;
    var _s = 3;
    var _cream = make_color_rgb(244, 228, 176);
    var _gold = make_color_rgb(226, 176, 58);
    var _dim = make_color_rgb(168, 176, 196);
    bb_fill(0, 0, BB_VW * _s - 1, BB_VH * _s - 1, make_color_rgb(8, 8, 16));
    var _title = "BURROW & BELLOW";
    bb_text(_title, (BB_VW * _s - bb_text_w(_title, 2)) div 2, 28 * _s, 2, _cream);
    bb_fill(40 * _s, 40 * _s, 184 * _s, 41 * _s, _gold);
    var _head = "HIGH SCORES";
    bb_text(_head, (BB_VW * _s - bb_text_w(_head, 2)) div 2, 52 * _s, 2, _gold);
    for (var _i = 0; _i < array_length(_g.table); _i++) {
        var _row = _g.table[_i];
        var _line = string(_i + 1) + " " + _row.name + " " + bb_pad(_row.score, 6);
        bb_text(_line, (BB_VW * _s - bb_text_w(_line, 2)) div 2, (78 + _i * 16) * _s, 2, _cream);
    }
    if ((_g.tick div 30) mod 2 == 0) {
        var _press = "ENTER STARTS";
        bb_text(_press, (BB_VW * _s - bb_text_w(_press, 2)) div 2, 176 * _s, 2, _dim);
    }
    bb_text("ARROWS MOVE", (BB_VW * _s - bb_text_w("ARROWS MOVE", 1)) div 2, 200 * _s, 1, _dim);
    bb_text("SPACE PUMPS", (BB_VW * _s - bb_text_w("SPACE PUMPS", 1)) div 2, 212 * _s, 1, _dim);
}

function bb_draw_actors() {
    var _g = global.bb;
    bb_draw_round_marks();
    var _shake = 0;
    for (var _i = 0; _i < array_length(_g.rocks); _i++) {
        var _rk = _g.rocks[_i];
        _shake = 0;
        if (_rk.state == "shake") _shake = ((_rk.t div 2) mod 2) * 2 - 1;
        bb_blit("rock", _rk.px + _shake, _rk.py, false, 1, 1);
    }
    bb_draw_hose();
    for (var _e = 0; _e < array_length(_g.enemies); _e++) {
        var _en = _g.enemies[_e];
        if (!_en.alive && _en.mode != "dead") continue;
        if (!_en.alive) continue;
        var _frame = ((_en.walk div 8) mod 2 == 0) ? "0" : "1";
        var _name = (_en.kind == 0) ? ("gulper" + _frame) : ("belcher" + _frame);
        var _sc = 1 + _en.inflate * 0.22;
        var _alpha = (_en.mode == "ghost" || _en.mode == "flee") ? 0.42 : 1;
        bb_blit(_name, _en.px, _en.py, _en.face == 2, _sc, _alpha);
        bb_draw_fire(_en);
    }
    bb_draw_flower();
    var _p = _g.player;
    if (_p.alive || _g.mode == "dying") {
        var _blink = (_p.invuln > 0) && ((_g.tick div 4) mod 2 == 0);
        if (!(_blink && _g.mode == "play")) {
            var _sprn = "digger0";
            if (_p.face == 1) _sprn = "diggeru";
            else if (_p.face == 3) _sprn = "diggerd";
            else if ((_p.walk div 8) mod 2 == 1) _sprn = "digger1";
            var _sy = 1;
            var _py = _p.py;
            if (_g.mode == "dying") {
                _sy = max(0.2, 1 - _g.mode_t / 40);
                _py = _p.py + (1 - _sy) * 12;
            }
            var _spr = _g.spr[$ _sprn];
            if (_spr != undefined && surface_exists(_spr)) {
                var _ox = _p.px;
                var _oy = _py + BB_HUD + (16 - 16 * _sy);
                if (_p.face == 2) {
                    draw_surface_ext(_spr, _ox + 17, _oy + 1, -1, _sy, 0, c_black, 1);
                    draw_surface_ext(_spr, _ox + 16, _oy, -1, _sy, 0, c_white, 1);
                } else {
                    draw_surface_ext(_spr, _ox + 1, _oy + 1, 1, _sy, 0, c_black, 1);
                    draw_surface_ext(_spr, _ox, _oy, 1, _sy, 0, c_white, 1);
                }
            }
        }
    }
    for (var _u = 0; _u < array_length(_g.popups); _u++) {
        var _pop = _g.popups[_u];
        if (_pop.t > 0) bb_text(_pop.text, _pop.px, _pop.py + BB_HUD, 1, _pop.col);
    }
}

function bb_draw_hud() {
    var _g = global.bb;
    var _cream = make_color_rgb(244, 232, 196);
    var _gold = make_color_rgb(255, 214, 96);
    bb_text("HIGH", 4, 3, 1, _cream);
    bb_text(bb_pad(_g.high, 6), 24, 3, 1, _gold);
    bb_text("1UP", 92, 3, 1, _cream);
    bb_text(bb_pad(_g.score, 6), 112, 3, 1, _gold);
    bb_text("RND " + bb_pad(min(99, _g.round_num), 2), 4, 16, 1, _cream);
    var _lives = min(5, _g.lives);
    for (var _i = 0; _i < _lives; _i++) {
        if (_g.baked) bb_blit("diggeru", 148 + _i * 14, -18, false, 0.65, 1);
    }
}

function bb_draw_banner(_line1, _line2) {
    draw_set_alpha(0.82);
    bb_fill(12, 92, BB_VW - 13, 168, make_color_rgb(8, 6, 14));
    draw_set_alpha(1);
    var _cream = make_color_rgb(244, 232, 196);
    var _w = bb_text_w(_line1, 2);
    bb_text(_line1, (BB_VW - _w) div 2, 108, 2, make_color_rgb(255, 214, 96));
    if (_line2 != "") {
        var _w2 = bb_text_w(_line2, 1);
        bb_text(_line2, (BB_VW - _w2) div 2, 140, 1, _cream);
    }
}

function bb_draw_overlay() {
    var _g = global.bb;
    if (_g.mode == "title") {
        bb_draw_banner("BURROW & BELLOW", "PRESS START");
        draw_set_alpha(0.72);
        bb_fill(36, 180, BB_VW - 37, 224, make_color_rgb(8, 6, 14));
        draw_set_alpha(1);
        bb_text("ARROWS MOVE", 56, 186, 1, make_color_rgb(244, 232, 196));
        bb_text("SPACE PUMPS", 56, 198, 1, make_color_rgb(244, 232, 196));
        bb_text("F7 TOUCH", 72, 210, 1, make_color_rgb(180, 196, 214));
    } else if (_g.mode == "play" && _g.ready_t > 0) {
        var _w = bb_text_w("READY", 2);
        bb_text("READY", (BB_VW - _w) div 2, 120, 2, make_color_rgb(255, 236, 180));
    } else if (_g.mode == "clear") {
        bb_draw_banner("GALLERY CLEAR", bb_pad(_g.clear_bonus, 4));
    } else if (_g.mode == "over") {
        bb_draw_banner("GAME OVER", "PRESS START");
    } else if (_g.mode == "initials") {
        bb_draw_banner("NEW HIGH", _g.who);
        bb_text("UP DOWN LETTER", 36, 186, 1, make_color_rgb(220, 210, 180));
    } else if (_g.mode == "pause") {
        bb_draw_banner("PAUSE", "ESC");
    }
}

function bb_draw() {
    var _g = global.bb;
    if (!variable_global_exists("bb") || !_g.ready) return;
    if (_g.mode == "title") {
        bb_draw_title();
        return;
    }
    if (!_g.baked || !surface_exists(_g.spr[$ "rock"])) bb_bake();
    bb_draw_field();
    if (!surface_exists(_g.game_surf)) _g.game_surf = surface_create(BB_VW, BB_VH);
    surface_set_target(_g.game_surf);
    draw_clear(c_black);
    if (surface_exists(_g.field_surf)) draw_surface(_g.field_surf, 0, 0);
    bb_draw_actors();
    bb_draw_hud();
    bb_draw_overlay();
    surface_reset_target();
    var _scale = 3;
    draw_surface_ext(_g.game_surf, 0, 0, _scale, _scale, 0, c_white, 1);
}

function bb_ui_rects() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _b = 84;
    var _m = 24;
    var _cx = _m + _b;
    var _cy = _gh - _m - _b;
    return {
        left: [_cx - _b - 6, _cy - _b * 0.45, _cx - 6, _cy + _b * 0.45],
        right: [_cx + 6, _cy - _b * 0.45, _cx + _b + 6, _cy + _b * 0.45],
        up: [_cx - _b * 0.45, _cy - _b - 6, _cx + _b * 0.45, _cy - 6],
        down: [_cx - _b * 0.45, _cy + 6, _cx + _b * 0.45, _cy + _b + 6],
        pump: [_gw - _m - _b * 1.6, _gh - _m - _b * 1.35, _gw - _m, _gh - _m],
        pause: [_gw - 120, 8, _gw - 16, 52]
    };
}

function bb_fill_rect(_r, _col) {
    bb_fill(_r[0], _r[1], _r[2], _r[3], _col);
}

function bb_draw_gui() {
    var _g = global.bb;
    if (!variable_global_exists("bb") || !_g.ready || !_g.touch_ui) return;
    var _u = bb_ui_rects();
    draw_set_alpha(0.38);
    bb_fill_rect(_u.left, make_color_rgb(244, 236, 214));
    bb_fill_rect(_u.right, make_color_rgb(244, 236, 214));
    bb_fill_rect(_u.up, make_color_rgb(244, 236, 214));
    bb_fill_rect(_u.down, make_color_rgb(244, 236, 214));
    bb_fill_rect(_u.pump, make_color_rgb(255, 186, 64));
    bb_fill_rect(_u.pause, make_color_rgb(180, 190, 210));
    draw_set_alpha(1);
    bb_text("PUMP", _u.pump[0] + 18, _u.pump[1] + 36, 2, make_color_rgb(40, 24, 12));
    bb_text("II", _u.pause[0] + 28, _u.pause[1] + 14, 2, make_color_rgb(20, 16, 28));
}
