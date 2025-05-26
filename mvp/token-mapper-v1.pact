(namespace (read-msg 'ns))

(module token-mapper-v1 GOV
  "`token-mapper` maps token IDs to their corresponding RWA.real-world-asset-v1 modules.   \
   \ This module provides functionality to register and retrieve token contract references."

  (defconst GOV-KEYSET:string "RWA.rwa-admin-keyset")

  (defcap GOV () (enforce-keyset GOV-KEYSET))

  (defschema token-info
    @doc "Schema for token module reference storage."
    token:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1}
  )

  (deftable tokens:{token-info})

  (defun add-token-ref:string (token-id:string token:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1})
    @doc "Registers a new token reference in the `tokens` table.  Associates a unique \
    \ `token-id` with the corresponding token contract module. "
    (insert tokens token-id {"token": token})
  )

  (defun get-token:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1} (token-id:string)
    @doc "Retrieves the token contract module reference for the given `token-id`."
    (with-read tokens token-id {
      "token":= token-ref:module{RWA.real-world-asset-v1, fungible-v2, RWA.compliance-compatible-v1}
      } token-ref)
  )
)

(if (read-msg "is_upgrade")
  "Upgrade complete"
  (create-table tokens)
)

(enforce-keyset GOV-KEYSET)