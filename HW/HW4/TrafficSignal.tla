--------------------------- MODULE TrafficSignal ---------------------------
VARIABLE Light
Lightini == Light \in {"red", "green", "yellow"}
Lightnxt == Light' = IF Light = "red" THEN "green" ELSE IF Light = "green" THEN "yellow" ELSE IF Light = "yellow" THEN "red" ELSE Light

LightSequence == Lightini /\ [][Lightnxt]_Light 

-----------------------------------------------------------------------------
THEOREM LightSequence => []Lightini
=============================================================================
\* Modification History
\* Last modified Tue May 19 18:18:53 PDT 2015 by Me
\* Created Tue May 19 15:48:30 PDT 2015 by Me
