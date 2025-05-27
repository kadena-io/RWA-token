import {
  ChainId,
  IBuilder,
  IClient,
  addSignatures,
  createClient,
  createTransactionBuilder,
} from "@kadena/client";
import { signHash } from "@kadena/cryptography-utils";
import { readFile } from "fs/promises";
import { TextEncoder } from "util";

type ProfileConfig = {
  host: string;
  networkId: string;
  chains: ChainId[];
};
type Profiles = {
  [key: string]: ProfileConfig;
};

type SignerConfig = {
  publicKey: string;
  secretKey: string;
};

type Signers = {
  [accountName: string]: SignerConfig;
};

type BaseStep = {
  profile: keyof Profiles;
  data: Record<string, any>;
  sender: string;
  sigs: {
    signer: string;
    caps?: string[][];
  }[]
};

type ResolvedStep = BaseStep & {
  code: string;
};
type UnresolvedStep = BaseStep & {
  codeFile: string;
};
type Step = ResolvedStep | UnresolvedStep;

export type DeployConfiguration = {
  profiles: Profiles;
  signers: Signers;
  steps: Step[];
};

type ResolvedDeployConfiguration = DeployConfiguration & {
  steps: ResolvedStep[];
};

const isResolvedStep = (step: Step): step is ResolvedStep => "code" in step;
export const resolveConfiguration = async (config: DeployConfiguration) => {
  const resolvedSteps = await Promise.all(
    config.steps.map(async (step) => {
      if (isResolvedStep(step)) return step;
      const code = await readFile(step.codeFile, "utf-8");
      return { ...step, code };
    }),
  );
  return { ...config, steps: resolvedSteps };
};

export const executeStepWith =
  (client: Pick<IClient, "submit" | "pollOne">) =>
  async (
    step: ResolvedStep,
    { profiles, signers }: Pick<DeployConfiguration, "profiles" | "signers">,
  ) =>
    await Promise.all(
      profiles[step.profile].chains.map(async (chain: ChainId) => {
        // Check if `step` and `step.sigs` are defined and ensure `sigs` is an array
        const allSigners = step?.sigs ? [...step.sigs] : [];

        // Add sender if it's not already in `allSigners`
        if (step?.sender && !allSigners.some(({ signer }) => signer === step.sender)) {
          allSigners.push({
            signer: step.sender,
            caps: step.caps || [], // Default to `step.caps` if needed
          });
        }

        const txBuilder = createTransactionBuilder()
          .execution(step.code)
          .setMeta({
            chainId: chain,
            senderAccount: step.sender,
            gasLimit: 100000,
          })
          .setNetworkId(profiles[step.profile].networkId);

        // Loop through all signers, including the sender if added, and add them
        allSigners.forEach(({ signer, caps }) => {
          txBuilder.addSigner(
            signers[signer].publicKey,
            (withCap) =>
              caps?.map((cap) => {
                const [name, ...args] = cap;
                return withCap(
                  name,
                  ...args.map((resValue: any) => {
                    if (isNaN(resValue)) return resValue;
                    return Number(resValue);
                  }),
                );
              }) || [],
          );
        });

        // Build the transaction with any additional data
        const tx = Object.entries(step.data || {}).reduce(
          (tx: IBuilder<any>, [key, value]) => tx.addData(key, value),
          txBuilder
        ).createTransaction();

        // Collect signatures for all signers
        const signatures = allSigners.map(({ signer }) => {
          const { publicKey, secretKey } = signers[signer];
          return signHash(tx.hash, { publicKey, secretKey });
        });

        // Attach all signatures to the transaction
        const signedTx = addSignatures(tx, ...signatures);
        const txDescription = await client.submit(signedTx);
        return client.pollOne(txDescription);
      }),
    );

const getClient = (host: string) =>
  createClient(({ chainId, networkId }) => {
    return `${host}/chainweb/0.0/${networkId}/chain/${chainId}/pact`;
  });

export const deploy = async (
  config: ResolvedDeployConfiguration,
  showLog = true,
) => {
  const resolvedConfig = await resolveConfiguration(config);
  for (const step of resolvedConfig.steps) {
    const client = getClient(resolvedConfig.profiles[step.profile].host);
    const executeStep = executeStepWith(client);
    //if (showLog) console.log("Executing step", step.code);
    const result = await executeStep(step, resolvedConfig);
    if (showLog) console.log("Executed step", JSON.stringify(result));
  }
};

const getFile = async (path: string, pw?: string) => {
  const content = JSON.parse(await readFile(path, "utf8"));
  if (!pw) return content;
  return JSON.parse(await decryptContent(content, await getKey(pw)));
};

export const deployFile = async (
  configFilePath: string,
  signersFilePath: string,
  pw?: string,
) => {
  const config = await getFile(configFilePath);
  const signers = await getFile(signersFilePath, pw);
  await deploy({ ...config, signers });
};

export type EncryptedContent = { content: string; iv: string };
export const encryptContent = async (
  content: string,
  key: CryptoKey,
): Promise<EncryptedContent> => {
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const encryptedContent = await crypto.subtle.encrypt(
    {
      name: "AES-GCM",
      iv,
    },
    key,
    new TextEncoder().encode(content),
  );
  return {
    content: Buffer.from(encryptedContent).toString("base64"),
    iv: Buffer.from(iv).toString("base64"),
  };
};

export const decryptContent = async (
  { content, iv }: EncryptedContent,
  key: CryptoKey,
): Promise<string> => {
  const decryptedContent = await crypto.subtle.decrypt(
    { name: "AES-GCM", iv: Buffer.from(iv, "base64") },
    key,
    Buffer.from(content, "base64"),
  );
  return new TextDecoder().decode(decryptedContent);
};

export const getKey = async (pw: string) => {
  const key = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(pw),
  );
  return crypto.subtle.importKey(
    "raw",
    key,
    {
      name: "AES-GCM",
      length: 256,
    },
    true,
    ["encrypt", "decrypt"],
  );
};
