(namespace (read-msg 'ns))

(interface claim-topics-registry-v1 

  (defcap CLAIM-TOPIC-ADDED:bool (claim-topic:integer)
    @doc "this event is emitted when a claim topic has been added to the ClaimTopicsRegistry                 \
    \   the event is emitted by the 'add-claim-topic' function                                               \               
    \   `claim-topic` is the required claim added to the Claim Topics Registry"
    @event        
  )
  
  (defcap CLAIM-TOPIC-REMOVED:bool (claim-topic:integer)
    @doc "this event is emitted when a claim topic has been removed from the ClaimTopicsRegistry             \
    \   the event is emitted by the 'remove-claim-topic' function                                            \               
    \   `claim-topic` is the required claim removed from the Claim Topics Registry"
    @event        
  )

  ;; Declare the function signatures for adding, removing, and getting claim topics
  (defun add-claim-topic:bool (claimTopic:integer)
    @doc "Add a trusted claim topic, only the owner can call this function")

  (defun remove-claim-topic:bool (claimTopic:integer)
    @doc "Remove a trusted claim topic, only the owner can call this function")

  (defun get-claim-topics:[integer] ()
    @doc "Get the list of trusted claim topics") 
)