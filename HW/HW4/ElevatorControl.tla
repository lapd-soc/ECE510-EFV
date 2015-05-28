-------------------------- MODULE ElevatorControl --------------------------
EXTENDS Naturals, TLC
CONSTANT TotalElevators, TotalFloors
VARIABLE elevators, request


TypeInvariant == /\ elevators \in [ (1..TotalElevators) -> [ floor : (1..TotalFloors), available : {TRUE, FALSE} ]]
                 /\ request   \in [ (1..TotalFloors) -> {TRUE, FALSE} ]

Init == /\ TypeInvariant
(*
        /\ elevators.floor = [e \in TotalElevators |-> 1]
        /\ elevators.available = [e \in TotalElevators |-> TRUE] 
  *)      



ServiceRequested == \A r \in TotalFloors : request[r] = TRUE

ServiceRequest(req) ==
    /\ elevators.available[req] 

Next == /\ 
        /\ PrintT(elevators)

(*

TypeInvariant  ==  chan \in [val : Data,  rdy : {0, 1},  ack : {0, 1}]
-----------------------------------------------------------------------
Init  ==  /\ TypeInvariant
          /\ chan.ack = chan.rdy 

Send(d) ==  /\ chan.rdy = chan.ack
            /\ chan' = [chan EXCEPT !.val = d, !.rdy = 1 - @]

Rcv     ==  /\ chan.rdy # chan.ack
            /\ chan' = [chan EXCEPT !.ack = 1 - @]

Next  ==  (\E d \in Data : Send(d)) \/ Rcv
*)

(*
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
*)
          
Spec == Init /\ [][Next]_<<elevators, request>>
-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant

=============================================================================
\* Modification History
\* Last modified Tue May 26 16:12:40 PDT 2015 by Me
\* Created Tue May 26 10:24:21 PDT 2015 by Me
