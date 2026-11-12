# V2 research log

This folder is the review trail. It is the same job the Spy Hunter
`analysis/` folder did: a person should be able to open one pass, see the
claim, and rerun the check.

## Evidence labels

- **Hardware-confirmed.** The open MAME driver in
  `romdasm/vendor/mame/src/mame/namco/digdug.cpp`. That file is emulator
  source. It describes the board. It is not the game program.
- **ROM-confirmed.** Bytes read from the chip images, or an instruction
  sequence at a named address, with the effect stated in our words.
- **Interpretation.** A name we gave a byte. It stays a guess until a check
  or a later pass agrees.

## What is not stored here

No chip images, no zip of the set, no linear disassembly, no dump of the
original pictures. Checks read the chips from `BB_ROM_DIR`, which defaults
to `/mnt/tnas-john/Documents/Programs/DigDug Mame/roms`.

## How a pass is written

1. State the question in one sentence.
2. Say which CPU and which address answered it.
3. Add a check that fails if those bytes move.
4. List what the pass does not claim.
5. Only then change the GameMaker game, and only for that claim.

## Run the checks

```bash
python3 analysis/check_pass02.py
```

## Passes

| Pass | Question | Status |
|---|---|---|
| [00](PASS-00-v1-was-a-sketch.md) | Why V1 is not the homage | note, no ROM check |
| [01](PASS-01-images-and-cpus.md) | Which chips are which CPU | ROM-confirmed |
| [02](PASS-02-score-table.md) | How many saved scores, and how they are stored | ROM-confirmed |
| [Open](OPEN-QUESTIONS.md) | Attract order, demo, surface flowers, sprites | not started |
