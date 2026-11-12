// Title and the five-row score table. Play, the demo, and the flower row are not in this build.

#macro V2_W 224
#macro V2_H 288
#macro V2_SCALE 3

function v2_boot() {
    global.v2 = {
        t: 0,
        rows: [
            { name: "REX", score: 20000 },
            { name: "IVA", score: 15000 },
            { name: "NED", score: 10000 },
            { name: "SOL", score: 5000 },
            { name: "AMY", score: 1000 }
        ]
    };
    show_debug_message("V2_BOOT title");
}

function v2_score_text(_n) {
    var _s = string(_n);
    while (string_length(_s) < 6) _s = "0" + _s;
    return _s;
}

function v2_step() {
    global.v2.t += 1;
}

function v2_draw() {
    var _g = global.v2;
    var _s = V2_SCALE;
    v2_fill(0, 0, V2_W * _s - 1, V2_H * _s - 1, make_color_rgb(8, 8, 16));

    var _cream = make_color_rgb(244, 228, 176);
    var _gold = make_color_rgb(226, 176, 58);
    var _dim = make_color_rgb(168, 176, 196);

    var _title = "BURROW & BELLOW";
    v2_text(_title, (V2_W * _s - v2_text_w(_title, 2)) div 2, 28 * _s, 2, _cream);
    v2_fill(40 * _s, 40 * _s, 184 * _s, 41 * _s, _gold);

    var _head = "HIGH SCORES";
    v2_text(_head, (V2_W * _s - v2_text_w(_head, 2)) div 2, 52 * _s, 2, _gold);

    for (var _i = 0; _i < 5; _i++) {
        var _row = _g.rows[_i];
        var _line = string(_i + 1) + " " + _row.name + " " + v2_score_text(_row.score);
        var _y = (78 + _i * 16) * _s;
        v2_text(_line, (V2_W * _s - v2_text_w(_line, 2)) div 2, _y, 2, _cream);
    }

    if ((_g.t div 30) mod 2 == 0) {
        var _press = "PRESS START";
        v2_text(_press, (V2_W * _s - v2_text_w(_press, 2)) div 2, 180 * _s, 2, _dim);
    }
}
