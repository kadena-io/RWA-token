(namespace (read-msg 'ns))

(interface identity-registry-storage-v1

  (defcap IDENTITY-STORED:bool (investor-address:string investor-identity:string)
    @doc "This event is emitted when an Identity is registered into the storage contract.           \
    \ The event is emitted by the 'register-identity' function.                                      \
    \ `investor-address` is the address of the investor's wallet.                                     \
    \ `investor-identity` is the address of the Identity smart contract (kadenaID)."
    @event)

  (defcap IDENTITY-UNSTORED:bool (investor-address:string investor-identity:string)
    @doc "This event is emitted when an Identity is removed from the storage contract.              \
    \ The event is emitted by the 'delete-identity' function.                                        \
    \ `investor-address` is the address of the investor's wallet.                                     \
    \ `investor-identity` is the address of the Identity smart contract (kadenaID)."
    @event)

  (defcap IDENTITY-MODIFIED:bool (old-identity:string new-identity:string)
    @doc "This event is emitted when an Identity has been updated.                                  \
    \ The event is emitted by the 'update-identity' function.                                        \
    \ `old-identity` is the old Identity contract's address to update.                                \
    \ `new-identity` is the new Identity contract's address."
    @event)

  (defcap COUNTRY-MODIFIED:bool (investor-address:string country:integer)
    @doc "This event is emitted when an Identity's country has been updated.                        \
    \ The event is emitted by the 'update-country' function.                                         \
    \ `investor-address` is the address on which the country has been updated.                        \
    \ `country` is the numeric code (ISO 3166-1) of the new country."
    @event)
)
