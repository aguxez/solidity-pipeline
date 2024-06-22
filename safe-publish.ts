import SafeProtocol from "@safe-global/api-kit";
import Safe from "@safe-global/protocol-kit";
import {
  MetaTransactionData,
  OperationType,
} from "@safe-global/safe-core-sdk-types";
import Logger from "https://deno.land/x/logger@v1.1.6/logger.ts";
import { load } from "https://deno.land/std@0.224.0/dotenv/mod.ts";

const env = await load();

const SIGNER_ADDRESS = env["SIGNER_ADDRESS"];
const SIGNER_PK = env["SIGNER_PK"];
const SAFE_ADDRESS = env["SAFE_ADDRESS"];
const RPC_URL = env["RPC_URL"];
const SEPOLIA_ID = 11155111n;

const logger = new Logger();

// * For some reason, SafeApiKit and the Safe classes cannot be correctly
// * constructed from the server side. Using the `defaul` property seems to fix that, but it's a hack 🤷🏽
if (import.meta.main) {
  logger.info("Initiating tx publish");

  const apiKit = new SafeProtocol.default({ chainId: SEPOLIA_ID });
  const protocolKitOwner = await Safe.default.init({
    provider: RPC_URL,
    signer: SIGNER_PK,
    safeAddress: SAFE_ADDRESS,
  });

  logger.info("Building transaction data...");
  const safeTxData: MetaTransactionData = {
    to: SIGNER_ADDRESS,
    value: "1",
    data: "0x",
    operation: OperationType.Call,
  };

  logger.info("Creating transaction...");
  const safeTx = await protocolKitOwner.createTransaction({
    transactions: [safeTxData],
  });

  const safeTxHash = await protocolKitOwner.getTransactionHash(safeTx);
  const signature = await protocolKitOwner.signHash(safeTxHash);

  logger.info("Submitting transaction...");
  await apiKit.proposeTransaction({
    safeAddress: SAFE_ADDRESS,
    safeTransactionData: safeTx.data,
    safeTxHash,
    senderAddress: SIGNER_ADDRESS,
    senderSignature: signature.data,
  });

  logger.info("Done ✅...");
}
