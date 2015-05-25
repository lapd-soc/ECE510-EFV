----------------------------- MODULE TSControl -----------------------------
EXTENDS Naturals, Sequences
VARIABLE Clock, NSLight, EWLight,new

clockSig == INSTANCE OneBitClock WITH clock <- Clock
NorthSouthLight == INSTANCE TrafficSignal WITH Light <- NSLight
EastWestLight == INSTANCE TrafficSignal WITH Light <- EWLight

TypeInvariant == /\ NSLight \in {"red","green","yellow"}

Init == new' = 0

Next ==

Spec == Init /\ [][Next]_<<NSLight, EWLight>>

-----------------------------------------------------------------------------
THEOREM Spec => []TypeInvariant
=============================================================================
\* Modification History
\* Last modified Thu May 21 15:49:12 PDT 2015 by Me
\* Created Tue May 19 16:49:35 PDT 2015 by Me
