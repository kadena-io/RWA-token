
## Running Devnet and Deploying RWA Interfaces and MVP Contracts

### Prerequisites

Ensure that both `npm` and `docker` are installed on your machine:

- **npm**: [Install npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- **docker**: [Install Docker](https://docs.docker.com/get-docker/)

### Steps

#### 1. Start the Devnet

To initiate the Kadena dev, use the following commands:

```bash
docker volume create l1
docker run --rm -it -p 8080:8080 -e MINING_BATCH_PERIOD=0.5 -e MINING_CONFIRMATION_PERIOD=0.5 -v l1:/data kadena/devnet:latest
```

#### 2. Clone the RWA-token Project

Clone the RWA-token repository to set up the project locally:

```bash
git clone https://github.com/kadena-io/RWA-token.git
```

#### 3. Install Dependencies and Deploy Contracts

Navigate to the deployment directory and install the necessary dependencies:

```bash
cd RWA-token/deploy-mvp
pnpm i
```

#### 4. Run MVP Scripts

```bash
cd ../mvp/scripts
```

For detailed instructions on running the MVP scripts, refer to the [documentation](../mvp/scripts/README.md).
