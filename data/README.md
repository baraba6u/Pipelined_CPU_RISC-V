# Directory for test files

## Pipeline test instruction cautions
1. we have to insert NOPS in the front to prevent miscellaneous register value modification
  - 0000000_00000_00000_000_00000_0000000

2. we insert jal 0 0  in the back to prevent from instructions from rolling back to the front
  - 0000000_00000_00000_000_00000_1101111

3. when testing for function calls the inst sequence should be as follows
  - nop
  - jal to main
  - <function code>
  - <main code>
  - jal 0 0 



