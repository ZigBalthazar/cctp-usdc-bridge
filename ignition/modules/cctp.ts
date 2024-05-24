import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { config } from "./config";

const cctpModule = buildModule("symmio_usdc_cctp_module", m => {
  const symmioCCTP = m.contract("SymmioCCTP", [
    config.USDC_CONTRACT_ADDRESS,
    config.TOKEN_MESSENGER_CONTRACT_ADDRESS_INPUT,
    config.DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT,
    config.DESTINATION_DOMAIN_INPUT,
  ]);

  return { symmioCCTP };
});

export default cctpModule;
