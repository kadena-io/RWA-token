(namespace (read-msg 'ns))

(module max-investors-compliance-v1 GOV
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
    @doc "Check if a token transfer is compliant with the rules.                            \
    \ If `max-investors` is set to `-1.0`, the rule is considered inactive. Otherwise,      \
    \ `investor-count` must remain within the limit after the transfer. Accounts with a     \
    \ `0.0` balance are not counted as investors. If `max-investors` is exceeded after the  \
    \ transfer, the transfer is only allowed if sender transfers their full balance."
    (let ((t:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1} (RWA.token-mapper-v1.get-token token))
          (max-investors:integer (t::max-investors) ) 
          (investor-count:integer (t::investor-count) ) 
          (sender-balance:decimal (t::get-balance from))
          (receiver-balance:decimal (t::get-balance to)) )
      (cond 
        ((= max-investors -1) true) ;; rule inactive
        ((and (= 0.0 receiver-balance) (< max-investors (+ 1 investor-count)))
          (enforce (= amount sender-balance) "CMPL-MI-002"))
        true
      )
    )
  )
  
  (defun can-mint:bool (token:string to:string amount:decimal)
    @doc "Check if a token transfer is compliant with the rules.                                    \
    \ If `max-investors` is set to `-1.0`, the rule is considered inactive. Accounts with a balance \
    \  of 0.0 are not counted as investors. If `investor-count` exceeds the `max investors` limit,  \ 
    \ after the mint, mint is not permitted."
    (let ((t:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1} (RWA.token-mapper-v1.get-token token))
          (max-investors:integer (t::max-investors) ) 
          (investor-count:integer (t::investor-count) ) 
          (receiver-balance:decimal (t::get-balance to)) )
      (cond 
        ((= max-investors -1) true) ;; rule inactive
        ((and (= 0.0 receiver-balance) (< max-investors (+ 1 investor-count)))
          (enforce false "CMPL-MI-003"))
        true
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
