# **Technical README**

## **Table of Contents**
1. [Overview](#overview)  
2. [MVP Token](#mvp-token)  
   - [Governance](#governance)  
   - [Initialization](#initialization)  
   - [Token Management](#token-management)  
   - [Agent Management](#agent-management)  
   - [Identity Management](#identity-management)  
   - [Transfer Operations](#transfer-operations)  
   - [Compliances](#compliances)  
   - [References](./references.md)


## **Overview**
This project consists of a `real-world-asset-v1` implementation in Pact. The real-world-asset-v1 standard references the ERC-3643 standards and is designed to provide maximum compatibility with them.

The main interfaces in this suite, inspired by the ERC-3643 standards, include:

- [**Real World Asset**](../contracts/real-world-asset/real-world-asset-v1.pact): Provides agent-managed transactions, such as pause, freeze users, forced-transfer, mint, burn.
- [**Agent Role**](../contracts/agent-role/agent-role-v1.pact): Defines and enforces roles for agents and owners.
- [**Identity Registry**](../contracts/identity-registry/identity-registry-v1.pact): Tracks and manages investor identities. Note: the implementation only uses registering and deleting identities.
- [**Compliance**](../contracts/compliance/compliance-v1.pact): Defines compliance standards to add rules in minting, burning, and transferring.

## [**MVP Token**](./mvp-token.pact)
The MVP implementation, provides 3 compliance contracts to showcase practical usage, including [`supply-limit-compliance-v1`](./compliances/supply-limit-compliance-v1.pact), [`max-balance-compliance-v1`](./compliances/max-balance-compliance-v1.pact), and [`max-investors-compliance-v1`](./compliances/max-investors-compliance-v1.pact).
For a complete function reference including internal methods, see [references.md](./references.md).

## Governance

The contract defines two types of owners:

1. **Governance (`GOV-KEYSET`)**:  
   - The primary owner responsible for **contract upgrades** and **initialization**.
   - Governed by the `GOV` capability, which enforces `GOV-KEYSET` keyset-reference-guard.

2. **Operational Owner (`owner-guard`)**:  
   - Registered during initialization and granted access to specific **operational functions**.
   - Can be updated by calling the function, `transfer-ownership`.
   - Operational Owner is enforced by `(only-agent "owner")` function, which is described in the **Agent Role** section.

## Initialization
### `init`
Initiates the contract with owner-guard, name, symbol, kadenaID, decimals, compliances, and state of paused.

**Requirement**
- **Signer** must be the the the governance, `GOV-KEYSET`
  - **Capability** : `(GOV)`

**Inputs**  
- `name: string`
- `symbol: string`
- `decimals: integer`
- `kadenaID: string`
- `compliance: [module{RWA.compliance-v1}]`
- `paused: bool`
- `owner-guard: guard`

**State Changes**
- Registers token metadata (`name`, `symbol`, `decimals`, `kadenaID`)
- Sets pause state based on input
- Assigns owner guard for operational control
- Initializes compliance modules and default parameters

**Events Emitted**
  - `UPDATED-TOKEN-INFORMATION name symbol MINIMUM-PRECISION VERSION kadenaID`
  - `COMPLIANCE-PARAMETERS default-compliance-parameters`
  - `COMPLIANCE-UPDATED compliance`

**Error Codes**
- `CMPL-DUP-001`

## Token Management

### `pause`

Pauses transfer operations of the token until resumed.

**Requirements**

- Contract must be `unpaused`.
- **Signer** must be the agent with role `FREEZER`  
  - **Capability** `(ONLY-AGENT "freezer")`

**Inputs**
- `agent:string` (retrieved from data field)

**State Changes**
Updates the contract's internal state to mark it as paused.

**Events Emitted**
- `ONLY-AGENT "freezer"`
- `PAUSED`

**Error Codes**

- `PAU-001`
- `ROL-STS-002`
- `ROL-STS-003`

### `unpause`

Resumes transfer operations after being paused.

**Requirements**

- Contract must be `paused`.
- **Signer** must be the agent with role `FREEZER`  
  - **Capability** `(ONLY-AGENT "freezer")`

**Inputs**
- `agent:string` (retrieved from data field)

**Events Emitted**
- `ONLY-AGENT "freezer"`
- `UNPAUSED`

**Error Codes**

- `PAU-002`
- `ROL-STS-002`
- `ROL-STS-003`

### `set-address-frozen`

Freezes or unfreezes a specific address, restricting or restoring its ability to interact with the contract.

**Requirements**

- Address must be unfrozen if `freeze = true`, and frozen if `freeze = false`.
- **Signer** must be the agent with role `FREEZER`  
  - **Capability** `(ONLY-AGENT "freezer")`

**Inputs**
- `agent:string` (retrieved from data field)
- `investor-address:string`
- `freeze:bool`

**State Changes**
Updates the contract's internal state to mark the specified address as frozen (`true`) or unfrozen (`false`).

**Events Emitted**
- `ONLY-AGENT "freezer"`
- `ADDRESS-FROZEN investor-address freeze`

**Error Codes** 
- `ACC-FRZ-002`
- `ROL-STS-002`
- `ROL-STS-003`

### `freeze-partial-tokens`

Freezes a specific portion of tokens in an account, preventing their use while leaving the remainder available.

**Requirements**

- Amount must be positive and a valid unit amount. 
- Total partially frozen amount must not exceed the user's available balance.
- **Signer** must be the agent with role `FREEZER`  
  - **Capability** `(ONLY-AGENT "freezer")`

**Inputs**
- `agent:string` (retrieved from data field)
- `investor-address: string`
- `amount: decimal`

**State Changes**
Locks the specified token amount from transferring for the given address.

**Events Emitted**
- `ONLY-AGENT "freezer"`
- `TOKENS-FROZEN investor-address amount`

**Error Codes** 
- `FRZ-AMT-002`
- `FRZ-AMT-004`
- `ROL-STS-002`
- `ROL-STS-003`

### `unfreeze-partial-tokens`

Unlocks a specific portion of frozen tokens in an account.

**Requirements**

- Unfreeze amount must be a positive value, and a valid unit amount. 
- Amount must be less than or equal to the account’s frozen balance.
- **Signer** must be the agent with role `FREEZER`  
  - **Capability** `(ONLY-AGENT "freezer")`

**Inputs**
- `agent:string` (retrieved from data field)
- `investor-address: string`
- `amount: decimal`

**State Changes**
Unlocks the specified token amount from transferring for the given address.

**Events Emitted**
- `ONLY-AGENT "freezer"`
- `TOKENS-UNFROZEN investor-address amount`

**Error Codes** 
- `FRZ-AMT-003`
- `FRZ-AMT-004`
- `ROL-STS-002`
- `ROL-STS-003`

## Agent Management
Token or identity management functions in the MVP token requires certain entities to sign the transactions.
Agents can be registered by calling `add-agent`, and can be removed by calling `remove-agent`.
Agents can be granted 3 roles, `agent-admin`, `freezer`, or `transfer-manager`. 

The enforcement of the roles are done through the following functions:

1. **`only-agent`**:  
   - Called with the agent's address and role.  
   - The agent address is retrieved from the data field `agent`, rather than the parameters.  
   - Ensures that the caller signs the managed capability, `(ONLY-AGENT "required-role")`, with a registered agent guard.
   - The role, `owner` can only be added at `init` or `transfer-ownership`, and can only be assigned to one address, and is retrieved directly from the table. 

3. **`only-owner-or-agent-admin`**:  
  - Ensures that caller signs one of `agent` with role, `agent-admin`, or the `owner`.

### `add-agent`

Adds a new agent or reactivates an existing one.

**Requirements**

- Agent must not already be active.
- Agent account must be a principal account
- Agent roles must be a valid role specified in the contract. 
- **Signer** must be the agent with role `OWNER`  
  - **Capability** `(ONLY-AGENT "owner")`

**Inputs**
- `agent: string`
- `guard: string`
- `roles:[agent-role:string]` (retrieved from data field)

**State Changes**
Adds the specified agent with the roles to the registry or reactivates it if previously deactivated.

**Events Emitted**
- `ONLY-AGENT "owner"`
- `AGENT-ADDED agent guard`
- `AGENT-ROLES-UPDATED agent roles`

**Error Codes**
- `ACC-PRT-001` 
- `ROL-STS-001`
- `ROL-STS-002`
- `ROL-STS-003`

### `remove-agent`

Removes an agent from the registry.

**Requirements**

- Agent must exist in the registry.
- **Signer** must be the agent with role `OWNER`  
  - **Capability** `(ONLY-AGENT "owner")`

**Inputs**
- `agent: string`

**State Changes**
Removes the specified agent from the registry.

**Events Emitted**
- `ONLY-AGENT "owner"`
- `AGENT-REMOVED agent`
- `AGENT-ROLES-UPDATED agent roles`

**Error Codes**
- `ROL-STS-002`
- `ROL-STS-003`

## Transfer Operations

### `mint`

Creates new tokens and assigns them to a specified account, increasing the total supply.

**Requirements**

- `amount` must be positive and a valid unit amount. 
- `to` account must be unfrozen 
- `to` account must have a registered identity 
- Operation must pass `can-mint` checks defined by registered compliances.
- **Signer** must be the agent with role `TRANSFER-MANAGER`  
  - **Capability** 
    - `(ONLY-AGENT "transfer-manager")`
    - `(TRANSFER "" to amount)`

**Inputs**
- `agent:string` (retrieved from data field)
- `to: string`
- `amount: decimal`

**State Changes**
- Assigns the `amount` to the `to` account
- Increases the total token `supply`
- Increments `investor-count` if the account's previous balance was `0.0`.

**Events Emitted**
- `ONLY-AGENT "transfer-manager"`
- `TRANSFER "" to amount`
- `RECONCILE amount "" to-balance-change`
- `SUPPLY new-supply`

**Error Codes**
- `ACC-FRZ-001`
- `IDR-001`
- `ROL-STS-002`
- `ROL-STS-003`

### `burn`

Destroys tokens from a specified account, reducing the total supply.

**Requirements**
- `amount` must be positive and a valid unit amount
- `investor-address` account must be unfrozen 
- `investor-address`'s unfrozen balance must be greater than the specified `amount`.
- `investor-address` account must have a registered identity 
- `investor-address` balance must be greater than the specified `amount`.
- Operation must pass `can-burn` checks defined by registered compliances.
- **Signer** must be the agent with role `TRANSFER-MANAGER`  
  - **Capability** 
    - `(ONLY-AGENT "transfer-manager")`
    - `(TRANSFER investor-address "" amount)`

**Inputs**
- `agent:string` (retrieved from data field)
- `investor-address: string`
- `amount: decimal`

**State Changes**
- Deducts the `amount` from the `investor-address` account
- Decreases the total token `supply`
- Decrements `investor-count` if the account's balance is `0.0`.

**Events Emitted**
- `ONLY-AGENT "transfer-manager"`
- `TRANSFER investor-address "" amount`
- `RECONCILE amount investor-address-balance-change ""`
- `SUPPLY new-supply`

**Error Codes**
- `ACC-FRZ-001`
- `ACC-AMT-001`
- `ROL-STS-002`
- `ROL-STS-003`

### `transfer`
Transfers tokens from one account to another

**Requirements**

- `amount` must be positive and a valid unit amount. 
- `from`'s unfrozen balance must be greater than the specified `amount`.
- `from` account must be unfrozen 
- `to` account must be unfrozen 
- `to` account must have a registered identity 
- Operation must pass `can-transfer` checks defined by registered compliances
- Contract must be unpaused
- **Signer** must be the `from` account
  - **Capability:** 
    - `(TRANSFER from to amount)`
  
**Inputs**
- `from: string`
- `to: string`
- `amount: decimal`

**State Changes**
- Transfers the `amount` from the `from` account to `to` account.
- If the `to` account's previous balance was 0.0, increment the investor count. 
- If the `from` account's balance is 0.0 after the operation, decrement the investor count. 

**Events Emitted**

- `TRANSFER from to amount`
- `RECONCILE amount from-balance-change to-balance-change`

**Error Codes** 
- `TRF-CAP-001`
- `TRF-PAUSE-001`

### `forced-transfer`

Forcibly transfers tokens from one account to another, bypassing standard transfer restrictions.

**Requirements**
- `amount` must be positive and na valid unit amount. 
- `from`'s balance must be greater than the specified `amount`.
- `to` account must have a registered identity 
- **Signer** must be the agent with role `TRANSFER-MANAGER`  
  - **Capability** 
    - `(ONLY-AGENT "transfer-manager")`
    - `(TRANSFER investor-address from to amount)`

**Inputs**
- `agent:string` (retrieved from data field)
- `from: string`
- `to: string`
- `amount: decimal`

**State Changes**
- Transfers the `amount` from the `from` account to `to` account.
- Unfreezes tokens from the sender if free balance is not enough, but total balance covers the amount
- If the `to` account's previous balance was 0.0, increment the investor count. 
- If the `from` account's balance is 0.0 after the operation, decrement the investor count. 

**Events Emitted**

- `ONLY-AGENT "transfer-manager"`
- `TRANSFER from to amount`
- `TOKENS-UNFROZEN` (if unfreeze happens)
- `RECONCILE amount investor-address-balance-change ""`

**Error Codes**
- `TRF-PAUSE-001`
- `FRZ-AMT-004`
- `FRZ-AMT-003`
- `ROL-STS-002`
- `ROL-STS-003`

## Identity Management

### `register-identity`

Registers an identity contract corresponding to a user address, and create investor account with the provided investor information. 

**Requirements**

- Investor address must be a principal account.
- Investor identity must not already be active.
- **Signer** must be the agent with role `ADMIN` or `OWNER`  
  - **Capability** `(ONLY-AGENT "admin")`, or `(ONLY-AGENT "owner")`

**Inputs**
- `agent:string` (retrieved from data field)
- `investor-address: string`
- `investor-guard: string`
- `investor-identity: string`
- `country: integer`

**State Changes**
- Adds the provided `investor-identity` information to the registry.
- If `investor` account does not exist, then add a token account with the investor. 

**Events Emitted**
- `ONLY-AGENT "owner"` or `ONLY-AGENT "admin"`
- `IDENTITY-REGISTERED investor-address investor-guard investor-identity`

**Error Codes**
- `IDR-003`
- `ACC-PRT-001`
- `ROL-STS-002`
- `ROL-STS-003`

### `delete-identity`
Removes a user from the identity registry.

**Requirements**
- Address must exist in the registry.
- Investor account must have a `balance` of `0.0`
- **Signer** must be the agent with role `ADMIN` or `OWNER`  
  - **Capability** `(ONLY-AGENT "admin")`, or `(ONLY-AGENT "owner")`

**Inputs**
- `agent:string` (retrieved from data field)
- `investor-address: string`

**State Changes**
- Update the identity information in the registry as inactive. 

**Events Emitted**
- `ONLY-AGENT "owner"` or `ONLY-AGENT "admin"`
- `IDENTITY-REMOVED investor-address`

**Error Codes**
- `IDR-002`
- `ROL-STS-002`
- `ROL-STS-003`

### `recovery-address`
Recover tokens from a `lost-wallet` to a `new-wallet`. 

**Requirements**
- `balance` in the `lost-wallet` must be greater than `0.0`
- `new-wallet` must be registered with identity 
- **Signer** must be the agent with role `ADMIN` or `OWNER`  
  - **Capability** `(ONLY-AGENT "admin")`, or `(ONLY-AGENT "owner")`
  
**Inputs** 
- `agent:string` (retrieved from data field)
- `lost-wallet:string` 
- `new-wallet:string` 
- `investor-kadenaID:string`

**State Changes**
- `balance` of `lost-wallet` is transferred to `new-wallet` via `forced-transfer`. 
- If `lost-wallet` was frozen and `new-wallet` is unfrozen, then freeze the `new-wallet`. 
- If `lost-wallet` had `partially-frozen-tokens`, then `partially-freeze` amount in the `new-wallet`. 
- `lost-wallet`'s identity is deleted. 

**Events Emitted**
- `ONLY-OWNER admin` 
- `TRANSFER lost-wallet new-wallet balance`
- `RECONCILE balance lost-wallet-balance-change new-wallet-balance-change`
- `RECOVERY-SUCCESS lost-wallet new-wallet investor-kadenaID`
- `ADDRESS-FROZEN new-wallet true` (if `lost-wallet` was frozen and `new-wallet` is unfrozen.) 
- `IDENTITY-REMOVED investor-address kadenaID`

**Error Codes**
- `IDR-REC-001`
- `IDR-001`
- `IDR-002`
- `FRZ-AMT-002`
- `ROL-STS-002`
- `ROL-STS-003`

## Compliances

### `set-compliance`

Sets compliance contracts for the token.

**Requirements**
- The compliance contracts implement the interface `RWA.compliance-v1`
- The compliance list does not contain duplicate contracts
- The compliance list must not be the same as current compliance list
- **Signer** must be the agent with role `OWNER`  
  - **Capability** `(ONLY-AGENT "owner")`

**Inputs**
- `compliance:[module{RWA.compliance-v1}]`

**State Changes**
- Assigns the list of compliance contracts to the token.

**Events Emitted**
- `ONLY-OWNER owner` 
- `COMPLIANCE-UPDATED new-compliance`

**Error Codes**
- `ROL-STS-002`
- `ROL-STS-003`
- `GEN-IMPL-002`

### `set-compliance-parameters`

Sets the parameters - `max-balance-per-investor`, `supply-limit`, `max-investors` - for the compliance contract. When the parameters are set to -1, the compliance rule is inactive 

**Requirements**

- `max-balance-per-investor` must be `-1` or greater than `0.0`
- `supply-limit` must be `-1` or greater than current `supply`  
- `max-investors` must be `-1` or greater than current `investor-count`  
- **Signer** must be the agent with role `ADMIN` or `OWNER`  
  - **Capability** `(ONLY-AGENT "admin")`, or `(ONLY-AGENT "owner")`

**Inputs**
- `agent:string` (retrieved from data field)
- `compliance-parameters:object{compliance-parameters-input}`
 
**State Changes**
- Updates the compliance parameters with the input for the contract.

**Events Emitted**
- `ONLY-AGENT "owner"` or `ONLY-AGENT "admin"`
- `COMPLIANCE-PARAMETERS compliance-params`

**Error Codes**
- `ROL-STS-002`
- `ROL-STS-003`
- `GEN-IMPL-002`
- `CMPL-MBPI-001`
- `CMPL-SL-001`
- `CMPL-SL-003`
- `CMPL-MI-001`
- `CMPL-MI-004`