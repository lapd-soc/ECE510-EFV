---------------------- MODULE TrafficSignalController ----------------------
(* Design based on traffic_light8 *)
(* Add greenTimer for each direction *)
EXTENDS Naturals, TLC
CONSTANT GreenTimerMAX, Directions, AccidentTimer
VARIABLE lights, greenTimer



Init == /\ lights = [dir \in Directions|-> "red" ]  
        /\ greenTimer = 0
        /\ AccidentTimer = 0                
            
         
TypeInvariant == /\ lights \in [Directions -> {"red", "green", "yellow"}] 
                 /\ greenTimer \in [Directions -> Nat]
                                    
LightGreen(dir) == 
  /\ lights[dir] = "green"
  /\ lights'     = IF greenTimer = 0 THEN [lights EXCEPT ![dir] = "yellow"] ELSE lights
  /\ greenTimer[dir]' = IF greenTimer > 0 THEN greenTimer-1 ELSE 0
  
LightYellow(dir) ==
   /\ lights[dir] = "yellow"
   /\ lights'     = [lights EXCEPT ![dir] = "red"]
   /\ UNCHANGED greenTimer   

LightRed(dir)    == 
   /\ lights[dir] = "red"
   /\ lights'     = [lights EXCEPT ![dir] = "green"]
   /\ greenTimer[dir]' = GreenTimerMAX
    
DirectionNext(dir) == LightGreen(dir) \/ LightYellow(dir) \/ LightRed(dir)

Next == /\ (\E dir \in Directions: DirectionNext(dir))
        /\ PrintT(lights)
    
NoAccident == \A i \in Directions :  ( \/ (lights[i] = "green") \/ (lights[i] = "yellow") )=> \A j \in Directions: 
                    \/ i=j 
                    \/ lights[j] = "red"
             
          
Spec == Init /\ [][Next]_<<lights,greenTimer>>
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Mon May 25 12:53:43 PDT 2015 by Me
\* Created Thu May 21 17:58:40 PDT 2015 by Me
