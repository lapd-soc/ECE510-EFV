------------------------------ MODULE DayClock ------------------------------
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
\* Last modified Tue May 19 15:46:12 PDT 2015 by Me
\* Created Tue May 19 11:15:18 PDT 2015 by Me
