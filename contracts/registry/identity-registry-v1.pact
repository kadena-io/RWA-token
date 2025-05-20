(namespace (read-msg 'ns))

(interface identity-registry-v1
  @doc "Identity Registry interface for managing investor identities. Supports identity registration,  \ 
  \ updates, verification, and integration with claim topics and trusted issuers registries."

  (defcap CLAIM-TOPICS-REGISTRY-SET:bool (claim-topics-registry:string)
    @doc "This event is emitted when the Claim Topics Registry has been set for the Identity Registry. \
    \ The event is emitted by the IdentityRegistry constructor.                                          \
    \ `claim-topics-registry` is the address of the Claim Topics Registry contract."
    @event)

  (defcap TRUSTED-ISSUERS-REGISTRY-SET:bool (trusted-issuers-registry:string)
    @doc "This event is emitted when the Trusted Issuers Registry has been set for the Identity Registry. \
    \ The event is emitted by the IdentityRegistry constructor.                                          \
    \ `trusted-issuers-registry` is the address of the Trusted Issuers Registry contract."
    @event)

  (defcap IDENTITY-REGISTERED:bool (investor-address:string investor-guard:guard investor-identity:string)
    @doc "This event is emitted when an Identity is registered into the Identity Registry.             \
    \ The event is emitted by the 'register-identity' function.                                        \
    \ `investor-address` is the address of the investor's wallet.                                       \
    \ `identity` is the address of the Identity smart contract (kadenaID)."
    @event)

  (defcap IDENTITY-REMOVED:bool (investor-address:string investor-identity:string)
    @doc "This event is emitted when an Identity is removed from the Identity Registry.               \
    \ The event is emitted by the 'delete-identity' function.                                          \
    \ `investor-address` is the address of the investor's wallet.                                       \
    \ `identity` is the address of the Identity smart contract (kadenaID)."
    @event)

  (defcap IDENTITY-UPDATED:bool (old-identity:string new-identity:string)
    @doc "This event is emitted when an Identity has been updated.                                      \
    \ The event is emitted by the 'update-identity' function.                                          \
    \ `old-identity` is the old Identity contract's address to update.                                  \
    \ `new-identity` is the new Identity contract's address."
    @event)

  (defcap COUNTRY-UPDATED:bool (investor-address:string country:integer)
    @doc "This event is emitted when an Identity's country has been updated.                           \
    \ The event is emitted by the 'update-country' function.                                           \
    \ `investor-address` is the address on which the country has been updated.                         \
    \ `country` is the numeric code (ISO 3166-1) of the new country."
    @event)

  (defun register-identity:bool (investor-address:string investor-guard:guard investor-identity:string country:integer)
    @doc "Register an identity contract corresponding to a investor address.                               \
    \ Requires that the investor doesn't have an identity contract already registered.                    \
    \ Only a wallet set as agent of the smart contract can call this function.                        \
    \ Emits an `IDENTITY-REGISTERED` event.")

  (defun delete-identity:bool (investor-address:string)
    @doc "Removes a investor from the identity registry.                                                    \
    \ Requires that the investor have an identity contract already deployed that will be deleted.         \
    \ Only a wallet set as agent of the smart contract can call this function.                        \
    \ Emits an `IDENTITY-REMOVED` event.")

  (defun set-claim-topics-registry:bool (claim-topics-registry:string)
    @doc "Replace the actual claimTopicsRegistry contract with a new one.                              \
    \ Only the wallet set as owner of the smart contract can call this function.                       \
    \ Emits a `CLAIM-TOPICS-REGISTRY-SET` event.")

  (defun set-trusted-issuers-registry:bool (trusted-issuers-registry:string)
    @doc "Replace the actual Trusted Issuers Registry contract with a new one.                           \
    \ Only the wallet set as owner of the smart contract can call this function.                      \
    \ Emits a `TRUSTED-ISSUERS-REGISTRY-SET` event.")

  (defun update-country:bool (investor-address:string country:integer)
    @doc "Updates the country corresponding to a investor address.                                         \
    \ Requires that the investor have an identity contract already deployed that will be replaced.        \
    \ Only a wallet set as agent of the smart contract can call this function.                        \
    \ Emits a `COUNTRY-UPDATED` event.")

  (defun update-identity:bool (investor-address:string investor-identity:string)
    @doc "Updates an identity contract corresponding to a investor address.                               \
    \ Requires that the investor address should be the owner of the identity contract.                    \
    \ Requires that the investor should have an identity contract already deployed that will be replaced.\
    \ Only a wallet set as agent of the smart contract can call this function.                        \
    \ Emits an `IDENTITY-UPDATED` event.")

  (defun batch-register-identity:[bool] (investor-addresses:[string] investor-guards:[guard] identities:[string] countries:[integer])
    @doc "Allows batch registration of identities.                                                     \
    \ Requires that none of the investors has an identity contract already registered.                   \
    \ Only a wallet set as agent of the smart contract can call this function.                       \
    \ Emits `IDENTITY-REGISTERED` events for each investor address in the batch.")

  (defun contains-identity:bool (investor-address:string)
    @doc "Checks whether a wallet has its Identity registered or not in the Identity Registry.           \
    \ Returns 'true' if the address is contained in the Identity Registry, 'false' if not.")

  (defun is-verified:bool (investor-address:string)
    @doc "Checks whether an identity contract corresponding to the provided investor address has the required \
    \ claims or not, based on the data fetched from the trusted issuers registry and the claim topics registry. \
    \ Returns 'true' if the address is verified, 'false' if not.")

  (defun investor-identity:string (investor-address:string)
    @doc "Returns the kadenaID of an investor for a given investor address.")

  (defun investor-country:integer (investor-address:string)
    @doc "Returns the country code of an investor for a given investor address.")

  (defun issuers-registry:string ()
    @doc "Returns the Trusted Issuers Registry linked to the current Identity Registry.")

  (defun topics-registry:string ()
    @doc "Returns the Claim Topics Registry linked to the current Identity Registry.")
)
