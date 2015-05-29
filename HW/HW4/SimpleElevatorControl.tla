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
*)

EXTENDS Naturals, TLC
CONSTANT TotalFloors
VARIABLE elevator, request


TypeInvariant == /\ elevator \in [ floor : (1 .. TotalFloors), available : {TRUE,FALSE}, requestedFloor : (0 .. TotalFloors) ]
                 /\ request \in [ (1 .. TotalFloors) -> {TRUE,FALSE} ]

------------------------------------------------------------------------------
Init == /\ TypeInvariant
        /\ elevator.floor = 1
        /\ elevator.available = TRUE
        /\ elevator.requestedFloor = 0
        /\ request = [ req \in (1 .. TotalFloors) |-> FALSE ]


NextElevator(req) ==
    /\ elevator.available = TRUE 
    /\ elevator' = IF request[req] = TRUE THEN [elevator EXCEPT !.available = FALSE, !.requestedFloor = req]
                                          ELSE elevator
    /\ request'  = IF request[req] = TRUE THEN [request EXCEPT ![req] = FALSE]
                                          ELSE request

NextFloor ==
    /\ elevator.available = FALSE
    /\ elevator' = IF elevator.floor = elevator.requestedFloor      THEN [elevator EXCEPT !.available = TRUE, !.requestedFloor = 0]
                   ELSE IF elevator.requestedFloor = 0              THEN elevator
                   ELSE IF elevator.floor > elevator.requestedFloor THEN [elevator EXCEPT !.floor = (elevator.floor % TotalFloors) - 1]
                   ELSE IF elevator.floor < elevator.requestedFloor THEN [elevator EXCEPT !.floor = (elevator.floor % TotalFloors) + 1]
                   ELSE elevator
    /\ UNCHANGED request
 
RequestMade == \A fl \in (1..TotalFloors) : request[fl] = TRUE               

NextRequest(req) == 
    /\ elevator.available = TRUE
    /\ request' = IF RequestMade = FALSE THEN [ request EXCEPT ![req] = TRUE ]
                                         ELSE request
    /\ UNCHANGED elevator

NextOperation(req) ==
    \/ NextElevator(req)
    \/ NextRequest(req)

Next == /\ \/ \E req \in (1..TotalFloors): NextOperation(req)
           \/ NextFloor
        /\ PrintT(elevator)
        /\ PrintT(request)


Spec == Init /\ [][Next]_<<elevator, request>>
-----------------------------------------------------------------------------
THEOREM Spec => TypeInvariant
=============================================================================
\* Modification History
\* Last modified Thu May 28 18:17:12 PDT 2015 by Me
\* Created Tue May 26 16:13:01 PDT 2015 by Me
