(define (domain pick-and-place)
  (:requirements :strips :equality)
  (:predicates
    (Stackable ?o ?s)
    (Sink ?r)
    (Stove ?r)

    (Grasp ?o ?g)
    (Kin ?o ?p ?g ?q ?t)
    (FreeMotion ?q1 ?t ?q2)
    (HoldingMotion ?q1 ?t ?q2 ?o ?g)
    (Supported ?o ?p ?s)
    (TrajCollision ?t ?o2 ?p2)

    (AtPose ?o ?p)
    (AtGrasp ?o ?g)
    (HandEmpty)
    (AtConf ?q)
    (CanMove)
    (Cleaned ?o)
    (Cooked ?o)

    (On ?o ?s)
    (Holding ?o)
    (UnsafeTraj ?t)
  )

  (:action move_free
    :parameters (?q1 ?q2 ?t)
    :precondition (and (FreeMotion ?q1 ?t ?q2)
                       (AtConf ?q1) (HandEmpty) (CanMove) (not (UnsafeTraj ?t)))
    :effect (and (AtConf ?q2)
                 (not (AtConf ?q1)) (not (CanMove)))
  )
  (:action move_holding
    :parameters (?q1 ?q2 ?o ?g ?t)
    :precondition (and (HoldingMotion ?q1 ?t ?q2 ?o ?g)
                       (AtConf ?q1) (AtGrasp ?o ?g) (CanMove) (not (UnsafeTraj ?t)))
    :effect (and (AtConf ?q2)
                 (not (AtConf ?q1)) (not (CanMove)))
  )
  (:action pick
    :parameters (?o ?p ?g ?q ?t)
    :precondition (and (Kin ?o ?p ?g ?q ?t)
                       (AtPose ?o ?p) (HandEmpty) (AtConf ?q) (not (UnsafeTraj ?t)))
    :effect (and (AtGrasp ?o ?g) (CanMove)
                 (not (AtPose ?o ?p)) (not (HandEmpty)))
  )
  (:action place
    :parameters (?o ?p ?g ?q ?t)
    :precondition (and (Kin ?o ?p ?g ?q ?t)
                       (AtGrasp ?o ?g) (AtConf ?q) (not (UnsafeTraj ?t)))
    :effect (and (AtPose ?o ?p) (HandEmpty) (CanMove)
                 (not (AtGrasp ?o ?g)))
  )
  (:action clean
    :parameters (?o ?s)
    :precondition (and (Stackable ?o ?s) (Sink ?s)
                       (On ?o ?s))
    :effect (Cleaned ?o)
  )
  (:action cook
    :parameters (?o ?s)
    :precondition (and (Stackable ?o ?s) (Stove ?s)
                       (On ?o ?s) (Cleaned ?o))
    :effect (and (Cooked ?o)
                 (not (Cleaned ?o)))
  )

  (:derived (On ?o ?s)
    (exists (?p) (and (Supported ?o ?p ?s)
                      (AtPose ?o ?p)))
  )
  (:derived (Holding ?o)
    (exists (?g) (and (Grasp ?o ?g)
                      (AtGrasp ?o ?g)))
  )
  ;(:derived (UnsafeTraj ?t)
  ;  (exists (?o2 ?p2) (and (TrajCollision ?t ?o2 ?p2)
  ;                         (AtPose ?o2 ?p2)))
  ;)
)