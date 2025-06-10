# References

## Table of Contents

1. [Functionality](#functionality)
   - [Initialization](#initialization)
   - [Token Management](#token-management)
   - [Identity Management](#identity-management)
   - [Transfer Operations](#transfer-operations)
   - [Agent Management](#agent-management)
2. [Error codes](#error-codes)

### Functionality
---
### Initialization

#### Capabilities

- `GOV`: Governs the access control for upgrading the contract.

#### Functions

- `init`: Initializes the token with the required metadata, compliance module, and initial owner.
---
### Token Management

#### Capabilities

- `UPDATED-TOKEN-INFORMATION`: Tracks updates to token metadata.
- `INTERNAL`: Allows internal contract operations.

#### Functions

##### Setters

- `set-name`: Updates the token's name.
- `set-symbol`: Updates the token's symbol.
- `set-kadenaID`: Sets a new Kadena ID for the token.

##### Getters

- `version`: Fetches the current version of the token contract.
- `precision`: Retrieves the precision of the token.
- `symbol`: Fetches the symbol of the token. 
- `name`: Fetches the name of the token. 
- `decimals`: Fetches decimals of the token.
- `kadenaID`: Fetches Kadena ID of the token.

##### Utilities

- `enforce-unit`: Validates that the transaction amount adheres to the token's precision.
- `create-account`: Creates a new account with an initial guard and zero balance.
- `enforce-principal`: Enforces that agent and investor accounts are principal accounts.


---
### Freezing

#### Capabilities

- `ADDRESS-FROZEN`: Tracks when an address is frozen.
- `TOKENS-FROZEN`: Tracks when tokens are frozen.
- `TOKENS-UNFROZEN`: Tracks when tokens are unfrozen.
- `PAUSED`: Indicates the contract is paused.
- `UNPAUSED`: Indicates the contract is unpaused.

#### Functions 

###### State-Changing

- `set-address-frozen`: Freezes or unfreezes an address.
- `freeze-partial-tokens`: Freezes a portion of tokens for an account.
- `unfreeze-partial-tokens`: Unfreezes a portion of tokens for an account.
- `pause`: Pauses the contract.
- `unpause`: Unpauses the contract.

##### Getters

- `paused`: Checks if the contract is paused.
- `address-frozen`: Determines if a specific address is frozen.
- `get-frozen-tokens`: Fetches the number of tokens frozen for a specific account.

##### Utilities

- `enforce-unfrozen`: Ensures an account is not frozen.
- `enforce-unfrozen-amount`: Validates the amount is not part of frozen tokens.
- `set-address-frozen-internal`: Internal logic for freezing/unfreezing addresses.
- `freeze-partial-tokens-internal`: Internal logic for freezing token amounts.
- `unfreeze-partial-tokens-internal`: Internal logic for unfreezing token amounts.

##### Batch

- `batch-set-address-frozen`: Freezes or unfreezes multiple addresses.
- `batch-freeze-partial-tokens`: Freezes portions of tokens for multiple accounts.
- `batch-unfreeze-partial-tokens`: Unfreezes portions of tokens for multiple accounts.

---

### Identity Management

#### Capabilities

- `IDENTITY-REGISTERED`: Tracks identity registrations.
- `IDENTITY-REMOVED`: Tracks identity removals.
- `RECOVERY-SUCCESS`: Indicates a successful wallet recovery.
- `IDENTITY-REGISTRY-ADDED`: (not used)
- `CLAIM-TOPICS-REGISTRY-SET`: (not used)
- `TRUSTED-ISSUERS-REGISTRY-SET`: (not used)
- `IDENTITY-UPDATED`: (not used)
- `COUNTRY-UPDATED`: (not used)

#### Functions

##### State-Changing

- `register-identity`: Registers a user's identity with the contract.
- `delete-identity`: Removes a user's identity from the registry.
- `recovery-address`: Recovers tokens from a lost wallet to a new wallet.
- `set-identity-registry`: (not used)
- `set-claim-topics-registry`: (not used)
- `set-trusted-issuers-registry`: (not used)
- `update-country`: (not used)
- `update-identity`: (not used)

##### Getters

- `contains-identity`: Checks if a user address is associated with an identity.
- `investor-identity`: (not used)
- `investor-country`: (not used)
- `issuers-registry`: (not used)
- `topics-registry`: (not used)

##### Utilities

- `enforce-contains-identity`: Validates that a user address has a registered identity.
- `register-identity-internal`: Internal logic for registering an identity.
- `is-verified`: (not used)

##### Batch

- `batch-register-identity`: Registers identities for multiple users.

---

### Transfer Operations

#### Capabilities

- `TRANSFER`: Authorizes transferring of a token, including mint, burn, and forced-transfers. 
- `MINT`: Authorizes minting new tokens.
- `BURN`: Authorizes burning tokens.
- `FORCED-TRANSFER`: Authorizes forceful token transfers.
- `DEBIT`: Authorizes debiting operations.
- `CREDIT`: Authorizes crediting operations.
- `RECONCILE`: Emits an event for accounting purposes tracking account balance changes.

#### Functions 

##### State-Changing

- `forced-transfer`: Transfers tokens between accounts without consent.
- `mint`: Mints new tokens to a specified address.
- `burn`: Burns tokens from an account.
- `transfer`: Executes a standard token transfer between accounts.
- `transfer-create`: (not used)
- `transfer-crosschain`: (not used)
- `rotate`: (not used)

##### Batch

- `batch-transfer`: Executes multiple token transfers.
- `batch-forced-transfer`: Executes multiple forced transfers.
- `batch-mint`: Mints tokens to multiple accounts.
- `batch-burn`: Burns tokens from multiple accounts.

##### Getters

- `get-balance`: Returns the balance of a specific account.
- `details`: Provides detailed information about an account.

##### Utilities

- `mint-internal`: Handles internal minting logic.
- `burn-internal`: Handles internal burning logic.
- `transfer-internal`: Handles internal token transfer logic.
- `forced-transfer-internal`: Handles internal forced-transfer logic. 
- `credit`: Credits an account at transfer, forced-transfer, or mint.
- `debit`: Debits an ccount at transfer, forced-transfer or burn. 
- `TRANSFER-mgr`: Handles transfer logic management. 

---

### Agent Management

#### Capabilities

- `AGENT-ROLES-UPDATED`: Tracks updates to agent roles.
- `ONLY-AGENT`: Ensures functionality for agents only.
- `OWNERSHIP-TRANSFERRED`: Tracks ownership transfers.
- `AGENT-ADDED`: Tracks when an agent is added.
- `AGENT-REMOVED`: Tracks when an agent is removed.
- `ONLY-OWNER`: (not used)

#### Functions 

##### State-Changing

- `add-agent`: Adds a new agent to the contract.
- `remove-agent`: Removes an agent from the contract.
- `transfer-ownership`: Transfers ownership of the contract.
- `update-agent-roles`: Updates roles for an agent.

##### Getters

- `get-owner-guard`: Retrieves the guard for the owner.
- `get-agent-roles`: Retrieves the roles assigned to an agent.

##### Utilities

- `is-agent`: Returns a boolean on if an address is an agent.
- `enforce-agent`: Enforces that an address is an agent. 
- `only-agent`: Ensures access is limited to agents.
- `only-owner-or-agent-admin`: Ensures access is limited to owners or agent administrators.
- `verify-agent-roles`: Verifies roles assigned to an agent.
- `only-owner`: (not used)

---

### Compliance Management

#### Capabilities

- `COMPLIANCE-UPDATED`: Tracks updates to compliance settings.
- `COMPLIANCE-PARAMETERS`: Authorizes compliance parameter changes.
- `UPDATE-SUPPLY`: Tracks token supply changes.
- `SUPPLY`: Tracks token supply changes.

#### Functions

##### State-Changing

- `set-max-balance-per-investor`: Sets the maximum balance for investors.
- `set-supply-limit`: Sets the supply limit.
- `set-max-investors`: Sets the maximum number of investors.
- `set-compliance`: Updates the compliance module.
- `set-compliance-parameters`: Updates compliance parameters.

##### Getters

- `compliance`: Fetches the compliance modules registered for the token. 
- `get-compliance-parameters`: Retrieves compliance parameters used in the compliance modules.
- `max-balance-per-investor`: Retrieves the maximum allowable balance for investors.
- `supply-limit`: Retrieves the maximum supply limit.
- `max-investors`: Retrieves the maximum number of investors allowed.
- `investor-count`: Retrieves the current investor count.
- `supply`: Returns the current supply of tokens.

##### Utilities

- `update-supply`: Adjusts the token supply.
- `add-investor-count`: Increments the investor count.
- `remove-investor-count`: Decrements the investor count.
- `sort-compliance`: Sorts compliance list in alphabetical order
- `validate-compliance-parameters`: Validates compliance parameters at `set-compliance-parameters`
- `enforce-unique-compliance`: Validates that no duplicate compliance contracts are in the compliance list. 

## ERROR CODES
Documents error codes used in the contract to handle specific failure conditions.

**PAUSE**
- `PAU-001` : Contract is already paused.
- `PAU-002` : Contract is already unpaused.

**Identity**
- `IDR-001`: User is not registered.
- `IDR-002`: User must have a zero balance before identity removal.
- `IDR-REC-001`: User with balance of 0.0 cannot be recovered. 

**Account**
- `ACC-PRT-001`: Reserved protocol guard violation.
- `ACC-PRT-002`: Invalid sender or receiver.
- `ACC-FRZ-001`: Account is frozen. Partial freeze is not available.  
- `ACC-FRZ-002`: Account is already frozen/unfrozen. 
- `ACC-AMT-001`: Account has insufficient funds.

**Transfer**
- `TRF-ACC-001`: Same sender and receiver.
- `TRF-PAUSE-001`: Transfer is not permitted because contract is paused.
- `TRF-AMT-002`: Transfer amount must be positive.
- `TRF-MGR-001`: Managed Transfer Capability balance has exceeded.
- `TRF-CAP-001`: Transfer capability was not achieved.

**Freeze**
- `FRZ-AMT-002`: Frozen amount exceeds available balance.
- `FRZ-AMT-003`: Amount to freeze or unfreeze must be positive.
- `FRZ-AMT-004`: Amount to unfreeze must be positive.

**Roles**
- `ROL-001`: Caller must be either the owner or an agent-admin.
- `ROL-002`: Role does not exist in predefined agent roles.
- `ROL-003` : Too many roles are added.
- `ROL-STS-001`: Agent cannot be added if the agent is already active.
- `ROL-STS-002`: Agent is not active.

**General**
- `GEN-IMPL-001`: Function exists to implement interface, but is not being used.
- `GEN-IMPL-002`: Attempted to update value same as the current one.

**Compliances** 
- `CMPL-MBPI-001`: Max-investor-per-balance is invalid.
- `CMPL-MBPI-002`: Account balance exceeds max balance per investor after transfer.
- `CMPL-MBPI-003`: Account balance exceeds max balance per investor after mint. 
- `CMPL-MI-001`: Max investors is invalid.
- `CMPL-MI-002`: Investor count exceeds max investor after transfer.
- `CMPL-MI-003`: Investor count exceeds max investor after mint.
- `CMPL-MI-004`: Max investor set below current investor count.
- `CMPL-MI-005`: Investor count cannot be below 0. 
- `CMPL-SL-001`: Supply limit parameter is invalid.
- `CMPL-SL-002`: Supply exceeds supply-limit after mint.
- `CMPL-SL-003`: Supply limit set below current supply limit.
- `CMPL-DUP-001`: Compliance list contains duplicates. 

**Batch** 
- `BATCH-ARR-001`: Input arrays have mismatching lengths.

