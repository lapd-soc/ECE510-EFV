------------------------------ MODULE Counter ------------------------------
EXTENDS Naturals
VARIABLE hr
HCini  ==  hr \in (1 .. 12)
HCnxt  ==  hr' = IF hr # 12 THEN hr + 1 ELSE 1
HC  ==  HCini /\ [][HCnxt]_hr
--------------------------------------------------------------
THEOREM  HC => []HCini
=============================================================================
\* Modification History
\* Last modified Tue May 19 16:48:24 PDT 2015 by Me
\* Created Tue May 19 16:44:16 PDT 2015 by Me
