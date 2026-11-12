# Pass 02: the saved score table

Question: how many scores are kept, and where do they live?

## ROM-confirmed

The second CPU owns the nonvolatile copy. The cluster is `$1DDB`–`$1F56`.

- `$9B3D` is a step counter. Values `0`–`4` index five pointers at `$1DF6`:
  `$1E00`, `$1E3A`, `$1F34`, `$1E0B`, `$1E01`. A value of 5 or more returns.
- One step copies 37 bytes (`$25`) between nonvolatile `$B800` and work RAM
  `$89A0`. The control strobes are writes to `$B840`.
- Four bytes at `$B830` are compared with the four ROM bytes at `$1F03`
  (`A5 C3 EE 18`). `$89CF` remembers whether that check passed.
- The main CPU starts a step by writing `$9B3D`, then waits until the second
  CPU clears it. Seen at main `$330A`, `$39DB`.

The ranking walk is main `$3313`–`$3366`.

- `B = 5` entries.
- Each score is 3 bytes at `$89A0`, big-endian. The first byte is compared
  first. A lower new score borrows and becomes the insert point. A different
  first byte skips the rest of that entry.
- Insert shifts three regions down by the width of one entry:
  - scores: `$89A3` → `$89A0`
  - names: `$89B3` → `$89B0`
  - a third block: `$89C1` → `$89C0`
- `$89B0 - $89A0 = 16`. That is five 3-byte scores plus one pad byte.
- Five 3-byte names follow. The factory image at `$1EDE` matches this:
  five copies of `01 00 00`, a `00`, five 3-byte names, a `00`, then five
  `01` bytes. `15 + 1 + 15 + 1 + 5 = 37`.

Factory name tile codes, three each:

| Slot | Tiles |
|---|---|
| 1 | `28 35 28` |
| 2 | `1C 35 1C` |
| 3 | `26 35 26` |
| 4 | `1A 35 1A` |
| 5 | `27 35 27` |

`$35` is the middle tile of every factory name. In `dd1.9` it is a two-pixel
mark, not a letter. The other tiles are letter-shaped. This pass does not
spell them. V2 will use its own three-character names.

The drawer at `$3600` writes three tiles, skips, then a 6-tile number.
At `$3681` a leftover nibble `N` becomes text tile `$10+N`. A zero nibble
that reaches `$3685` becomes tile `$37`. Tile `$37` is blank in `dd1.9`.
Tiles `$11`–`$19` are the digit shapes. This pass does not yet prove that
every stored `01 00 00` displays as the same decimal, because the 3 stored
bytes and the 6 drawn tiles meet in `$3645`, which is not fully walked.

`$89C5` holds the insert slot. The walk gives up after slot 5
(`CP $06` at `$333A`).

## What V2 should implement from this pass

- Five saved rows, not one number.
- Each row is a 3-byte score, three name tiles, and a small flag.
- A new score inserts and shifts the lower rows down.
- The factory table is five equal scores until a player beats one.
- Names are three characters. The separator mark is our own, not tile `$35`.

## Not claimed

The decimal value of `01 00 00`. The order of the attract screens. Whether
the third shifted block at `$89C0` is a round number, a lives count, or a
second score. The flower row.
