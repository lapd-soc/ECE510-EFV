----------------------------- MODULE BasicTSControl -----------------------------
EXTENDS Naturals

VARIABLE state, NSlight, EWlight, Timer, Accident


LightSequence == <<"red", "green", "yellow">>
LightSequenceLen == 3

TypeInvariant == /\ NSlight \in LightSequence
                 /\ EWlight \in LightSequence
                 /\ Timer \in (0 .. 5)
                 /\ Accident \in {TRUE, FALSE}
                 
Init == /\ state = 1
        /\ NSlight = "red"
        /\ EWlight = "red"
        /\ Timer = 0
        /\ Accident = FALSE
        
AccidentHappened == /\ NSlight # "red"
                    /\ EWlight # "red"

NoAccident == 
  \A i \in (1..TotalDirections) :  ( \/ (lights[i] = "green") \/ (lights[i] = "yellow") )
                => \A j \in (1..TotalDirections): 
               \/ i=j 
               \/ lights[j] = "red"



Next == /\ LET nextState == IF state # LightSequenceLen THEN state+1 ELSE 1
           IN   /\ state' = nextState
                /\ NSlight' = LightSequence[nextState]
                /\ EWlight' = LightSequence[nextState]
        /\ Accident' = AccidentHappened
        /\ Timer' = (Timer % 5) + 1
                   
Spec == Init /\ [][Next]_<<state, NSlight, EWlight, Timer, Accident>>

------------------------------------------------------------------------------

THEOREM Spec => []TypeInvariant

=============================================================================
\* Modification History
\* Last modified Thu May 21 17:57:05 PDT 2015 by Me
\* Created Tue May 19 16:49:35 PDT 2015 by Me
