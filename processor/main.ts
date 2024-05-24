import { ethers } from "ethers";

async function getMessageHash(burnTxHash: string) {
  const provider = new ethers.providers.JsonRpcProvider("https://rpc-amoy.polygon.technology");

  const transactionReceipt = await provider.getTransactionReceipt(burnTxHash);
  const eventTopic = ethers.utils.id("MessageSent(bytes)");

  const log = transactionReceipt.logs.find(log => log.topics[0] === eventTopic);

  if (!log) {
    throw new Error("Event log not found");
  }

  const decodedData = ethers.utils.defaultAbiCoder.decode(["bytes"], log.data);
  const messageBytes = decodedData[0];
  const messageHash = ethers.utils.keccak256(messageBytes);

  return messageHash;
}

async function getAttestation(messageHash: string): Promise<string> {
  let attestation: string = "";
  for (let i = 1; i < 6; i++) {
    try {
      const data = await fetch(`https://iris-api-sandbox.circle.com/attestations/${messageHash}`);
      const response: {
        attestation: string;
        status: string;
        error: string;
      } = await data.json();

      if (response.error != null) {
        break;
      }

      if (response.status != "complete") {
        throw new Error(response.status);
      }
      attestation = response.attestation;
      break;
    } catch (error) {
      console.log(`Try again to get attestation: ${i}, status: ${error}`);
      await new Promise(r => setTimeout(r, 60000)); //60s
      continue;
    }
  }
  if (attestation == "") {
    throw new Error("failed to get attestation");
  }
  return attestation;
}

// Usage example
(async () => {
  const contractAddress = "CONTRACT_ADDRESS";
  const abi = [
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "uint64",
          name: "_nonce",
          type: "uint64",
        },
      ],
      name: "newBridge",
      type: "event",
    },
  ];

  const provider = new ethers.providers.JsonRpcProvider("https://rpc-amoy.polygon.technology");

  const contract = new ethers.Contract(contractAddress, abi, provider);

  const onNewBridge = async (nonce: ethers.BigNumber, event: ethers.Event) => {
    try {
      const messageHash = await getMessageHash(event.transactionHash);
      console.log("Message Hash:", messageHash);
      const attestations = await getAttestation(messageHash);
      console.log("Attestation:", attestations);
    } catch (error) {
      console.error("Error:", error);
    }
  };

  console.log("start listening...");

  contract.on("newBridge", (nonce: ethers.BigNumber, event: ethers.Event) => {
    console.log("event received!");
    onNewBridge(nonce, event);
  });
})();
