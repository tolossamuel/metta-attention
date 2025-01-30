


(= (setAv $pattern ($sti $lti $vlti))

    (if (== (get-metatype $pattern) Symbol) 
        ; (attention value for symbol)
        ; atom doesn not have any type so delete it and add it with av
        ; atom might only have stv as a type so take the stv and add av to it as additional type and then delete the previous and add it as a new atom
        ; atom might only have av as a type so delete the atom and and add the new atom with updated av (dont forget to delete the previous atom)
        ; atom might have both stv and av
        
        (case (get-type $pattern) 
            (
                (%Undefined% (add-atom &self (: $pattern (AV $sti $lti $vlti))))

                ((STV $a $b) (let* (
                     ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &self $y))))
                ) (add-atom &self (: $pattern ((AV $sti $lti $vlti) (STV $a $b))))) )

                ((AV $a $b $c) (let* (
                     ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &self $y))))
                ) (add-atom &self (: $pattern (AV $sti $lti $vlti)))))
                
                (((STV $a $b) (AV $a $b $c)) (let* (
                     ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                        (let $y (car-atom $x)
                            (remove-atom &self $y))))
                ) (add-atom &self (: $pattern ((AV $sti $lti $vlti) (STV $a $b))))))
            )
        )
             (case $pattern (
                        ( ($a) 
                            (case (get-type ($a) ) 
                                (
                                    ; ($_ (get-type ($a)))
                                    (%Undefined% (let* (
                                                    ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                              (let $y (car-atom $x)
                                                                    (remove-atom &self $y))))
                                            ) (let $x (car-atom $pattern) (add-atom &self (: $x (-> (AV $sti $lti $vlti))) )) ) )

                                    ((STV $v $d) (let* (
                                                    ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                              (let $y (car-atom $x)
                                                                    (remove-atom &self $y))))
                                            ) (let $x (car-atom $pattern) (add-atom &self (: $x (-> ((AV $sti $lti $vlti) (STV $v $d) ) )) )) ))

                                    ((AV $s $k $b) (let* (
                                                    ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                              (let $y (car-atom $x)
                                                                    (remove-atom &self $y))))
                                            ) (let $x (car-atom $pattern) (add-atom &self (: $x (-> (AV $sti $lti $vlti))) )) ) )

                                    (((STV $f $o) (AV $s $b $c)) (let* (
                                                    ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                              (let $y (car-atom $x)
                                                                    (remove-atom &self $y))))
                                            ) (let $x (car-atom $pattern) (add-atom &self (: $x (-> ((AV $sti $lti $vlti) (STV $v $d) ) )) )) ) )
                                )
                            )
                        )

                        (($link $a $b) 
                         
                            (case (get-type ($link $a $b) ) 
                                    (
                                        ; ($_ (get-type ($a)))
                                        (%Undefined% (let* (
                                                        ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                                $x))
                                                ) $_ ) )

                                        ((STV $v $d) (let* (
                                                        ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                                (let $y (car-atom $x)
                                                                        (remove-atom &self $y))))
                                                ) (let $x (car-atom $pattern) (add-atom &self (: $x (-> $a $b ((AV $sti $lti $vlti) (STV $v $d) ) )) )) ))

                                        ((AV $s $k $f)(let* (
                                                        ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                                $x))
                                                ) (hello) ) )

                                        (((STV $f $o) (AV $s $b $c)) (let* (
                                                        ( $_ (let $x (collapse (match &self (: $pattern $_) (: $pattern $_)))
                                                                (let $y (car-atom $x)
                                                                        (remove-atom &self $y))))
                                                ) (let $x (car-atom $pattern) (add-atom &self (: $x (-> $a $b ((AV $sti $lti $vlti) (STV $v $d) ) )) )) ) )
                                    )
                                )
                        )
                      )
                     )
                )
            )






; (: A (AV 400 200 0))

; ! (get-type A)
; ! (setAv A (200 200 0))
; ! (get-type A)


; (: b (-> (STV 0.1 0.9)))


; ! (setAv (b) (1 2 3))
; ! (get-type (b) )

(: link (-> a b (AV 1 2 3)))

! (get-type (link a b))

! (setAv (link a b) (100 2 3))
! (get-type (link a b))

; ! (setAv (link (a) (b)) (1 2 3))
; ! (get-space &self)
; ! (println! (get-space &self))