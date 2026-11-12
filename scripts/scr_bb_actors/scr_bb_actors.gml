// Player, pump, beasts, and stones. One step order, owned by bb_step_play.

function bb_alive_count() {
    var _n = 0;
    var _list = global.bb.enemies;
    for (var _i = 0; _i < array_length(_list); _i++) {
        if (_list[_i].alive) _n += 1;
    }
    return _n;
}

function bb_add_score(_n, _px, _py) {
    if (_n <= 0) return;
    var _g = global.bb;
    _g.score += _n;
    bb_popup(string(_n), _px, _py, make_color_rgb(255, 236, 170));
    if (_g.score >= 20000 && !_g.extra_given) {
        _g.extra_given = true;
        _g.lives += 1;
        bb_popup("1UP", _px, _py - 12, make_color_rgb(180, 255, 190));
    }
    if (_g.score > _g.high) _g.high = _g.score;
}

function bb_popup(_text, _px, _py, _col) {
    var _g = global.bb;
    if (array_length(_g.popups) > 8) {
        var _keep = [];
        var _start = array_length(_g.popups) - 8;
        for (var _i = _start; _i < array_length(_g.popups); _i++) array_push(_keep, _g.popups[_i]);
        _g.popups = _keep;
    }
    array_push(_g.popups, { text: _text, px: _px, py: _py, t: 46, col: _col });
}

function bb_pop_points(_kind, _r) {
    var _band = bb_band_of(_r);
    if (_kind == 0) return 200 + _band * 200;
    return 400 + _band * 200;
}

function bb_rock_points(_n) {
    var _table = [0, 1000, 2500, 4000, 6000, 8000, 10000, 12000, 15000];
    if (_n <= 0) return 0;
    if (_n >= array_length(_table)) return 15000;
    return _table[_n];
}

function bb_try_move(_px, _py, _face) {
    var _nx = _px + bb_dc(_face);
    var _ny = _py + bb_dr(_face);
    if (_nx < 0 || _ny < 0) return -1;
    if (_nx > (BB_COLS - 1) * BB_CELL) return -1;
    if (_ny > (BB_ROWS - 1) * BB_CELL) return -1;
    if (bb_hits_rock(_nx, _ny)) return -1;
    return _nx + _ny * 10000;
}

function bb_step_player() {
    var _g = global.bb;
    var _p = _g.player;
    if (!_p.alive) return;
    if (_g.pump.state != "idle") return;
    var _held = bb_face_from_input();
    if (_held < 0) return;
    var _use = _held;
    var _reverse = (_p.face + 2) mod 4;
    if (_held != _p.face && _held != _reverse) {
        var _aligned = false;
        if (_held == 0 || _held == 2) _aligned = (_p.py mod BB_CELL == 0);
        else _aligned = (_p.px mod BB_CELL == 0);
        if (!_aligned) _use = _p.face;
    }
    var _packed = bb_try_move(_p.px, _p.py, _use);
    if (_packed < 0 && _use != _p.face) _packed = bb_try_move(_p.px, _p.py, _p.face);
    if (_packed < 0) return;
    _p.px = _packed mod 10000;
    _p.py = _packed div 10000;
    _p.face = _use;
    _p.walk += 1;
    bb_dig_rect(_p.px, _p.py, _p.px + 16, _p.py + 16);
}

function bb_hose_limit() {
    var _g = global.bb;
    var _p = _g.player;
    var _face = _p.face;
    var _limit = 4;
    var _x = _p.px + 8;
    var _y = _p.py + 8;
    for (var _n = 1; _n <= 76; _n++) {
        var _sx = _x + bb_dc(_face) * _n;
        var _sy = _y + bb_dr(_face) * _n;
        if (_sx < 0 || _sy < 0 || _sx >= BB_COLS * BB_CELL || _sy >= BB_ROWS * BB_CELL) break;
        var _c = _sx div BB_CELL;
        var _r = _sy div BB_CELL;
        if (!bb_walkable(_c, _r)) break;
        _limit = _n;
    }
    return _limit;
}

function bb_hose_enemy() {
    var _g = global.bb;
    var _p = _g.player;
    var _best = -1;
    var _best_d = 9999;
    for (var _i = 0; _i < array_length(_g.enemies); _i++) {
        var _e = _g.enemies[_i];
        if (!_e.alive || _e.mode == "dead") continue;
        var _dx = (_e.px + 8) - (_p.px + 8);
        var _dy = (_e.py + 8) - (_p.py + 8);
        var _along = 0;
        var _side = 0;
        if (_p.face == 0) { _along = _dx; _side = _dy; }
        if (_p.face == 2) { _along = -_dx; _side = _dy; }
        if (_p.face == 1) { _along = -_dy; _side = _dx; }
        if (_p.face == 3) { _along = _dy; _side = _dx; }
        if (_along < 8 || _along > _g.pump.len + 8) continue;
        if (abs(_side) > 10) continue;
        if (_along < _best_d) {
            _best_d = _along;
            _best = _i;
        }
    }
    return _best;
}

function bb_pump_connect(_index) {
    var _g = global.bb;
    var _e = _g.enemies[_index];
    _g.pump.state = "hold";
    _g.pump.target = _index;
    _g.pump.idle_t = 0;
    _e.mode = "inflate";
    _e.inflate += 1;
    if (_e.inflate >= 4) {
        _e.alive = false;
        _e.mode = "dead";
        var _r = (_e.py + 8) div BB_CELL;
        bb_add_score(bb_pop_points(_e.kind, _r), _e.px, _e.py);
        _g.flower = min(4, _g.flower + 1);
        _g.pump.state = "retract";
        _g.pump.target = -1;
    }
}

function bb_step_pump() {
    var _g = global.bb;
    var _pump = _g.pump;
    var _go = _g.pump_pressed || (_g.pump_down && _pump.hold > 8 && (_pump.hold mod 8) == 0);
    if (_pump.state == "idle") {
        if (_go) {
            _pump.state = "extend";
            _pump.len = 0;
            _pump.face = _g.player.face;
            _pump.target = -1;
            _pump.idle_t = 0;
        }
        return;
    }
    if (_pump.state == "extend") {
        _pump.len += 5;
        var _maxl = bb_hose_limit();
        if (_pump.len > _maxl) _pump.len = _maxl;
        var _hit = bb_hose_enemy();
        if (_hit >= 0) bb_pump_connect(_hit);
        else if (_pump.len >= _maxl) _pump.state = "retract";
    } else if (_pump.state == "hold") {
        var _e = _g.enemies[_pump.target];
        if (!_e.alive) {
            _pump.state = "retract";
            _pump.target = -1;
        } else if (_go) {
            bb_pump_connect(_pump.target);
        } else {
            _pump.idle_t += 1;
            if (_pump.idle_t > 16) {
                _pump.idle_t = 0;
                _e.inflate -= 1;
                if (_e.inflate < 0) {
                    _e.inflate = 0;
                    _e.mode = "walk";
                    _pump.state = "retract";
                    _pump.target = -1;
                }
            }
        }
    }
    if (_pump.state == "retract") {
        _pump.len -= 8;
        if (_pump.len <= 0) {
            _pump.len = 0;
            _pump.state = "idle";
            _pump.target = -1;
        }
    }
}

function bb_sees_dir(_e, _face) {
    var _pc = (global.bb.player.px + 8) div BB_CELL;
    var _pr = (global.bb.player.py + 8) div BB_CELL;
    var _c = (_e.px + 8) div BB_CELL;
    var _r = (_e.py + 8) div BB_CELL;
    if (_face == 0 || _face == 2) {
        if (_r != _pr) return false;
    } else if (_c != _pc) return false;
    var _steps = 0;
    var _cc = _c;
    var _rr = _r;
    while (_steps < 8) {
        _cc += bb_dc(_face);
        _rr += bb_dr(_face);
        _steps += 1;
        if (_cc == _pc && _rr == _pr) return true;
        if (!bb_walkable(_cc, _rr)) return false;
    }
    return false;
}

function bb_pick_face(_e, _ghost) {
    var _g = global.bb;
    var _pc = (_g.player.px + 8) div BB_CELL;
    var _pr = (_g.player.py + 8) div BB_CELL;
    var _c = _e.px div BB_CELL;
    var _r = _e.py div BB_CELL;
    var _best = _e.face;
    var _best_s = -99999;
    var _reverse = (_e.face + 2) mod 4;
    for (var _d = 0; _d < 4; _d++) {
        var _nc = _c + bb_dc(_d);
        var _nr = _r + bb_dr(_d);
        var _ok = false;
        if (_ghost) _ok = (_nc >= 0 && _nr >= 0 && _nc < BB_COLS && _nr < BB_ROWS && !bb_rock_blocks_cell(_nc, _nr));
        else _ok = bb_walkable(_nc, _nr);
        if (!_ok) continue;
        var _s = -(abs(_nc - _pc) + abs(_nr - _pr)) * 10;
        if (_d == _e.face) _s += 3;
        if (_d == _reverse) _s -= 5;
        if (!_ghost && bb_sees_dir(_e, _d)) _s += 60;
        if (_e.mode == "flee" && _d == 1) _s += 45;
        if (_s > _best_s) {
            _best_s = _s;
            _best = _d;
        }
    }
    return _best;
}

function bb_step_enemies() {
    var _g = global.bb;
    var _list = _g.enemies;
    var _only = bb_alive_count() == 1;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _e = _list[_i];
        if (!_e.alive) continue;
        if (_e.mode == "inflate" || _e.mode == "dead") continue;
        if (_e.fire_cool > 0) _e.fire_cool -= 1;
        if (_e.fire_t > 0) {
            _e.fire_t -= 1;
            if (_e.fire_t <= 0) _e.mode = "walk";
            continue;
        }
        if (_only && _e.mode == "walk") {
            _e.flee_t += 1;
            if (_e.flee_t > 70) _e.mode = "flee";
        }
        var _ghost = (_e.mode == "ghost" || _e.mode == "flee");
        if (!_ghost) {
            var _seen = bb_sees_dir(_e, 0) || bb_sees_dir(_e, 1) || bb_sees_dir(_e, 2) || bb_sees_dir(_e, 3);
            if (_seen) _e.lost_t = 0;
            else _e.lost_t += 1;
            if (_e.lost_t > _g.ghost_need) _e.mode = "ghost";
        }
        _ghost = (_e.mode == "ghost" || _e.mode == "flee");
        if (_e.mode == "walk" && _e.kind == 1 && _e.fire_cool <= 0) {
            if (bb_sees_dir(_e, 0) || bb_sees_dir(_e, 2)) {
                var _same = abs((_e.py + 8) - (_g.player.py + 8)) < 12;
                var _dist = abs((_e.px + 8) - (_g.player.px + 8));
                if (_same && _dist > 16 && _dist < 68) {
                    _e.mode = "fire";
                    _e.fire_t = 26;
                    _e.fire_cool = 90;
                    _e.face = (_g.player.px > _e.px) ? 0 : 2;
                    continue;
                }
            }
        }
        var _period = _ghost ? 2 : _g.enemy_period;
        if ((_g.tick mod _period) != 0) continue;
        if (_e.mode == "flee" && (_e.py div BB_CELL) <= 0 && (_e.px mod BB_CELL) == 0) {
            _e.py -= 1;
            if (_e.py < -14) {
                _e.alive = false;
                _e.escaped = true;
            }
            continue;
        }
        var _aligned = (_e.px mod BB_CELL == 0) && (_e.py mod BB_CELL == 0);
        if (_aligned || _ghost) {
            if (_aligned || _ghost) _e.face = bb_pick_face(_e, _ghost);
        }
        var _nx = _e.px + bb_dc(_e.face);
        var _ny = _e.py + bb_dr(_e.face);
        if (_ghost) {
            if (_nx < 0 || _ny < -16 || _nx > (BB_COLS - 1) * BB_CELL || _ny > (BB_ROWS - 1) * BB_CELL) continue;
            var _cc = (_nx + 8) div BB_CELL;
            var _rr = (_ny + 8) div BB_CELL;
            if (_rr >= 0 && bb_rock_blocks_cell(_cc, _rr)) continue;
            _e.px = _nx;
            _e.py = _ny;
            _e.walk += 1;
            if (_e.mode == "ghost" && bb_walkable(_e.px div BB_CELL, _e.py div BB_CELL)) {
                var _md = abs(_e.px - _g.player.px) + abs(_e.py - _g.player.py);
                if (_md < 72 && (_e.px mod BB_CELL) < 3 && (_e.py mod BB_CELL) < 3) {
                    _e.px = (_e.px div BB_CELL) * BB_CELL;
                    _e.py = (_e.py div BB_CELL) * BB_CELL;
                    _e.mode = "walk";
                    _e.lost_t = 0;
                }
            }
        } else if (bb_walkable(_nx div BB_CELL, _ny div BB_CELL) || ((_nx mod BB_CELL) != 0 && (_e.px div BB_CELL) == (_nx div BB_CELL) && bb_walkable(_e.px div BB_CELL, _e.py div BB_CELL))) {
            if (_nx >= 0 && _ny >= 0 && _nx <= (BB_COLS - 1) * BB_CELL && _ny <= (BB_ROWS - 1) * BB_CELL) {
                _e.px = _nx;
                _e.py = _ny;
                _e.walk += 1;
            }
        }
    }
}

function bb_dirt_supports(_c, _r) {
    if (_r >= BB_ROWS) return true;
    if (_r <= 0) return false;
    if (bb_rock_blocks_cell(_c, _r)) return true;
    return !bb_center_clear(_c, _r);
}

function bb_step_rocks() {
    var _g = global.bb;
    var _list = _g.rocks;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _rk = _list[_i];
        if (_rk.state == "rest" || _rk.state == "shake") {
            var _supported = bb_dirt_supports(_rk.c, _rk.r + 1);
            if (_supported) {
                if (_rk.state == "shake") _rk.state = "rest";
            } else if (_rk.state == "rest") {
                _rk.state = "shake";
                _rk.t = 0;
            } else {
                _rk.t += 1;
                if (_rk.t > 34) {
                    _rk.state = "fall";
                    _rk.dropped = 0;
                    bb_force_open(_rk.c, _rk.r);
                }
            }
        } else if (_rk.state == "fall") {
            var _next = _rk.py + 3;
            var _bottom = _next + BB_CELL;
            var _land = false;
            var _land_r = 0;
            if (_bottom >= BB_ROWS * BB_CELL) {
                _land = true;
                _land_r = BB_ROWS;
            } else {
                _land_r = _bottom div BB_CELL;
                if (bb_dirt_supports(_rk.c, _land_r)) _land = true;
            }
            if (_land) {
                _rk.py = (_land_r * BB_CELL) - BB_CELL;
                if (_rk.py < 0) _rk.py = 0;
                _rk.r = _rk.py div BB_CELL;
                _rk.px = _rk.c * BB_CELL;
                _rk.state = "settled";
                var _pts = bb_rock_points(_rk.combo);
                if (_pts > 0) bb_add_score(_pts, _rk.px, _rk.py);
            } else {
                _rk.py = _next;
                _rk.r = _rk.py div BB_CELL;
                _rk.dropped += 3;
                if (_rk.dropped >= 8) bb_rock_crush(_rk);
            }
        }
    }
}

function bb_rock_crush(_rk) {
    var _g = global.bb;
    var _list = _g.enemies;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _e = _list[_i];
        if (!_e.alive) continue;
        if (bb_overlap(_rk.px + 1, _rk.py + 1, 14, 14, _e.px + 2, _e.py + 2, 12, 12)) {
            _e.alive = false;
            _e.mode = "dead";
            _rk.combo += 1;
            _g.flower = min(4, _g.flower + 1);
            if (_g.pump.target == _i) {
                _g.pump.state = "retract";
                _g.pump.target = -1;
            }
        }
    }
    var _p = _g.player;
    if (_p.alive && _p.invuln <= 0 && _g.mode == "play") {
        if (bb_overlap(_rk.px + 1, _rk.py + 1, 14, 14, _p.px + 2, _p.py + 2, 12, 12)) _rk.hit_player = true;
    }
}

function bb_fire_hits_player(_e) {
    var _g = global.bb;
    var _p = _g.player;
    var _reach = 52;
    var _x = _e.px + 8;
    var _y = _e.py + 6;
    for (var _n = 10; _n <= _reach; _n += 4) {
        var _sx = _x + bb_dc(_e.face) * _n;
        var _sy = _y;
        var _c = _sx div BB_CELL;
        var _r = _sy div BB_CELL;
        if (!bb_walkable(_c, _r)) break;
        if (bb_overlap(_sx - 3, _sy - 3, 6, 8, _p.px + 2, _p.py + 2, 12, 12)) return true;
    }
    return false;
}

function bb_kill_player() {
    var _g = global.bb;
    if (_g.mode != "play") return;
    if (!_g.player.alive) return;
    if (_g.player.invuln > 0) return;
    _g.player.alive = false;
    _g.mode = "dying";
    _g.mode_t = 0;
    _g.lives -= 1;
    _g.pump.state = "idle";
    _g.pump.len = 0;
    _g.pump.target = -1;
}

function bb_step_collisions() {
    var _g = global.bb;
    var _p = _g.player;
    if (_p.invuln > 0) _p.invuln -= 1;
    if (!_p.alive || _g.mode != "play") return;
    if (_p.invuln > 0) return;
    var _list = _g.enemies;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _e = _list[_i];
        if (!_e.alive) continue;
        if (_g.pump.state == "hold" && _g.pump.target == _i) continue;
        var _grow = _e.inflate * 2;
        if (bb_overlap(_p.px + 3, _p.py + 3, 10, 10, _e.px + 3 - _grow, _e.py + 3 - _grow, 10 + _grow * 2, 10 + _grow * 2)) {
            bb_kill_player();
            return;
        }
        if (_e.fire_t > 0 && bb_fire_hits_player(_e)) {
            bb_kill_player();
            return;
        }
    }
    var _rocks = _g.rocks;
    for (var _r = 0; _r < array_length(_rocks); _r++) {
        if (_rocks[_r].hit_player) {
            bb_kill_player();
            return;
        }
    }
}

function bb_respawn_living() {
    var _list = global.bb.enemies;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _e = _list[_i];
        if (!_e.alive) continue;
        _e.px = _e.home_c * BB_CELL;
        _e.py = _e.home_r * BB_CELL;
        _e.mode = "walk";
        _e.inflate = 0;
        _e.fire_t = 0;
        _e.lost_t = 0;
        _e.flee_t = 0;
        _e.face = 2;
    }
}

function bb_step_popups() {
    var _list = global.bb.popups;
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _p = _list[_i];
        _p.t -= 1;
        if ((_i + global.bb.tick) mod 2 == 0) _p.py -= 1;
    }
}
