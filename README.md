# RWA-token: Real World Asset Token Implementation

This repository contains a Kadena blockchain implementation of the [EIP-3643](https://eips.ethereum.org/EIPS/eip-3643) standard in Pact. The implementation enables the tokenization of real-world assets with built-in compliance features.

## Overview

Real World Asset (RWA) tokens represent ownership of physical or non-blockchain assets on the blockchain, such as real estate, commodities, securities, or other financial instruments. This implementation provides:

- **Compliances**: Built-in mechanisms to enforce regulatory requirements
- **Identity Management**: Partially implemented - supports registration and deletion.  
- **Agent Roles**: Specialized roles for managing different aspects of the token

## Directory Structure

- **[Contracts](./contracts)**: Contains the core interfaces specified in the EIP-3643 document
  - [Real World Asset](./contracts/real-world-asset/)
  - [Identity Registry](./contracts/registry/)
  - [Compliance](./contracts/compliance/)
  - [Agent Roles](./contracts/roles/)

- **[MVP Implementation](./mvp)**: Contains the MVP implementation, detailing core functionality and logic
  - [Token implementation](./mvp/mvp-token.pact)
  - [Compliance rules implementations](./mvp/compliances/)
  - [Test scripts](./mvp/scripts/)

- **[Deployment](./deploy-mvp/devnet/)**: Contains scripts and configurations for deploying the MVP implementation on Kadena Devnet

## Documentation

Each directory has a dedicated README with further details on its contents and usage.

- [Architecture Decisions](./contracts/ADR.md): Specific design decisions
- [MVP Implementation Details](./mvp/README.md): Detailed documentation of the MVP token implementation
- [References](./mvp/references.md): Complete reference of all functions, capabilities, and error codes
- [Deployment Guide](./deploy-mvp/devnet/README.md): Instructions for deploying the contracts to Kadena Devnet
- [Script Guide](./mvp/scripts/README.md): Detailed guide for running the MVP features on Kadena Devnet