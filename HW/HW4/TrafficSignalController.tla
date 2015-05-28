---------------------- MODULE TrafficSignalController ----------------------
(* Design based on traffic_light8 *)
EXTENDS Naturals, TLC
CONSTANT Directions
VARIABLE lights, clock


TypeInvariant == /\ lights \in [Directions -> {"red", "green", "yellow"}]
                 /\ clock \in Nat

Init == /\ lights = [dir \in Directions|-> "red" ]
        /\ clock = 1
   
LightGreen(dir) == 
  /\ lights[dir] = "green"
  /\ lights'     = [lights EXCEPT ![dir] = "yellow"]
  
LightYellow(dir) ==
   /\ lights[dir] = "yellow"
   /\ lights'     = [lights EXCEPT ![dir] = "red"]

LightRed(dir)    == 
   /\ lights[dir] = "red"
   /\ lights'     = [lights EXCEPT ![dir] = "green"]
   
NextClock == clock' = (clock % 10) + 1
    
DirectionNext(dir) == \/ LightGreen(dir)
                      \/ LightYellow(dir)
                      \/ LightRed(dir)

NoAccident == \A i \in Directions :  ( \/ (lights[i] = "green")
                                       \/ (lights[i] = "yellow") )=>
              \A j \in Directions:     \/ i=j 
                                       \/ lights[j] = "red"

Next == /\ (\E dir \in Directions: DirectionNext(dir))
        /\ PrintT(lights)
        /\ PrintT(NoAccident)
        /\ NextClock
   
Accident(t) ==  (     clock > t
                  /\  NoAccident = TRUE )

Spec == Init /\ [][Next]_<<lights,clock>>
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Mon May 25 16:37:19 PDT 2015 by Me
\* Created Thu May 21 17:58:40 PDT 2015 by Me
