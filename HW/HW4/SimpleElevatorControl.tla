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
CONSTANT TotalElevators, TotalFloors
VARIABLE elevator, request


TypeInvariant == /\ elevator \in [ (1 .. TotalElevators) -> [ floor : (1 .. TotalFloors), available : {TRUE,FALSE}, requestedFloor : (0 .. TotalFloors) ] ]
                 /\ request \in [ (1 .. TotalFloors) -> {TRUE,FALSE} ]

------------------------------------------------------------------------------
Init == /\ TypeInvariant
        /\ elevator = [ elev \in (1..TotalElevators) |-> [elevator EXCEPT !.floor = 1, !.available = TRUE, !.RequestedFloor = 0] ]
        /\ request = [ req \in (1 .. TotalFloors) |-> FALSE ]


NextElevator(elev,req) ==
    /\ (elevator[elev]).available = TRUE 
    /\ elevator' = IF request[req] = TRUE THEN [elevator EXCEPT ![elev].available = FALSE, ![elev].requestedFloor = req]
                                          ELSE elevator
    /\ request'  = IF request[req] = TRUE THEN [request EXCEPT ![req] = FALSE]
                                          ELSE request

NextFloor(elev) ==
    /\ (elevator[elev]).available = FALSE
    /\ elevator' = IF (elevator[elev]).floor = (elevator[elev]).requestedFloor      THEN [elevator EXCEPT ![elev].available = TRUE, ![elev].requestedFloor = 0]
                   ELSE IF (elevator[elev]).requestedFloor = 0              THEN elevator
                   ELSE IF (elevator[elev]).floor > (elevator[elev]).requestedFloor THEN [elevator EXCEPT ![elev].floor = (elevator[elev].floor % TotalFloors) - 1]
                   ELSE IF (elevator[elev]).floor < (elevator[elev]).requestedFloor THEN [elevator EXCEPT ![elev].floor = (elevator[elev].floor % TotalFloors) + 1]
                   ELSE elevator
    /\ UNCHANGED request
 
RequestMade == \A req \in (1..TotalFloors) : request[req] = TRUE               

NextRequest(req) == 
    /\ elevator.available = TRUE
    /\ request' = IF RequestMade = FALSE THEN [ request EXCEPT ![req] = TRUE ]
                                         ELSE request
    /\ UNCHANGED elevator

NextOperation(elev,req) ==
    \/ NextElevator(elev,req)
    \/ NextFloor(elev)
    \/ NextRequest(req)

Next == /\ \E elev \in (1..TotalElevators) : (\E req \in (1..TotalFloors): NextOperation(elev,req))
           
        /\ PrintT(elevator)
        /\ PrintT(request)


Spec == Init /\ [][Next]_<<elevator, request>>
-----------------------------------------------------------------------------
THEOREM Spec => TypeInvariant
=============================================================================
\* Modification History
\* Last modified Thu May 28 18:57:42 PDT 2015 by Me
\* Created Tue May 26 16:13:01 PDT 2015 by Me
