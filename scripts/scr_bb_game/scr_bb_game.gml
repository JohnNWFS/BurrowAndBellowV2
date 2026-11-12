// Owns mode, input, and the order of the play step.

function bb_boot() {
    random_set_seed(20261111);
    var _g = {};
    _g.ready = false;
    _g.score = 0;
    _g.lives = 3;
    _g.high = 0;
    _g.saved_high = 0;
    _g.who = "---";
    _g.letter_i = 0;
    _g.extra_given = false;
    _g.mode = "title";
    _g.mode_t = 0;
    _g.tick = 0;
    _g.baked = false;
    _g.touch_ui = (os_type == os_android || os_type == os_ios);
    _g.autotest = bb_want_auto();
    _g.auto_phase = 0;
    _g.auto_t = 0;
    _g.auto_wait = 0;
    _g.auto_target = -1;
    _g.auto_pumps = 0;
    _g.auto_dug = false;
    _g.auto_rock = -1;
    _g.auto_done = false;
    _g.force_left = false;
    _g.force_right = false;
    _g.force_up = false;
    _g.force_down = false;
    _g.force_pump = false;
    _g.force_pump_edge = false;
    _g.pump_down = false;
    _g.pump_pressed = false;
    _g.face_hold = -1;
    _g.held_left = false;
    _g.held_right = false;
    _g.held_up = false;
    _g.held_down = false;
    _g.prev_left = false;
    _g.prev_right = false;
    _g.prev_up = false;
    _g.prev_down = false;
    _g.start_pressed = false;
    _g.pause_pressed = false;
    _g.field_surf = -1;
    _g.game_surf = -1;
    _g.spr = {};
    _g.clear_bonus = 0;
    _g.popups = [];
    global.bb = _g;
    bb_load_high();
    bb_load_round(0);
    _g.ready = true;
    show_debug_message("V2_BOOT autotest=" + string(_g.autotest));
}

function bb_default_table() {
    return [
        { name: "REX", score: 20000 },
        { name: "IVA", score: 15000 },
        { name: "NED", score: 10000 },
        { name: "SOL", score: 5000 },
        { name: "AMY", score: 1000 }
    ];
}

function bb_table_rank(_score) {
    var _t = global.bb.table;
    for (var _i = 0; _i < array_length(_t); _i++) {
        if (_score > _t[_i].score) return _i;
    }
    return -1;
}

function bb_insert_score(_name, _score) {
    var _rank = bb_table_rank(_score);
    if (_rank < 0) return;
    var _t = global.bb.table;
    for (var _i = array_length(_t) - 1; _i > _rank; _i--) {
        _t[_i] = { name: _t[_i - 1].name, score: _t[_i - 1].score };
    }
    _t[_rank] = { name: _name, score: _score };
    global.bb.high = _t[0].score;
    global.bb.saved_high = global.bb.high;
    bb_save_high();
}

function bb_want_auto() {
    if (environment_get_variable("BB_AUTOTEST") == "1") return true;
    if (file_exists("/home/coder/gm-out/BurrowAndBellowV2/autotest.trigger")) return true;
    if (file_exists(working_directory + "autotest.trigger")) return true;
    return false;
}

function bb_load_high() {
    var _table = bb_default_table();
    ini_open("burrow_bellow_v2.ini");
    for (var _i = 0; _i < 5; _i++) {
        var _name = ini_read_string("save", "n" + string(_i), _table[_i].name);
        var _score = ini_read_real("save", "s" + string(_i), _table[_i].score);
        if (string_length(_name) >= 3) _name = string_copy(_name, 1, 3);
        _table[_i] = { name: _name, score: _score };
    }
    ini_close();
    global.bb.table = _table;
    global.bb.high = _table[0].score;
    global.bb.saved_high = global.bb.high;
    global.bb.who = _table[0].name;
}

function bb_save_high() {
    var _t = global.bb.table;
    ini_open("burrow_bellow_v2.ini");
    for (var _i = 0; _i < array_length(_t); _i++) {
        ini_write_string("save", "n" + string(_i), _t[_i].name);
        ini_write_real("save", "s" + string(_i), _t[_i].score);
    }
    ini_close();
}

function bb_point_in(_px, _py, _r) {
    return _px >= _r[0] && _py >= _r[1] && _px <= _r[2] && _py <= _r[3];
}

function bb_read_input() {
    var _g = global.bb;
    var _left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _up = keyboard_check(vk_up) || keyboard_check(ord("W"));
    var _down = keyboard_check(vk_down) || keyboard_check(ord("S"));
    var _pump = keyboard_check(vk_space) || keyboard_check(ord("Z"));
    var _start = keyboard_check_pressed(vk_enter);
    var _pause = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
    if (keyboard_check_pressed(vk_f7)) _g.touch_ui = !_g.touch_ui;
    if (keyboard_check_pressed(vk_f8)) {
        show_debug_message("BB_STATE mode=" + _g.mode + " score=" + string(_g.score) + " lives=" + string(_g.lives));
    }
    if (_g.touch_ui) {
        var _u = bb_ui_rects();
        for (var _t = 0; _t < 4; _t++) {
            if (!device_mouse_check_button(_t, mb_left)) continue;
            var _mx = device_mouse_x_to_gui(_t);
            var _my = device_mouse_y_to_gui(_t);
            if (bb_point_in(_mx, _my, _u.left)) _left = true;
            if (bb_point_in(_mx, _my, _u.right)) _right = true;
            if (bb_point_in(_mx, _my, _u.up)) _up = true;
            if (bb_point_in(_mx, _my, _u.down)) _down = true;
            if (bb_point_in(_mx, _my, _u.pump)) _pump = true;
            if (device_mouse_check_button_pressed(_t, mb_left) && bb_point_in(_mx, _my, _u.pause)) _pause = true;
            if (device_mouse_check_button_pressed(_t, mb_left) && (_g.mode == "title" || _g.mode == "over")) _start = true;
        }
    }
    if (_g.mode == "title" || _g.mode == "over") {
        if (keyboard_check_pressed(vk_space)) _start = true;
    }
    if (_g.autotest) {
        if (_g.force_left) _left = true;
        if (_g.force_right) _right = true;
        if (_g.force_up) _up = true;
        if (_g.force_down) _down = true;
        if (_g.force_pump) _pump = true;
    }
    if (_right && !_g.prev_right) _g.face_hold = 0;
    else if (_up && !_g.prev_up) _g.face_hold = 1;
    else if (_left && !_g.prev_left) _g.face_hold = 2;
    else if (_down && !_g.prev_down) _g.face_hold = 3;
    _g.held_left = _left;
    _g.held_right = _right;
    _g.held_up = _up;
    _g.held_down = _down;
    _g.prev_left = _left;
    _g.prev_right = _right;
    _g.prev_up = _up;
    _g.prev_down = _down;
    var _was = _g.pump_down;
    _g.pump_down = _pump;
    _g.pump_pressed = _pump && !_was;
    if (_g.autotest && _g.force_pump_edge) _g.pump_pressed = true;
    if (_pump) _g.pump.hold += 1;
    else _g.pump.hold = 0;
    _g.start_pressed = _start;
    _g.pause_pressed = _pause;
}

function bb_face_from_input() {
    var _g = global.bb;
    if (_g.face_hold == 0 && _g.held_right) return 0;
    if (_g.face_hold == 1 && _g.held_up) return 1;
    if (_g.face_hold == 2 && _g.held_left) return 2;
    if (_g.face_hold == 3 && _g.held_down) return 3;
    if (_g.held_right) return 0;
    if (_g.held_up) return 1;
    if (_g.held_left) return 2;
    if (_g.held_down) return 3;
    return -1;
}

function bb_begin_game() {
    var _g = global.bb;
    _g.score = 0;
    _g.lives = 3;
    _g.extra_given = false;
    _g.mode = "play";
    _g.mode_t = 0;
    bb_load_round(0);
}

function bb_start_clear() {
    var _g = global.bb;
    _g.mode = "clear";
    _g.mode_t = 0;
    var _table = [0, 200, 500, 1000, 2500];
    var _stage = clamp(_g.flower, 0, 4);
    _g.clear_bonus = _table[_stage];
    var _px = _g.flower_c * BB_CELL;
    var _py = _g.flower_r * BB_CELL;
    bb_add_score(_g.clear_bonus, _px, _py);
}

function bb_finish_auto(_ok, _msg) {
    var _g = global.bb;
    if (_g.auto_done) return;
    _g.auto_done = true;
    var _tag = _ok ? "OK" : "FAIL";
    show_debug_message("BB_TRANSCRIPT " + _tag + " " + _msg + " score=" + string(_g.score) + " round=" + string(_g.round_num));
    game_end();
}

function bb_hall_gulper() {
    var _g = global.bb;
    var _row = _g.player.home_r;
    var _best = -1;
    var _best_d = 99999;
    for (var _i = 0; _i < array_length(_g.enemies); _i++) {
        var _e = _g.enemies[_i];
        if (!_e.alive || _e.kind != 0) continue;
        if ((_e.py div BB_CELL) != _row) continue;
        var _d = abs(_e.px - _g.player.px);
        if (_d < _best_d) {
            _best_d = _d;
            _best = _i;
        }
    }
    return _best;
}

function bb_auto_plan() {
    var _g = global.bb;
    if (_g.auto_done) return;
    _g.auto_t += 1;
    _g.force_left = false;
    _g.force_right = false;
    _g.force_up = false;
    _g.force_down = false;
    _g.force_pump = false;
    _g.force_pump_edge = false;
    if (_g.auto_t > 1400) {
        bb_finish_auto(false, "timeout");
        return;
    }
    if (_g.mode == "title") {
        if (_g.auto_t >= 4) bb_begin_game();
        return;
    }
    if (_g.mode == "dying" || _g.mode == "over") {
        bb_finish_auto(false, "player died");
        return;
    }
    if (_g.mode != "play") return;
    if (_g.auto_phase == 0) {
        _g.auto_target = bb_hall_gulper();
        if (_g.auto_target < 0) {
            bb_finish_auto(false, "no gulper");
            return;
        }
        var _dx = _g.enemies[_g.auto_target].px - _g.player.px;
        if (abs(_dx) > 34) {
            if (_dx > 0) _g.force_right = true;
            else _g.force_left = true;
        } else _g.auto_phase = 1;
    } else if (_g.auto_phase == 1) {
        _g.force_pump = true;
        if ((_g.auto_t mod 8) == 0) {
            _g.force_pump_edge = true;
            _g.auto_pumps += 1;
        }
        var _e = _g.enemies[_g.auto_target];
        if (!_e.alive && _g.score >= 200) _g.auto_phase = 2;
        if (_g.auto_pumps > 14) bb_finish_auto(false, "pump failed");
    } else if (_g.auto_phase == 2) {
        if (!_g.auto_dug) {
            var _found = -1;
            for (var _i = 0; _i < array_length(_g.rocks); _i++) {
                if (_g.rocks[_i].state == "rest") _found = _i;
            }
            if (_found < 0) {
                bb_finish_auto(false, "no rock");
                return;
            }
            _g.auto_rock = _found;
            bb_force_open(_g.rocks[_found].c, _g.rocks[_found].r + 1);
            _g.auto_dug = true;
            _g.auto_wait = 0;
        } else {
            _g.auto_wait += 1;
            var _st = _g.rocks[_g.auto_rock].state;
            if (_st == "settled") bb_finish_auto(true, "pop and rock");
            else if (_g.auto_wait > 200) bb_finish_auto(false, "rock " + _st);
        }
    }
}

function bb_step_title() {
    if (global.bb.start_pressed) bb_begin_game();
}

function bb_step_pause() {
    if (global.bb.pause_pressed || global.bb.start_pressed) global.bb.mode = "play";
}

function bb_step_dying() {
    var _g = global.bb;
    _g.mode_t += 1;
    if (_g.mode_t < 46) return;
    if (_g.lives > 0) {
        var _p = _g.player;
        _p.alive = true;
        _p.px = _p.home_c * BB_CELL;
        _p.py = _p.home_r * BB_CELL;
        _p.face = 0;
        _p.invuln = 100;
        bb_respawn_living();
        _g.mode = "play";
        _g.ready_t = 16;
        _g.mode_t = 0;
    } else if (bb_table_rank(_g.score) >= 0) {
        _g.mode = "initials";
        _g.who = "AAA";
        _g.letter_i = 0;
        _g.mode_t = 0;
    } else {
        bb_save_high();
        _g.mode = "over";
        _g.mode_t = 0;
    }
}

function bb_tweak_letter(_delta) {
    var _g = global.bb;
    var _i = _g.letter_i + 1;
    var _code = ord(string_char_at(_g.who, _i)) + _delta;
    if (_code > ord("Z")) _code = ord("A");
    if (_code < ord("A")) _code = ord("Z");
    var _s = "";
    for (var _n = 1; _n <= 3; _n++) {
        if (_n == _i) _s += chr(_code);
        else _s += string_char_at(_g.who, _n);
    }
    _g.who = _s;
}

function bb_step_initials() {
    var _g = global.bb;
    if (_g.held_up && (_g.tick mod 8) == 0) bb_tweak_letter(1);
    if (_g.held_down && (_g.tick mod 8) == 0) bb_tweak_letter(-1);
    if (keyboard_check_pressed(vk_left)) _g.letter_i = max(0, _g.letter_i - 1);
    if (keyboard_check_pressed(vk_right)) _g.letter_i = min(2, _g.letter_i + 1);
    if (_g.start_pressed || keyboard_check_pressed(vk_space)) {
        bb_insert_score(_g.who, _g.score);
        _g.mode = "over";
    }
}

function bb_step_clear() {
    var _g = global.bb;
    _g.mode_t += 1;
    if (_g.mode_t > 72) {
        bb_load_round(_g.round_i + 1);
        _g.mode = "play";
    }
}

function bb_step_over() {
    if (global.bb.start_pressed) bb_begin_game();
}

function bb_step_play() {
    var _g = global.bb;
    if (_g.pause_pressed) {
        _g.mode = "pause";
        return;
    }
    if (_g.ready_t > 0) {
        _g.ready_t -= 1;
        return;
    }
    bb_step_player();
    bb_step_pump();
    bb_step_rocks();
    bb_step_enemies();
    bb_step_collisions();
    bb_step_popups();
    if (_g.mode == "play" && bb_alive_count() == 0) bb_start_clear();
}

function bb_step() {
    var _g = global.bb;
    if (!_g.ready) return;
    _g.tick += 1;
    bb_read_input();
    if (_g.mode == "title") bb_step_title();
    else if (_g.mode == "pause") bb_step_pause();
    else if (_g.mode == "play") bb_step_play();
    else if (_g.mode == "dying") bb_step_dying();
    else if (_g.mode == "clear") bb_step_clear();
    else if (_g.mode == "initials") bb_step_initials();
    else if (_g.mode == "over") bb_step_over();
    if (_g.autotest) bb_auto_plan();
}
