----------------------- MODULE SimpleElevatorControl -----------------------
(*
1. Loop through elevators (currently only one)
    a. Is elevator available
        i. Yes
            1. Is a request made?
                a. Yes
                    i. Make elevator unavailable.
                    ii. Move elevator to service request
                b. No, do nothing
        ii. No, do nothing for that elevator because it is servicing a request
        
        
   This module only has a single elevator but it works more like a normal
   elevator, in that it increment and decrements one floor at a time.
   Statistics:
        Diameter = 12
        States Found = 166
        Distinct States = 102
        
   I believe that additional improvements could be made to this to use invariants
   in order to check to every request is serviced and so forth. This in itself was
   nearly 20 hours of work to refine it and get it to its current state, so I will
   accept it as a imperfect design but much learned.
*)
EXTENDS Naturals, TLC
CONSTANT TotalFloors
VARIABLE elevator, request


TypeInvariant ==
    /\ elevator \in [ floor          : (1 .. TotalFloors),
                      available      : {TRUE,FALSE}, 
                      requestedFloor : (0 .. TotalFloors) ]
    /\ request  \in [ (1 .. TotalFloors) -> {TRUE,FALSE} ]

------------------------------------------------------------------------------
Init == 
    /\ TypeInvariant
    /\ elevator.floor = 1
    /\ elevator.available = TRUE
    /\ elevator.requestedFloor = 0
    /\ request = [ req \in (1 .. TotalFloors) |-> TRUE ]


NextElevator(req) ==
    /\ elevator.available = TRUE 
    /\ elevator' = IF request[req] = TRUE
                        THEN [elevator EXCEPT !.available = FALSE, !.requestedFloor = req]
                   ELSE elevator
    /\ request'  = IF request[req] = TRUE 
                        THEN [request EXCEPT ![req] = FALSE]
                   ELSE request

NextFloor ==
    /\ elevator.available = FALSE
    /\ elevator' = IF elevator.floor = elevator.requestedFloor 
                        THEN [elevator EXCEPT !.available = TRUE, !.requestedFloor = 0]
                   ELSE IF elevator.floor > elevator.requestedFloor 
                        THEN [elevator EXCEPT !.floor = (elevator.floor % TotalFloors) - 1]
                   ELSE IF elevator.floor < elevator.requestedFloor 
                        THEN [elevator EXCEPT !.floor = (elevator.floor % TotalFloors) + 1]
                   ELSE elevator
    /\ UNCHANGED request

RequestMade == 
    \A req \in (1..TotalFloors) : request[req] = TRUE               
                
NextRequest(req) == 
    /\ elevator.available = TRUE
    /\ request' = IF RequestMade = FALSE THEN [ request EXCEPT ![req] = TRUE ]
                                         ELSE request
    /\ UNCHANGED elevator

Next == 
    /\ \/ \E req \in (1..TotalFloors): NextElevator(req)
       \/ NextFloor
    /\ PrintT(elevator)


Spec == 
    Init /\ [][Next]_<<elevator, request>>
-----------------------------------------------------------------------------
THEOREM Spec => TypeInvariant
=============================================================================
\* Modification History
\* Last modified Fri May 29 23:25:42 PDT 2015 by Me
\* Created Tue May 26 16:13:01 PDT 2015 by Me
