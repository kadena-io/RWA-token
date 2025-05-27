(namespace (read-msg 'ns))

(module max-balance-compliance-v1 GOV
  (implements compliance-v1)

  (defconst GOV-KEYSET:string "RWA.rwa-admin-keyset")
  (defcap GOV () (enforce-keyset GOV-KEYSET))

  (defcap TOKEN_BOUND:string (token:string)
    @doc "Event emitted when a token is bound to the compliance contract."
    (enforce false "GEN-IMPL-001")
    "GEN-IMPL-001"  
  )

  (defcap TOKEN_UNBOUND:string (token:string)
    @doc "Event emitted when a token is unbound from the compliance contract."
    (enforce false "GEN-IMPL-001")
    "GEN-IMPL-001"
  )

  (defun bind-token:string (token:string)
    @doc "Bind a token to the compliance contract."
    (enforce false "GEN-IMPL-001")
    "GEN-IMPL-001"
  )

  (defun unbind-token:string (token:string)
    @doc "Unbind a token from the compliance contract." 
    (enforce false "GEN-IMPL-001")  
    "GEN-IMPL-001"
  )

  (defun is-token-bound:bool (token:string)
    @doc "Return true if the token is bound to the compliance contract."  
    (enforce false "GEN-IMPL-001")
    false
  )

  (defun get-token-bound:string ()
    @doc "Return the token currently bound to the compliance contract." 
    (enforce false "GEN-IMPL-001")
    "GEN-IMPL-001"
  )

  (defun can-transfer:bool (token:string from:string to:string amount:decimal)
    @doc "Check if a token transfer is compliant with the rules.                             \
    \ If `max-balance-per-investor` is set to `-1.0`, the rule is considered inactive.       \
    \ Otherwise, the rule ensures that the receiver account's balance does not exceeds the   \ 
    \ specified limit after the transfer."
    (let ((t:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1} (RWA.token-mapper-v1.get-token token))
          (max-balance-per-investor (t::max-balance-per-investor)) 
          (receiver-balance (t::get-balance to))
          (receiver-new-balance:decimal (+ amount receiver-balance)) )
      (if (= max-balance-per-investor -1.0)
        true ;; rule inactive
        (enforce (>= max-balance-per-investor receiver-new-balance) "CMPL-MBPI-002")
      )
    )
  )

  (defun can-mint:bool (token:string to:string amount:decimal)
    @doc "Check if a token mint to the address is compliant with the rules.                  \
    \ If `max-balance-per-investor` is set to `-1.0`, the rule is considered inactive.       \
    \ Otherwise, the rule ensures that mint account's balance does not exceed the specified  \
    \ limit after the mint."
    (let ((t:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1} (RWA.token-mapper-v1.get-token token))
        (max-balance-per-investor (t::max-balance-per-investor)) 
        (receiver-balance (t::get-balance to))
        (receiver-new-balance:decimal (+ amount receiver-balance)) )
      (if (= max-balance-per-investor -1.0) 
        true ;; rule inactive
        (enforce (>= max-balance-per-investor receiver-new-balance) "CMPL-MBPI-002")
      )
    )
  )

  (defun can-burn:bool (token:string from:string amount:decimal)
    @doc "Check if a token burn from the address is compliant with the rules."
    true
  )

  (defun transferred:bool (token:string from:string to:string amount:decimal)
    @doc "Update the contract state to record that a transfer has occurred."
    (enforce false "GEN-IMPL-001")
    false
  )

  (defun created:bool (token:string to:string amount:decimal)
    @doc "Update the contract state to record that tokens have been created (minted)."
    (enforce false "GEN-IMPL-001")
    false
  )

  (defun destroyed:bool (token:string from:string amount:decimal)
    @doc "Update the contract state to record that tokens have been destroyed (burned)."
    (enforce false "GEN-IMPL-001")
    false
  )
)
