The FSM takes an input carew that indicates that a car is waiting on the east-west road. The FSM takes a second input, rst, that resets the FSM to a known state.  

There are six lights to control, green, yellow, and red, for both the north-south road and the east-west road. Consequently, the FSM outputs six control signals, one for each of the lights.  

An English-language description of the FSM is given below:  

(1) Reset to a state where the light is green in the NS direction and red in the EW direction.  

(2) When a car is detected in the EW direction (carew = 1), go through a sequence that makes the light go green in the EW direction and then return to green in the NS direction  

(3) A direction with a green light must first transition to a state where the light is yellow before going to a state where the light goes red.  

(4) A direction can have a green light only if the light in the other direction is red.  

Draw the state diagram for an FSM that controls the traffic lights.   
