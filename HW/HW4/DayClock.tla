------------------------------ MODULE DayClock ------------------------------
(*
    Statistics:
        Diameter = 1
        States Found = 288
        Distinct States = 144
*)

EXTENDS Naturals
VARIABLE hr,dy
HCini == /\ hr \in (1 .. 24)
         /\ dy \in (0 .. 5)
HCnxt == /\ hr' = (hr % 24) + 1
         /\ dy' = IF hr = 24 THEN (dy % 5) + 1 ELSE dy
         
HC    == HCini /\ [][HCnxt]_<<hr,dy>>
-----------------------------------------------------------------------------
THEOREM HC => []HCini
=============================================================================
\* Modification History
\* Last modified Fri May 29 23:31:39 PDT 2015 by Me
\* Created Tue May 19 11:15:18 PDT 2015 by Me
