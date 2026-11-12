# Burrow & Bellow V2 — handoff for the next session

Written 2026-11-12, after the project was playable and the research log
had finished pass 02. This session stopped here on purpose so the next one
starts from the files instead of from a long chat.

## Where the project is

The GameMaker project and this note are the same tree in two places:

- Work copy, where Igor must compile:
  `/home/johnnwfs/Runners/CoderBoxes/boxes/box2/home/work/BurrowAndBellowV2/`
- The copy Windows opens. `Y:` is `//TNAS.local/JohnNWFS`, so
  `Y:\Documents\Programs\DigDug Mame\BurrowAndBellowV2` is
  `/mnt/tnas-john/Documents/Programs/DigDug Mame/BurrowAndBellowV2/`

GitHub: https://github.com/JohnNWFS/BurrowAndBellowV2
Branch `main`. Last pushed commit when this note was written: `3ae6fa1`
("Start a round from the title with Enter.").

V1 is frozen. Do not edit
`/mnt/tnas-john/Documents/Programs/DigDug Mame/BurrowAndBellow`
or the box copy under `work/BurrowAndBellow`. V1 is the first playable
sketch. The owner kept it.

After any change, copy the work tree onto the `Y:` folder with
`rsync -a --delete --exclude .git`. Close GameMaker on Windows first.
If it is open, it can save the old `.yyp` back over the copy. That already
happened once: the share still listed the title-only scripts while the
playable scripts were sitting beside them, and the IDE then errored.

## What is true now

The owner has played V2 and called it better, and called this a good
two-pass state. That means:

- Pass 00 explains why V1 is not the homage. No ROM check.
- Pass 01 names the chips and the three Z80s. ROM-confirmed.
- Pass 02 is the score table: five entries, three stored bytes, three
  character tiles, a 37-byte record. `python3 analysis/check_pass02.py`
  exits 0. The factory number those three bytes display is still open
  (`$3645`). The five names on the title (REX, IVA, NED, SOL, AMY) and
  their scores are ours, not a factory table.
- The game compiles in coder box 2 and runs. Enter starts round 1 from the
  title. Arrows or WASD move and dig. Space pumps. Escape pauses. On the
  title, Space also starts. The open strip above the dirt draws one flower
  per round, up to eight. Those flowers are our marks. They are not the
  located surface row.

Still open, in `analysis/OPEN-QUESTIONS.md`:

1. Which attract call is the title, which is the score table, which is the demo.
2. Where the demo reads its input. A frozen round 1 is not a demo.
3. The real surface flower row. The underground stem is the clear bonus.
4. Sprite pose counts. Draw new frames. Do not copy original tiles.
5. How the three stored score bytes become six digits.

Spy Hunter's log runs through `PASS-80`. That number is that project's last
file, not a quota. Do not freeze this game until pass 80 exists. Do not stop
because pass 02 is checked. Keep the same habit: one question, one check,
then the GameMaker change for that claim, then a screenshot, then the next
question. Continue until the owner has a version they want to review.

## Rules that already cost time

- Coder box 2 only. Owner string is "Grok - Burrow and Bellow". Do not touch
  box 1, Starfall and Steel, or SpyHunterRebuild.
- Compile inside the box, on this disk:
  `coderbox exec 2 gm-build /home/coder/work/BurrowAndBellowV2/BurrowAndBellowV2.yyp Compile`
  Launch with `gm-run`. Screenshot with `gm-shot`. The window title is
  "Burrow & Bellow V2".
- Do not `pkill -f Igor` inside `coderbox exec`. The shell line contains
  "Igor", so the shell dies. Kill the game pid.
- This runtime's `draw_rectangle` does not paint the far edge. Use the
  existing `bb_fill` helper. A 1px rectangle never appears.
- After a real `game_end`, Igor can abort with `pa_mutex_lock` and exit 134.
  That is Pulse tearing down. The transcript line is the result.
- `local_settings.json` failing to load is the known harmless warning.
- Do not put chip images, zips, linear disassembly, or traced tiles in git.
  Checks read `BB_ROM_DIR`, default
  `/mnt/tnas-john/Documents/Programs/DigDug Mame/roms`.
- Do not paste those listings or tile bytes into the chat. A model turn was
  refused with `permission-denied` immediately after a hex dump of the
  program image. Write the conclusion in our own words. Let the check script
  read the bytes.
- Original title, names, and pixels. Do not ship the arcade name, character
  names, music, or code.
- Reusable GameMaker lessons go in
  `AdventureAgentStorm/references/gm-vibecoding-guide`. Paths and this
  game's notes stay in this repo. The method file already added there is
  `ARCADE_HOMAGE_RESEARCH_LOG.md`.
- Option images were copied into `options/` so the IDE can resolve the paths
  the `.yy` files name. They are on the work copy and on `Y:`. They were
  not committed when this note was written. `BurrowAndBellowV2.resource_order`
  is also untracked.

## Prompt to paste into the next session

```text
Continue Burrow & Bellow V2. Read these files before you change the game:

/home/johnnwfs/Runners/CoderBoxes/boxes/box2/home/work/BurrowAndBellowV2/docs/NEXT-SESSION.md
/home/johnnwfs/Runners/CoderBoxes/boxes/box2/home/work/BurrowAndBellowV2/analysis/README.md
/home/johnnwfs/Runners/CoderBoxes/boxes/box2/home/work/BurrowAndBellowV2/analysis/OPEN-QUESTIONS.md

The project is playable and the research log is in a good two-pass state.
Pass 02 is checked. Do not redo it. Do not edit V1 at
DigDug Mame/BurrowAndBellow. Do not touch coder box 1, Starfall and Steel,
or SpyHunterRebuild.

Windows opens Y:\Documents\Programs\DigDug Mame\BurrowAndBellowV2, which is
/mnt/tnas-john/Documents/Programs/DigDug Mame/BurrowAndBellowV2. Compile only
from the coder box 2 work copy. After a change, rsync that tree onto the Y:
path with rsync -a --delete --exclude .git. Tell me to close GameMaker
before you overwrite files it has open.

Next work is the open list, in order: attract order, demo input, the surface
flower row, sprite pose counts, then the decimal form of the stored score.
One question, one check script that reads the chips from BB_ROM_DIR, then
the GameMaker change for that claim only, then a screenshot from coder box 2.
Keep going. Spy Hunter reached pass 80. That count is not a quota and not a
reason to stop. Do not paste program listings or tile bytes into the chat.
Do not commit chip images, zips, linear disassembly, or traced tiles.

Enter starts a round. Arrows or WASD dig. Space pumps. Escape pauses.
The five title names and the flowers in the top strip are ours. Replace a
stand-in only after the pass for that screen checks out.
```
