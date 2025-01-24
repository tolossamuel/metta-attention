!(register-module! ../../../metta-attention)
!(import! &self metta-attention:attention-bank:attention-value:getter-and-setter)

! (setAv A (200 200 0))
! (setStv A (0.1 0.9))

; ! (setAv (c) (200 200 0))
! (setStv (c) (0.1 0.9))

; ! (setStv A (0.1 0.9))
; ! (setStv A (1 0.9))

! (assertEqual (getStv A) (STV 0.1 0.9))
! (assertEqual (getAv A) (AV 200 200 0))

; ! (assertEqual (getAv (c)) (AV 200 200 0))
! (assertEqual (getStv (c)) (STV 0.1 0.9))


; ! (assertEqual (getAv (v)) (AV 200 200 0))
; ! (get-type (v))
; ! (assertEqual (getMean A) 1)
; ! (assertEqual (getConfidence A) 0.9)
; ! (assertEqual (getSTI A) 400)
; ! (assertEqual (getLTI A) 400)
; ! (assertEqual (getVLTI A) 1)



; ! (setAvForExpression (V) (200 200 0))
; ! (getAvForExpression (V))

; ! (setAvForExpression (V) (200 200 0))
; ! (get-type (V))



; (: V (-> (STV 0 1)))
; ! (get-type (V) )
; ! (getSTVForExpression (V) )

; (: C (-> (AV 200 200 0)))

; ! (get-type (C) )
; !(get-type (a))
; ! (get-type (K))
; ! (assertEqual (getAv (V)) (AV 200 200 0))


; ! (assertEqual (getAv (V) ) (AV 200 200 0))

; ! (setStv (Inheritancelink 
;     (InheritanceNode A) 
;     (InheritanceNode B)) 
;     (0.1 0.9))
; ! (assertEqual (getStv (Inheritancelink 
;     (InheritanceNode A) 
;     (InheritanceNode B))) (STV 0.1 0.9))

; ! (get-metatype a)
; ! (get-metatype (a))


;  ! (println! (get-atoms &self))
