----------------------------- MODULE TSControl -----------------------------
EXTENDS Naturals, Sequences
VARIABLE Clock, NSLight, EWLight

clockSig == INSTANCE OneBitClock WITH clock <- Clock
NorthSouthLight == INSTANCE TrafficSignal WITH Light <- NSLight
EastWestLight == INSTANCE TrafficSignal WITH Light <- EWLight

Init == /\ IF NorthSouthLight!


=============================================================================
\* Modification History
\* Last modified Tue May 19 18:28:04 PDT 2015 by Me
\* Created Tue May 19 16:49:35 PDT 2015 by Me
