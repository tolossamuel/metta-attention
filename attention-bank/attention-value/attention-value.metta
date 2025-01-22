
(: Value Type)

(: Atom Value)

(: FloatValue Value)

(: Node Atom)

(: NodeType Type)

(: Link Atom)

(: LinkType Link)

(: TruthValue FloatValue)


(: AttentionValue FloatValue)


(: ConceptNode NodeType)

(: InheritanceLink LinkType)

(: PredicateNode NodeType)

(: NumberNode NodeType)

(: FreeLink LinkType)

(: FunctionLink FreeLink)

(: ValueOfLink FunctionLink)

(: AttentionValueOfLink ValueOfLink)

(: strength FloatValue)
(: Confidence FloatValue)
(: AttentionValue FloatValue)

(: STI FloatValue)
(: LTI FloatValue)
(: VLTI FloatValue)

(: SimpleTruthValue (-> strength Confidence TruthValue))
(: AttentionValue (-> STI LTI VLTI AttentionValue))

; - function i should have

;     - function that create a node and add to a space
;     - function that create a link and add to space
;     - function that attach attention value to an atom
;     - function that attach truth value to an atom

; - second round function implementation 

;     - function that change the attention value an atom

;     - function that can get sti, lti and vlti of an atom
;     - function that can get mean and confidence value of an atom


; example node atoms

(ConceptNode "A")
(ConceptNode "B")

; example link atoms
(InheritanceLink 
    (ConceptNode "A")
    (ConceptNode "B")
)

; example attention value atoms
(ConceptNode "A" 
    (AttentionValue 0.1 0.2 0.3) 
    (SimpleTruthValue 0.9 0.1) 
    )

; example attention value atoms for link
(InheritanceLink 
    (ConceptNode "A")
    (ConceptNode "B")

    (AttentionValue 0.1 0.2 0.3) 
    (SimpleTruthValue 0.9 0.1) 
    )

(: add-node (-> NodeType symbol Node))

(= (add-node $nodeType $name)
    (add-atom &self ($node $name))
)

(: add-link (-> Link Node Node Link))
(= (add-link $link $from $to)
    (add-atom &self ($link $from $to))
)




; this function check the type of the atom and add a tuple to that specific type of atom
; if the atom is a node then it will add a tuple to the node
; if the atom is a link then it will add a tuple to the link
(: set-stv (-> Atom SimpleTruthValue Atom))
(= (set-stv $atom $stv) 
    ( if (== (get-type $atom) Node) 
        ; traverse and add the tuple of stv to the node
        ; else if the atom is a link then add the tuple to the link
    )
)

(: set-av (-> Atom AttentionValue Atom))
(= (set-av $atom $av) 
    ( if (== (get-type $atom) Node) 
        ; traverse and add the tuple of av to the node
        ; else if the atom is a link then add the tuple to the link
    )
)



; why this kind of structure is necessasary

;1. the type of atom should be node or link nothing else
;2. it enables as to detect the type of nodes and links and operate on them
;3. this structure is scalabel because anyone can its own type and value of an atom and operate on it
;4. it follows the principle of atom type and value relation and also type hierarchy