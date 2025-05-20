(namespace (read-msg 'ns))

(interface compliance-compatible-v1
  "`compliance-compatible-v1` specifies the tokens that are compatible with the 3 compliances:  \
  \ supply limit, maximum investors, maximum balance per investor."

  (defschema compliance-info
    @doc "saves compliance-parameters information"
    max-balance-per-investor:decimal
    supply-limit:decimal
    max-investors:integer
    investor-count:integer
  )

  (defschema compliance-parameters-input
    supply-limit:decimal
    max-investors:integer
    max-balance-per-investor:decimal
  )

  (defun max-balance-per-investor:decimal ()
    @doc "Returns the maximum token balance that a single investor is allowed to hold."
  )

  (defun supply-limit:decimal ()
    @doc "Returns the maximum supply limit for the token."
  )

  (defun max-investors:integer ()
    @doc "Returns the maximum number of investors for the token"
  )

  (defun investor-count:integer ()
    @doc "Returns the current number of investors that holds token balance"
  )

)
