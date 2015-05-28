----------------------- MODULE SimpleElevatorControl -----------------------
EXTENDS Naturals, TLC
CONSTANT TotalFloors
VARIABLE elevator, request


TypeInvariant == /\ elevator \in [ floor : (1 .. TotalFloors), available : {TRUE,FALSE} ]
                 /\ request \in [ (1 .. TotalFloors) -> {TRUE,FALSE} ]
------------------------------------------------------------------------------
Init == /\ TypeInvariant
        /\ elevator.floor = 1
        /\ elevator.available = TRUE
        /\ request = [ req \in (1 .. TotalFloors) |-> FALSE ]


NextAvailable(req) ==
    /\ elevator.available = FALSE
    /\ elevator' = IF elevator.floor = req THEN [elevator EXCEPT !.availabe = TRUE]
                                           ELSE elevator

NextFloor(req) ==
    /\ elevator.available = TRUE
    /\ elevator' = IF request[req] = TRUE THEN [elevator EXCEPT !.floor = req]
                                          ELSE elevator

NextElevator(req) ==
    /\ elevator.available = TRUE
    /\ elevator' = IF request[req] = TRUE THEN [elevator EXCEPT !.available = FALSE]
                                          ELSE elevator

NextRequest(req) == 
    /\ elevator.available = TRUE
    /\ request' = [ request EXCEPT ![req] = TRUE ]

NextOperation(req) == 
    \/ NextAvailable(req)
    \/ NextFloor(req)
    \/ NextElevator(req)
    \/ NextRequest(req)

Next == /\ (\E req \in (1..TotalFloors): NextOperation(req))
        /\ PrintT(elevator)


Spec == Init /\ [][Next]_<<elevator, request>>
-----------------------------------------------------------------------------
THEOREM Spec => TypeInvariant
=============================================================================
\* Modification History
\* Last modified Thu May 28 10:24:08 PDT 2015 by Me
\* Created Tue May 26 16:13:01 PDT 2015 by Me

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

Spec  ==  Init /\ [][Next]_chan




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



*)
