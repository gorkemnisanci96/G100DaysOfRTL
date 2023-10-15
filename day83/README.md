## Binary-Gray: Which Counter Consumes More Power ? 

If you have n-bit binary counter, made of n identical cascaded cells, which hold the corresponding bit value. Each of the binary cells dissipates a power of "P " units only when it toggles. 

You also have an n-bit Gray Counter made of n cascaded cells, which dissipates "3P" units of power cell when it toggles. 

You now let the counters run through an entire cycle(2^n different values) until they return to their starting value. Which counter burns more power?

Solution: 
- Lets first analyze the number of toggles for both binary and Gray Counter.
- Gray Counter will have 2^n toggles.
- For Binary Counter, lets analyze the 2-bit and 3-bit counters.
   
00 | NA   <br />
01 | 1    <br />
10 | 2    <br />
11 | 1    <br />
Total Toggles = 6  <br />

3-bit Counter  <br />
000 | NA       <br /> 
001 | 1        <br />
010 | 2        <br />
011 | 1        <br />
100 | 3        <br />
101 | 1        <br />
110 | 2        <br />
111 | 1        <br />
Total Toggles = 14  <br />


- Number of toggles for n-bit binary is 2^(n+1)-2. <br />
- Total Power dissipation for Binary Counter= 2^(n+1) -2 <br />

- Number of toggles for Gray Counter = 2^n <br />
-Total power dissipation for Gray Counter = 3*2^n <br />
So Gray counter consumes more power. <br />



















