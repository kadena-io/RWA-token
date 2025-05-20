(namespace (read-msg 'ns))

(interface trusted-issuers-registry-v1

  (defcap TRUSTED-ISSUER-ADDED:bool (trusted-issuer:string claim-topics:[integer])
    @doc "This event is emitted when a trusted issuer is added to the registry.                  \
    \ The event is emitted by the 'add-trusted-issuer' function.                                  \
    \ `trusted-issuer` is the address of the trusted issuer's ClaimIssuer contract.                \
    \ `claim-topics` is the set of claims that the trusted issuer is allowed to emit."
    @event)

  (defcap TRUSTED-ISSUER-REMOVED:bool (trusted-issuer:string)
    @doc "This event is emitted when a trusted issuer is removed from the registry.              \
    \ The event is emitted by the 'remove-trusted-issuer' function.                               \
    \ `trusted-issuer` is the address of the trusted issuer's ClaimIssuer contract."
    @event)

  (defcap CLAIM-TOPICS-UPDATED:bool (trusted-issuer:string claim-topics:[integer])
    @doc "This event is emitted when the set of claim topics is updated for a trusted issuer.    \
    \ The event is emitted by the 'update-issuer-claim-topics' function.                         \
    \ `trusted-issuer` is the address of the trusted issuer's ClaimIssuer contract.                \
    \ `claim-topics` is the set of claims that the trusted issuer is allowed to emit."
    @event)

  (defun add-trusted-issuer:bool (trusted-issuer:string claim-topics:[integer])
    @doc "Registers a ClaimIssuer contract as a trusted claim issuer.                            \
    \ Only the owner can call this function.                                                     \
    \ Emits a `TRUSTED-ISSUER-ADDED` event.")

  (defun remove-trusted-issuer:bool (trusted-issuer:string)
    @doc "Removes a trusted claim issuer from the registry.                                      \
    \ Only the owner can call this function.                                                     \
    \ Emits a `TRUSTED-ISSUER-REMOVED` event.")

  (defun update-issuer-claim-topics:bool (trusted-issuer:string claim-topics:[integer])
    @doc "Updates the set of claim topics that a trusted issuer is allowed to emit.              \
    \ Only the owner can call this function.                                                     \
    \ Emits a `CLAIM-TOPICS-UPDATED` event.")

  (defun get-trusted-issuers:[string] ()
    @doc "Returns an array of all trusted issuers registered.")

  (defun get-trusted-issuers-for-claim-topic:[string] (claim-topic:integer)
    @doc "Returns an array of trusted issuers for the given claim topic.")

  (defun is-trusted-issuer:bool (issuer:string)
    @doc "Checks if the given ClaimIssuer contract is trusted.")

  (defun get-trusted-issuer-claim-topics:[integer] (trusted-issuer:string)
    @doc "Returns the set of claim topics that the trusted issuer is allowed to emit.")

  (defun has-claim-topic:bool (issuer:string claim-topic:integer)
    @doc "Checks if the trusted issuer is allowed to emit the given claim topic.")
)