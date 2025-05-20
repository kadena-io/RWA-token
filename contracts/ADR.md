# Architecture Decisions

## Identity registry
Because of how storage works in Pact it's more efficient to have a single module that implements the identity registry features as well as the storage. Therefore in implementation a single module will implement both the `identity-registry-storage-v1` and `identity-registry-v1` interfaces. Because of this the following changes have been made in comparison with the ERC3643 implementation:

#### identity-registry-storage-v1
- The events `IDENTITY-REGISTRY-BOUND` and `IDENTITY-REGISTRY-UNBOUND` have been omitted
- All functions have been omitted since they all have a counterpart in the identity-registry-v1 interface
- The interface contains 4 events that will be thrown for the sake of alignment with ERC3643

#### identity-registry-v1
- The event `IDENTITY-STORAGE-SET` has been omitted
- The functions `set-identity-registry-storage` and `identity-storage` have been omitted