## How many Patterns are required to Detect a Missmatch ? 

Questiom: Block A drives 100 wires to block B. They are connected in order i.e index "n" of Block A connected to index "n" of BLock B. 

How will you check for a mismatch in connection ? What patterns are required ? 


![solution](day86_1.png)


Patterns in order 
          9786 5432 10
pattern1: 1010 1010 10
pattern2: 1100 1100 11 
pattern3: 1111 0000 11 
pattern4: 1111 1111 00 


So we need at least 4 patterns to detect any missmatch on 10 bits. 
