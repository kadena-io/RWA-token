(namespace (read-msg 'ns))

(interface agent-role-v1
  @doc "Module for managing agents with owner access control"

  (defcap AGENT-ADDED:bool (agent:string)
    @doc "Event emitted when an agent is added."
    @event)

  (defcap AGENT-REMOVED:bool (agent:string)
    @doc "Event emitted when an agent is removed."
    @event)

  (defcap OWNERSHIP-TRANSFERRED:bool (old-owner-guard:guard new-owner-guard:guard)
    @doc "Event emitted when ownership is transferred"
    @event
  )

  (defcap ONLY-OWNER:bool (role:string)
    @doc "Capability that can be required to validate whether an address has the owner role"
    @managed)

  (defcap ONLY-AGENT:bool (role:string)
    @doc "Capability that can be required to validate whether an address has the agent role"
    @managed)

  (defun transfer-ownership:bool (new-owner-guard:guard)
    @doc "transfer ownership")

  (defun add-agent:bool (agent:string guard:guard)
    @doc "Add a new agent.")

  (defun remove-agent:bool (agent:string)
    @doc "Remove an agent.")

  (defun is-agent:bool (agent:string)
    @doc "Check if an address is an agent.")

  (defun only-agent:bool (role:string)
    @doc "Check if ONLY-AGENT capability is achieved"
  )

  (defun only-owner:bool (role:string)
    @doc "Check if ONLY-OWNER capability is achieved"
  )
)
