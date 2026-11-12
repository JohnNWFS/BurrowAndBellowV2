# Open questions

These are the next passes. V2 gameplay code does not pretend to answer them.

1. Attract order. Main `$39CD` enables interrupts and then calls `$3AB8`,
   `$3A85`, `$3AF1`, `$3B4A`, `$3BC0`, `$3BDE`, `$3BEC`, `$3BFC`, `$3C47`,
   `$3CB3` in a loop until bit 7 of `$85A7` is set. Which of those calls is
   the title, which is the score table, and which is the demo is not known.
2. Demo. Need the input source. A demo that only shows round 1 with frozen
   actors is the V1 title, and it is not a demo.
3. Open ground and the flower row. The background page is the low two bits
   written through the `$A000` latch (`bg_select` in the driver). The flowers
   that count the round are not located. V1's single underground stem is the
   clear-bonus flower, which is a different object.
4. Sprite poses. Sprites are 16×16 in four 4K chips. Frame counts for walk,
   pump, inflate, ghost, and stone are not counted. No original tile will be
   copied into the game. The count decides how many original frames to draw.
5. Decimal score. Three stored bytes become six digit tiles in `$3645`.
   Walk that before showing a factory number on the V2 table.
