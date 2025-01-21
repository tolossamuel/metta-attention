

### Things i should think and know about

- what is the current attention value of atom reprsentation and its difference from methods found in AVUtils files
- what is attentionvaluelink and its reprsentation and/or advantage
- should the reprsentation come to metta?(obviously we need attentionvaluelink right?) if yes what is the reprsentation?


### About Attention value reprsentation

- atoms in general have two types Link and Node
- atoms are also a type of `atom` which itself is also type of `protoatom`
- Values are type of `protoatom` 

### what i should do regarding atom and value reprsentation in metta

- how you can represent atom in metta with full information or in similar way reprsented in c++/schem implementation. 
- how you implement the type hirerchy in metta
- how you implement/represent link
- finally implement atom, link between atoms, value of an atom, attention value of atom and value of a link


### Node

- the c++ implementation have the following implementation

    ```
    class Node : public Atom
   {
       private:
         std::string name;
       public:
         Node(Type, std::string &);
         const std::string& getName() const;
         Value getValue(const Atom& key) const;
         std::string toString() const;
   };

    ```
#### Extensions of Node

- specific type of node can be foremed in the following way

    ```
     class NumberNode : public Node
   {
       private:
         std::vector<double> values;
       public:
         NumberNode(double);
         NumberNode(std::vector<double>);
         double get_value();
         std::vector<double> get_values();
   };

    ```

### Link

    ```
    typedef std::shared_ptr<Atom> Handle;  // Handles are smart pointers to Atoms
 
    class Link : public Atom
    {
        private:
        std::vector<Handle> _outgoing;
        public:
        Link(Type, const std::vector<Handle>&);
            
        const std::vector<Handle>& getOutgoingSet()
                { return _outgoing; }
        size_t getArity() const {return _outgoing.size(); }
        std::string toString() const;
        
        };

    ```


- so finally we have to find that how we can attach value fully defined atom and aslo i should able to find all values attached with an atom so i can filter using the key to get the value.

- so waht i think atoms should contain
    - a node with its type
    - so we hould have a defination of node type
    - so add_node function can recive the type and the symbol
    - what about the type and the symbole doesnt match?

- have link type called Link and other link inherit from this type

- have a type called value and all value type will inherit from this.

BZW how does uniqness of an atom in atomspace will be implemented if metta is non-deterministic

does type check work in metta


#### finally implement the type hierarchy listed in this page [type hierarchy](https://wiki.opencog.org/w/Type_hierarchy)

- this will encompass both type defination and formal defination and relation of atoms(node, link and values).

```

        FLOAT_VALUE <- VALUE    // vector of floats, actually.
        STRING_VALUE <- VALUE
        LINK_VALUE <- VALUE     // vector of values ("link" holding values)
        VALUATION <- VALUE

        // All of the different flavors of truth values
        TRUTH_VALUE <- FLOAT_VALUE
        SIMPLE_TRUTH_VALUE <- TRUTH_VALUE
        COUNT_TRUTH_VALUE <- TRUTH_VALUE
        INDEFINITE_TRUTH_VALUE <- TRUTH_VALUE
        FUZZY_TRUTH_VALUE <- TRUTH_VALUE
        PROBABILISTIC_TRUTH_VALUE <- TRUTH_VALUE
        EVIDENCE_COUNT_TRUTH_VALUE <- TRUTH_VALUE

        // The AttentionValue
        ATTENTION_VALUE <- FLOAT_VALUE

        // Base of hierarchy - NOTE: ATOM will not have a corresponding Python
        // construction function to avoid identifier conflict with the Atom object.
        ATOM <- VALUE
        NODE <- ATOM
        LINK <- ATOM

        CONCEPT_NODE <- NODE
        NUMBER_NODE <- NODE

        // Basic Links
        ORDERED_LINK <- LINK
        UNORDERED_LINK <- LINK
 ```


(: Value Type)

(: Atom Value)

(: FloatValue Value)

(: Node Atom)

(: Link Atom)

(: TruthValue FloatValue)

(: SimpleTruthValue TruthValue)

(: AttentionValue FloatValue)


(: ConceptNode Node)

(: PredicateNode Node)

(: NumberNode Node)

(: FreeLink Link)

(: FunctionLink FreeLink)

(: ValueOfLink FunctionLink)

(: AttentionValueOfLink ValueOfLink)



- function i should have

    - function that create a node and add to a space
    - function that create a link and add to space
    - function that attach attention value to an atom
    - function that attach truth value to an atom

- second round function implementation 

    - function that change the attention value an atom

    - function that can get sti, lti and vlti of an atom
    - function that can get mean and confidence value of an atom

