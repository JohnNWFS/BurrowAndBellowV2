#!/usr/bin/env python3
"""Check the pass 02 byte claims against the local chip images.

The chips are not in this repo. BB_ROM_DIR defaults to the TNAS copy.
"""
import os
import sys
import zlib
from pathlib import Path

ROM = Path(os.environ.get(
    "BB_ROM_DIR",
    "/mnt/tnas-john/Documents/Programs/DigDug Mame/roms",
))

EXPECT = {
    "dd1a.1": "a80ec984", "dd1a.2": "559f00bd", "dd1a.3": "8cbc6fe1",
    "dd1a.4": "d066f830", "dd1a.5": "6687933b", "dd1a.6": "843d857f",
    "dd1.7": "a41bce72", "dd1.9": "f14a6fe1", "dd1.15": "e22957c8",
    "dd1.14": "2829ec99", "dd1.13": "458499e9", "dd1.12": "c58252a0",
    "dd1.11": "7b383983", "dd1.10b": "2cf399c2", "136007.113": "4cb9da99",
    "136007.111": "00c7c419", "136007.112": "e9b3e08e",
    "136007.110": "7a2815b4", "136007.109": "77245b66",
}


def crc(name):
    data = (ROM / name).read_bytes()
    return data, f"{zlib.crc32(data) & 0xFFFFFFFF:08x}"


def main():
    missing = [n for n in EXPECT if not (ROM / n).is_file()]
    if missing:
        print("FAIL missing", missing)
        return 1
    bad = []
    blobs = {}
    for name, want in EXPECT.items():
        data, got = crc(name)
        blobs[name] = data
        if got != want:
            bad.append((name, got, want))
    if bad:
        print("FAIL crc", bad)
        return 1

    maincpu = blobs["dd1a.1"] + blobs["dd1a.2"] + blobs["dd1a.3"] + blobs["dd1a.4"]
    sub = blobs["dd1a.5"] + blobs["dd1a.6"]
    gfx = blobs["dd1.9"]

    def need(buf, addr, raw, label):
        got = buf[addr:addr + len(raw)]
        if got != raw:
            print(f"FAIL {label} at {addr:04X}: {got.hex()} != {raw.hex()}")
            return False
        return True

    ok = True
    ok &= need(maincpu, 0x0000, bytes.fromhex("f3ed56c3e600"), "reset")
    ok &= need(maincpu, 0x3313, bytes.fromhex("21a0890605"), "five scores at 89A0")
    ok &= need(maincpu, 0x331B, bytes.fromhex("0e03"), "three byte compare")
    ok &= need(maincpu, 0x3355, bytes.fromhex("21a38911a089"), "score shift by 3")
    ok &= need(maincpu, 0x335F, bytes.fromhex("21b38911b089"), "name shift by 3")
    ok &= need(maincpu, 0x3681, bytes.fromhex("e60f"), "digit nibble")
    ok &= need(sub, 0x1DF6, bytes.fromhex("001e3a1e341f0b1e011e"), "five step pointers")
    ok &= need(sub, 0x1E19, bytes.fromhex("11de1e2100b80625"), "copy 37 bytes")
    factory = bytes.fromhex(
        "010000010000010000010000010000"
        "002835281c351c2635261a351a27352700"
        "0101010101"
    )
    ok &= need(sub, 0x1EDE, factory, "factory 37 byte image")
    if len(factory) != 0x25:
        print("FAIL factory length", len(factory))
        ok = False

    def glyph_blank(code):
        return all(b == 0 for b in gfx[code * 8:code * 8 + 8])

    if glyph_blank(0x37) is not True:
        print("FAIL tile 37 should be blank")
        ok = False
    if glyph_blank(0x35):
        print("FAIL tile 35 should be the name mark, not blank")
        ok = False
    if ok:
        print("PASS-02 ok five scores, three byte names, 37 byte record")
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main())
