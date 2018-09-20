(define (stream pick-and-place)
  (:function (Distance ?q1 ?q2)
    (and (Conf ?q1) (Conf ?q2))
  )

  ; This representation is nice because no need to specify free variables
  (:optimizer gurobi

    ; Constructs a set of free variables
    ;(:variable ?p
    ;  :inputs (?b) ; input-domain, variable-domain
    ;  :domain (Block ?b)
    ;  :graph (Pose ?b ?p)) ; TODO: also specify the initial number
    (:variable ?p
      :inputs (?b ?r)
      :domain (Placeable ?b ?r)
      :graph (and (Contained ?b ?p ?r) (Pose ?b ?p)))
    ;(:variable ?q
    ;  :graph (Conf ?q)) ; TODO: codomain?
    (:variable ?q
      :inputs (?b ?p)
      :domain (Pose ?b ?p)
      :graph (and (Kin ?b ?q ?p) (Conf ?q)))

    ; Constraint forms that can be optimized
    ; TODO: ensure that no fixed things are optimized by making conditions involve just variable
    ;(:constraint (Contained ?b ?p ?r)
    ; :necessary (and (Placeable ?b ?r) (Pose ?b ?p)))
    ;(:constraint (Kin ?b ?q ?p)
    ; :necessary (and (Pose ?b ?p) (Conf ?q)))
    (:constraint (CFree ?b1 ?p1 ?b2 ?p2)
     :necessary (and (Pose ?b1 ?p1) (Pose ?b2 ?p2)))
    (:objective Distance) ; Treating predicate as objective
  )

  (:optimizer rrt
    ;(:variable ?t
    ;  :graph (Traj ?t))
    (:variable ?t
      :inputs (?q1 ?q2)
      :domain (and (Conf ?q1) (Conf ?q2))
      :graph (and (Motion ?q1 ?t ?q2) (Traj ?t)))
  )

  ; Alternatively, this defines a set of streams
  ; The key distinction is that free can be an input/output
  ;(:optimizer gurobi
  ;  (:constraint (Contained ?b ?p ?r) ; TODO: make this a cluster
  ;   :necessary (and (Placeable ?b ?r) (Pose ?b ?p)) ; implied, rules, types, necessary?
  ;   :fixed (?b ?r) ; Better to default to not free?
  ;   ; :unique (?p)
  ;   :mutex (?p) ; Semantics - can be in at most one Contained
  ;   ; :free (?p)
  ;  )
  ;  (:constraint (Kin ?b ?q ?p)
  ;   :necessary (and (Block ?b) (Pose ?b ?p) (Conf ?q))
  ;   :fixed (?b) ; Not optimizable
  ;   ; :unique (?q)
  ;   :mutex (?q ?p) ; With respect to other variables, can only be used once
  ;   ; :free (?q ?p)
  ;  )
  ;  (:constraint (CFree ?b1 ?p1 ?b2 ?p2)
  ;   :necessary (and (Block ?b1) (Pose ?b1 ?p1) (Block ?b2) (Pose ?b2 ?p2))
  ;   :fixed (?b1 ?b2)
  ;   ; :free (?p1 ?p2)
  ;  )
  ;)
)