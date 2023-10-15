## Binary-Gray: Which Counter Consumes More Power ? 

If you have n-bit binary counter, made of n identical cascaded cells, which hold the corresponding bit value. Each of the binary cells dissipates a power of "P " units only when it toggles. 

You also have an n-bit Gray Counter made of n cascaded cells, which dissipates "3P" units of power cell when it toggles. 

You now let the counters run through an entire cycle(2^n different values) until they return to their starting value. Which counter burns more power?

Solution: 
- Lets first analyze the number of toggles for both binary and Gray Counter.
- Gray Counter will have 2^n toggles.
- For Binary Counter, lets analyze the 2-bit and 3-bit counters.
   
00 | NA
01 | 1
10 | 2
11 | 1
Total Toggles = 6 

3-bit Counter 
000 | NA 
001 | 1
010 | 2
011 | 1
100 | 3
101 | 1
110 | 2
111 | 1
Total Toggles = 14


- Number of toggles for n-bit binary is 2^(n+1)-2.
- Total Power dissipation for Binary Counter= 2^(n+1) -2

- Number of toggles for Gray Counter = 2^n
-Total power dissipation for Gray Counter = 3*2^n
So Gray counter consumes more power.



















