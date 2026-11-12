# LLM Project Lessons

## Project-Specific Rules

- Rule: V1 is frozen. Edit only this tree.
- Why: V1 is the playable sketch. V2 is the researched game.
- Files involved: this repo. V1 is `DigDug Mame/BurrowAndBellow`.
- How to verify: `git status` in this repo does not show V1 paths.

- Rule: A screen is not done because a smoke line printed.
- Why: V1's transcript popped one beast and dropped one stone. It never
  looked at a title, a score table, or a demo.
- Files involved: `analysis/PASS-00-v1-was-a-sketch.md`
- How to verify: the pass for that screen exists, and its check exits 0.

- Rule: Do not commit chip images, linear listings, or traced tiles.
- Why: The checks read `BB_ROM_DIR` on the machine that has the chips.
- Files involved: `.gitignore`, `analysis/check_pass02.py`
- How to verify: `git status` never lists `dd1a.1` or a zip.

## Known Build Commands

- IDE: not used on this box.
- CLI: coder box 2, `gm-build` / `gm-run` / `gm-shot`, after a `.yyp` exists.
- Deploy: Windows, Android, and iOS packages are not built here.

## Research status

- Pass 02 is the first ROM check. Attract, demo, flowers, and sprite poses
  are still open. See `analysis/OPEN-QUESTIONS.md`.
