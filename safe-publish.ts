import SafeProtocol from "@safe-global/api-kit";
import Safe from "@safe-global/protocol-kit";
import {
  MetaTransactionData,
  OperationType,
} from "@safe-global/safe-core-sdk-types";
import Logger from "https://deno.land/x/logger@v1.1.6/logger.ts";

const logger = new Logger();

// * For some reason, SafeApiKit and the Safe classes cannot be correctly
// * constructed from the backend. Using the `defaul` property seems to fix that 🤷🏽
if (import.meta.main) {
  logger.info("Initiating tx publish");

  const apiKit = new SafeProtocol.default({ chainId: 11155111n });
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
