(namespace (read-msg 'ns))

(interface real-world-asset-v1
  @doc "Interface for a real-world asset-backed token with compliance, identity registry, \ 
  \ token freezes, and batch operations."

  (defcap UPDATED-TOKEN-INFORMATION:bool (new-name:string new-symbol:string new-decimals:integer new-version:string new-kadenaID:string)
    @doc "Event emitted when token information is updated."
    @event )

  (defcap IDENTITY-REGISTRY-ADDED:bool (identity-registry:module{identity-registry-v1})
    @doc "Event emitted when an identity registry is added."
    @event )

  (defcap COMPLIANCE-UPDATED:bool (compliance:[module{compliance-v1}])
    @doc "Event emitted when compliance contracts are added."
    @event )

  (defcap RECOVERY-SUCCESS:bool (lost-wallet:string new-wallet:string investor-kadenaID:string)
    @doc "Event emitted when a recovery process is successful."
    @event )

  (defcap ADDRESS-FROZEN:string (investor-address:string is-frozen:bool)
    @doc "Event emitted when an address is frozen."
    @event )

  (defcap TOKENS-FROZEN:string (investor-address:string amount:decimal)
    @doc "Event emitted when tokens are frozen."
    @event )

  (defcap TOKENS-UNFROZEN:string (investor-address:string amount:decimal)
    @doc "Event emitted when tokens are unfrozen."
    @event )

  (defcap PAUSED:string ()
    @doc "Event emitted when the contract is paused."
    @event )

  (defcap UNPAUSED:string ()
    @doc "Event emitted when the contract is unpaused."
    @event )

  (defcap SUPPLY:decimal (supply:decimal)
    @doc "Event emitted when supply is changed."
    @event
  )

  ;; Getters

  (defun kadenaID:string ()
    @doc "Return the kadena ID.")

  (defun version:string ()
    @doc "Return the version of the contract.")

  (defun identity-registry:module{identity-registry-v1} ()
    @doc "Return the associated identity registry.")

  (defun compliance:[module{compliance-v1}] ()
    @doc "Return the compliance contract.")

  (defun paused:bool ()
    @doc "Check if the contract is paused.")

  (defun address-frozen:bool (investor-address:string)
    @doc "Check if a user address is frozen.")

  (defun get-frozen-tokens:decimal (investor-address:string)
    @doc "Return the number of frozen tokens for a user.")

  ;; Setters
  (defun set-name:string (name:string)
    @doc "Set the name of the token.")

  (defun set-symbol:string (symbol:string)
    @doc "Set the symbol of the token.")

  (defun set-kadenaID:string (kadenaID:string)
    @doc "Set the kadena ID.")

  (defun pause:string ()
    @doc "Pause the contract.")

  (defun unpause:string ()
    @doc "Unpause the contract.")

  (defun set-address-frozen:string (investor-address:string freeze:bool)
    @doc "Freeze or unfreeze a user's address.")

  (defun freeze-partial-tokens:string (investor-address:string amount:decimal)
    @doc "Freeze a specific amount of a user's tokens.")

  (defun unfreeze-partial-tokens:string (investor-address:string amount:decimal)
    @doc "Unfreeze a specific amount of a user's tokens.")

  (defun set-identity-registry:string (identity-registry:module{identity-registry-v1})
    @doc "Set the identity registry contract.")

  (defun set-compliance:string (compliance:[module{compliance-v1}])
    @doc "Set the compliance contract.")

  ;; Transfer actions

  (defun forced-transfer:string (from:string to:string amount:decimal)
    @doc "Force transfer tokens from one address to another.")

  (defun mint:bool (to:string amount:decimal)
    @doc "Mint new tokens to an address.")

  (defun burn:bool (investor-address:string amount:decimal)
    @doc "Burn tokens from a user's address.")

  (defun recovery-address:bool (lost-wallet:string new-wallet:string investor-kadenaID:string)
    @doc "Recover tokens from a lost wallet to a new wallet.")

  ;; Batch functions
  (defun batch-transfer:[string] (from:string to-list:[string] amounts:[decimal])
    @doc "Perform batch transfer of tokens.")

  (defun batch-forced-transfer:[string] (from-list:[string] to-list:[string] amounts:[decimal])
    @doc "Perform batch forced transfer of tokens.")

  (defun batch-mint:[bool] (to-list:[string] amounts:[decimal])
    @doc "Mint tokens to multiple addresses.")

  (defun batch-burn:[bool] (investor-addresses:[string] amounts:[decimal])
    @doc "Burn tokens from multiple addresses.")

  (defun batch-set-address-frozen:[string] (investor-addresses:[string] freeze:[bool])
    @doc "Freeze or unfreeze multiple addresses.")

  (defun batch-freeze-partial-tokens:[string] (investor-addresses:[string] amounts:[decimal])
    @doc "Freeze a portion of tokens for multiple addresses.")

  (defun batch-unfreeze-partial-tokens:[string] (investor-addresses:[string] amounts:[decimal])
    @doc "Unfreeze a portion of tokens for multiple addresses.")

  (defun supply:decimal ()
    @doc "Return the supply of the token")
)
