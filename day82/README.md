## How will you exchange the Contents of "X" and "Y" ? 

Use the MUX control signals "Load X and Y"  and "Select the Logic Op" to exchange the contents of the register A and B.  <br />

![circuit](day82_1.png)


Solution:                                                                      <br />
         Load A and B   |  Select Logic OP  | Register A | Register B          <br />
Initial                 |                   |     A      |     B               <br />
Step 1:      Load A     |  Select XOR       |   AxorB    |     B               <br />
Step 2:      Load B     |  Select XOR       |   AxorB    |   AxorBxorB=A       <br />
Step 3:      Load A     |  Select XOR       |AxorBxorA=B |     A               <br />
