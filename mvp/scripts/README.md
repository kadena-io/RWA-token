
## Running MVP Scripts

### Prerequisites

#### 1. Install `kadena-cli`
To begin, install the `kadena-cli` globally using npm:

```bash
npm install -g @kadena/kadena-cli
```

> **Note**: Wallet configuration is saved in this directory, and the designated wallet address for this setup is `mvp-wallet`. The wallet password is `mvp-wallet`.

---

### Steps to Run Scripts (Example: `mvp-scripts/2.0.0.init.yaml`)

#### 1. Create Transaction from Template and Data
Use the following command to create a transaction based on a specified template and data file:

```bash
kadena tx add -t mvp-scripts/2.0.0.init.yaml -d data.yaml -o 2.0.0.tx.json
```

#### 2. Sign the Transaction
To sign the created transaction, use:

```bash
kadena tx sign -s wallet -w mvp-wallet -u 2.0.0.tx.json
```

When prompted, select the `Sign with wallet` option.

#### 3. Test the Transaction
Before sending, it’s recommended to test the transaction with:

```bash
kadena tx test tx.json
```

#### 4. Send the Transaction
Once tested, send the transaction using:

```bash
kadena tx send tx.json
```

---
