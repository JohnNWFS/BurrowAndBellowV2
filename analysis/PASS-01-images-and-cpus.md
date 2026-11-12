# Pass 01: which file is which CPU

Question: the zip in `/mnt/tnas/GooglePhotos/digdug.zip` (copied to
`DigDug Mame/roms/`) is which program?

## Hardware-confirmed

From `digdug.cpp` `ROM_START(digdug)`:

| Files | Map | Size |
|---|---|---|
| `dd1a.1` `dd1a.2` `dd1a.3` `dd1a.4` | main Z80 `$0000`–`$3FFF` | 16K |
| `dd1a.5` `dd1a.6` | second Z80 `$0000`–`$1FFF` | 8K |
| `dd1.7` | sound Z80 `$0000`–`$0FFF` | 4K |

Each CPU has its own ROM at the same addresses. A routine address on the
main CPU is not the same bytes as that address on the second CPU.

Shared store, from `digdug_map`:

| Addresses | Role |
|---|---|
| `$8000`–`$83FF` | text-tile RAM |
| `$8400`–`$87FF` | work RAM |
| `$8800`–`$8BFF`, `$9000`–`$93FF`, `$9800`–`$9BFF` | sprite registers |
| `$A000`–`$A007` | video latches, including the background page |
| `$B800`–`$B83F` | nonvolatile data |
| `$B840` | nonvolatile control strobe |

Picture: 36×28 tiles of 8×8, visible 288×224. Text tiles are 1 bit, 8×8
(`dd1.9`, 2K, 256 tiles). Sprites are 16×16. Background pictures come from
`dd1.10b`, selected by the low two bits of the video latch.

## ROM-confirmed

`analysis/check_pass02.py` checks all 19 chip CRCs against the driver list.
The main image begins `F3 ED 56 C3 E6 00`: disable interrupts, interrupt
mode 1, jump to `$00E6`. `$00E6` ends in `JP $387E`.

`$0018`–`$0026` is a short pair of helpers (`RET NZ` / store `$9C`, and a
loop that subtracts `$64`). The driver comment about a round counter near
those addresses is hardware-adjacent commentary, not yet a traced round
routine. This pass does not claim what `$9C` means.

## Not claimed

Attract order, the demo, the flower row, and sprite poses are later passes.
