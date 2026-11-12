// Field, dirt masks, and round maps for Burrow & Bellow.
// Original layouts. The gallery shape is the familiar one: dirt, tunnels, buried stones.

#macro BB_COLS 14
#macro BB_ROWS 16
#macro BB_CELL 16
#macro BB_HUD 32
#macro BB_VW 224
#macro BB_VH 288

function bb_maps() {
    return [
        [
            "#######R######",
            "#P..G###.B...#",
            "#####.#.##.#.#",
            "#.....#.##.#.#",
            "#.###.#....#.#",
            "#.#...####.#.#",
            "#.#......#.#.#",
            "#.###.##.#...#",
            "#...#.#..#.#.#",
            "#.#.#.#..#.#.#",
            "#.#.#.##.#...#",
            "#.#...#..#.###",
            "#.#####..#...#",
            "#....G......S#",
            "##############"
        ],
        [
            "######RR######",
            "#P....##.....#",
            "#.###.#B#.##.#",
            "#.#...#.#.#..#",
            "#.#.#.#.#.#.##",
            "#.#...#.#.#..#",
            "#.#####.#.##.#",
            "#.......#....#",
            "####.##.#.##.#",
            "#..G...#.#...#",
            "#.####.#.#R#.#",
            "#.#....#.###.#",
            "#.#.####.#.#.#",
            "#.#......#.S.#",
            "##############"
        ],
        [
            "#######R######",
            "#..B...#.#...#",
            "#.####.#.#.#.#",
            "#.#..#.#.#.#.#",
            "#.#..#.#G..#.#",
            "#.#.#R.#####.#",
            "#.#..#.......#",
            "#.####.#####.#",
            "#....#.#.....#",
            "####.#.#.###.#",
            "#P...#.#.#...#",
            "#.##.#.#.#.#.#",
            "#.#G.#...#.#.#",
            "#.#....##..S.#",
            "##############"
        ],
        [
            "####R#####R###",
            "#...##....##.#",
            "#.##.#.####.##",
            "#.#G.#.#..#..#",
            "#.#..#.#..#.##",
            "#.#..B.#..#..#",
            "#.####.#..#..#",
            "#......#..#..#",
            "#.####.#..#..#",
            "#.#..#.#..#..#",
            "#.#.#R#..#...#",
            "#.#..#.#.....#",
            "#.#..#.####.##",
            "#P........S..#",
            "##############"
        ]
    ];
}

function bb_new_grid(_fill) {
    var _grid = array_create(BB_ROWS);
    for (var _r = 0; _r < BB_ROWS; _r++) {
        _grid[_r] = array_create(BB_COLS);
        for (var _c = 0; _c < BB_COLS; _c++) _grid[_r][_c] = _fill;
    }
    return _grid;
}

function bb_load_round(_index) {
    var _g = global.bb;
    var _maps = bb_maps();
    var _i = _index mod array_length(_maps);
    if (_i < 0) _i += array_length(_maps);
    _g.round_i = _index;
    _g.round_num = _index + 1;
    _g.solid = bb_new_grid(1);
    _g.mask = bb_new_grid(0);
    _g.enemies = [];
    _g.rocks = [];
    _g.popups = [];
    _g.flower_c = 7;
    _g.flower_r = 8;
    _g.flower = 0;
    _g.pump = { state: "idle", len: 0, face: 0, target: -1, hold: 0, idle_t: 0 };
    _g.ready_t = 28;
    _g.clear_awarded = false;
    _g.enemy_period = max(1, 2 - (_g.round_num div 4));
    _g.ghost_need = max(80, 420 - _g.round_num * 22);
    var _rows = _maps[_i];
    for (var _mr = 0; _mr < array_length(_rows); _mr++) {
        var _line = _rows[_mr];
        var _r = _mr + 1;
        for (var _c = 0; _c < BB_COLS; _c++) {
            var _ch = string_char_at(_line, _c + 1);
            if (_ch == "#" || _ch == "R") {
                _g.solid[_r][_c] = 1;
            } else {
                _g.solid[_r][_c] = 0;
            }
            if (_ch == "P") bb_place_player(_c, _r);
            if (_ch == "G") bb_place_enemy(_c, _r, 0);
            if (_ch == "B") bb_place_enemy(_c, _r, 1);
            if (_ch == "R") bb_place_rock(_c, _r);
            if (_ch == "S") {
                _g.flower_c = _c;
                _g.flower_r = _r;
            }
        }
    }
    for (var _c2 = 0; _c2 < BB_COLS; _c2++) _g.solid[0][_c2] = 0;
    _g.field_dirty = true;
}

function bb_place_player(_c, _r) {
    var _g = global.bb;
    _g.player = {
        px: _c * BB_CELL,
        py: _r * BB_CELL,
        face: 0,
        walk: 0,
        home_c: _c,
        home_r: _r,
        alive: true,
        invuln: 0
    };
}

function bb_place_enemy(_c, _r, _kind) {
    array_push(global.bb.enemies, {
        px: _c * BB_CELL,
        py: _r * BB_CELL,
        face: 2,
        kind: _kind,
        alive: true,
        escaped: false,
        mode: "walk",
        inflate: 0,
        walk: 0,
        home_c: _c,
        home_r: _r,
        lost_t: 0,
        fire_t: 0,
        fire_cool: 40,
        flee_t: 0
    });
}

function bb_place_rock(_c, _r) {
    array_push(global.bb.rocks, {
        c: _c,
        r: _r,
        px: _c * BB_CELL,
        py: _r * BB_CELL,
        state: "rest",
        t: 0,
        dropped: 0,
        combo: 0,
        hit_player: false
    });
}

function bb_clear_pixel(_c, _r, _lx, _ly) {
    if (_c < 0 || _r <= 0 || _c >= BB_COLS || _r >= BB_ROWS) return;
    if (_lx < 0 || _ly < 0 || _lx > 15 || _ly > 15) return;
    if (bb_rock_blocks_cell(_c, _r)) return;
    var _g = global.bb;
    if (_g.solid[_r][_c] == 0) return;
    if (_g.solid[_r][_c] == 1) {
        var _rows = array_create(16);
        for (var _i = 0; _i < 16; _i++) _rows[_i] = 65535;
        _g.mask[_r][_c] = _rows;
        _g.solid[_r][_c] = 2;
    }
    var _mask = _g.mask[_r][_c];
    var _bit = 1 << _lx;
    var _row = _mask[_ly];
    if ((_row & _bit) != 0) _mask[_ly] = _row - _bit;
    var _any = false;
    for (var _y = 0; _y < 16; _y++) {
        if (_mask[_y] != 0) _any = true;
    }
    if (!_any) {
        _g.solid[_r][_c] = 0;
        _g.mask[_r][_c] = 0;
    }
    _g.field_dirty = true;
}

function bb_dig_rect(_x0, _y0, _x1, _y1) {
    for (var _y = _y0; _y < _y1; _y++) {
        if (_y < 0 || _y >= BB_ROWS * BB_CELL) continue;
        var _r = _y div BB_CELL;
        for (var _x = _x0; _x < _x1; _x++) {
            if (_x < 0 || _x >= BB_COLS * BB_CELL) continue;
            bb_clear_pixel(_x div BB_CELL, _r, _x mod BB_CELL, _y mod BB_CELL);
        }
    }
}

function bb_center_clear(_c, _r) {
    if (_r < 0 || _c < 0 || _r >= BB_ROWS || _c >= BB_COLS) return false;
    var _s = global.bb.solid[_r][_c];
    if (_s == 0) return true;
    if (_s == 1) return false;
    var _rows = global.bb.mask[_r][_c];
    for (var _ly = 2; _ly <= 13; _ly++) {
        if ((_rows[_ly] & 16380) != 0) return false;
    }
    return true;
}

function bb_rock_blocks_cell(_c, _r) {
    var _rocks = global.bb.rocks;
    for (var _i = 0; _i < array_length(_rocks); _i++) {
        var _rk = _rocks[_i];
        if (_rk.c == _c && _rk.r == _r && _rk.state != "fall") return true;
    }
    return false;
}

function bb_walkable(_c, _r) {
    if (_c < 0 || _r < 0 || _c >= BB_COLS || _r >= BB_ROWS) return false;
    if (bb_rock_blocks_cell(_c, _r)) return false;
    if (_r == 0) return true;
    return bb_center_clear(_c, _r);
}

function bb_force_open(_c, _r) {
    if (_c < 0 || _r <= 0 || _c >= BB_COLS || _r >= BB_ROWS) return;
    if (bb_rock_blocks_cell(_c, _r)) return;
    global.bb.solid[_r][_c] = 0;
    global.bb.mask[_r][_c] = 0;
    global.bb.field_dirty = true;
}

function bb_dc(_face) {
    if (_face == 0) return 1;
    if (_face == 2) return -1;
    return 0;
}

function bb_dr(_face) {
    if (_face == 1) return -1;
    if (_face == 3) return 1;
    return 0;
}

function bb_overlap(_ax, _ay, _aw, _ah, _bx, _by, _bw, _bh) {
    return _ax < _bx + _bw && _ax + _aw > _bx && _ay < _by + _bh && _ay + _ah > _by;
}

function bb_hits_rock(_px, _py) {
    var _rocks = global.bb.rocks;
    for (var _i = 0; _i < array_length(_rocks); _i++) {
        var _rk = _rocks[_i];
        if (bb_overlap(_px + 2, _py + 2, 12, 12, _rk.px + 1, _rk.py + 1, 14, 14)) return true;
    }
    return false;
}

function bb_band_of(_r) {
    if (_r <= 4) return 0;
    if (_r <= 8) return 1;
    if (_r <= 12) return 2;
    return 3;
}

function bb_pad(_n, _w) {
    var _s = string(max(0, floor(_n)));
    while (string_length(_s) < _w) _s = "0" + _s;
    return _s;
}
