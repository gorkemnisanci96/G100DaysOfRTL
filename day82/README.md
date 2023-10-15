## How will you exchange the Contents of "X" and "Y" ? 

Use the MUX control signals "Load X and Y"  and "Select the Logic Op" to exchange the contents of the register A and B. 

![circuit](day82_1.png)


Solution: 
         Load A and B   |  Select Logic OP  | Register A | Register B
Initial                 |                   |     A      |     B 
Step 1:      Load A     |  Select XOR       |   AxorB    |     B 
Step 2:      Load B     |  Select XOR       |   AxorB    |   AxorBxorB=A
Step 3:      Load A     |  Select XOR       |AxorBxorA=B |     A   
