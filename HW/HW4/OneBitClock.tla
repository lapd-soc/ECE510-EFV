---------------------------- MODULE OneBitClock ----------------------------
VARIABLE clock
OBCini  ==  (clock = 0) \/ (clock = 1)
OBCnxt  ==  \/ /\ clock = 0
               /\ clock' = 1
            \/ /\ clock = 1
               /\ clock' = 0
OBC  ==  OBCini /\ [][OBCnxt]_clock
--------------------------------------------------------------
THEOREM  OBC => []OBCini
=============================================================================
\* Modification History
\* Last modified Tue May 19 16:27:54 PDT 2015 by Me
\* Created Tue May 19 16:04:37 PDT 2015 by Me
