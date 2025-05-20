(namespace (read-msg 'ns))

(interface compliance-v1
  (defcap TOKEN_BOUND:string (token:string)
    @doc "Event emitted when a token is bound to the compliance contract.")

  (defcap TOKEN_UNBOUND:string (token:string)
    @doc "Event emitted when a token is unbound from the compliance contract.")

  (defun bind-token:string (token:string)
    @doc "Bind a token to the compliance contract.")

  (defun unbind-token:string (token:string)
    @doc "Unbind a token from the compliance contract.")

  (defun is-token-bound:bool (token:string)
    @doc "Return true if the token is bound to the compliance contract.")

  (defun get-token-bound:string ()
    @doc "Return the token currently bound to the compliance contract.")

  (defun can-transfer:bool (token:string from:string to:string amount:decimal)
    @doc "Check if a token transfer from one address to another is compliant with the rules.")

  (defun can-mint:bool (token:string to:string amount:decimal)
    @doc "Check if a token mint to address is compliant with the rules.")

  (defun can-burn:bool (token:string from:string amount:decimal)
    @doc "Check if a token burn from address is compliant with the rules.")

  (defun transferred:bool (token:string from:string to:string amount:decimal)
    @doc "Update the contract state to record that a transfer has occurred.")

  (defun created:bool (token:string to:string amount:decimal)
    @doc "Update the contract state to record that tokens have been created (minted).")

  (defun destroyed:bool (token:string from:string amount:decimal)
    @doc "Update the contract state to record that tokens have been destroyed (burned).")
)
