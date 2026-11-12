# Pass 00: why V1 stopped too early

Date: 2026-11-12. No new ROM evidence in this note. It records the decision
that V2 exists.

## What V1 actually is

V1 lives at `DigDug Mame/BurrowAndBellow`. It compiles in coder box 2. A
scripted run prints `BB_TRANSCRIPT OK pop and rock score=200 round=1`. The
window shows four dirt bands, a hose, and a dug tunnel.

That transcript checks one pop and one falling stone. It does not check a
title, a score table, a demo, or the flowers on the open ground.

## What I used, and what I skipped

The chip set was not on the machine when V1 was built. The Spy Hunter homage
had its chip dumps in the project folder and a long `analysis/` trail
(`PASS-3.md` onward, plus a `check-passN.py` beside many of them). I read the
MAME driver's hardware comments and filled the rest in from a general memory
of the arcade game. I then treated the smoke transcript as done.

The driver I did have open already said the picture is 8×8 text tiles plus
16×16 sprites, and that a nonvolatile store sits at `$B800`. V1 still shipped
one ini high score and a flat blue bar where the open ground should be.
The sprites were 16×16 character grids typed into a script.

## Rule for V2

A playable loop is allowed only after the pass that describes that screen.
The first screens V1 skipped are the attract title, the saved-score table,
the self-playing demo, and the flower row on the open ground. Sprite frames
wait until a pass counts the original poses. The new pictures are drawn for
this game. The original tiles are not copied in.

V1 is left as it is.
