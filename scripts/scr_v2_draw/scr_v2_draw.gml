// Bitmap text for the 224x288 frame. This runtime skips the far edge of draw_rectangle.

function v2_glyph(_ch) {
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
    }
    return ["...", "...", "...", "...", "..."];
}

function v2_fill(_x1, _y1, _x2, _y2, _col) {
    if (_x2 < _x1 || _y2 < _y1) return;
    draw_set_color(_col);
    draw_rectangle(_x1, _y1, _x2 + 1, _y2 + 1, false);
}

function v2_text(_str, _x, _y, _scale, _col) {
    var _cx = _x;
    var _n = string_length(_str);
    for (var _i = 1; _i <= _n; _i++) {
        var _rows = v2_glyph(string_char_at(_str, _i));
        for (var _ry = 0; _ry < 5; _ry++) {
            var _row = _rows[_ry];
            for (var _rx = 0; _rx < 3; _rx++) {
                if (string_char_at(_row, _rx + 1) == "#") {
                    var _x0 = _cx + _rx * _scale;
                    var _y0 = _y + _ry * _scale;
                    v2_fill(_x0, _y0, _x0 + _scale - 1, _y0 + _scale - 1, _col);
                }
            }
        }
        _cx += 4 * _scale;
    }
}

function v2_text_w(_str, _scale) {
    return string_length(_str) * 4 * _scale;
}
