import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { CCTPconfig } from "./config";

const cctpModule = buildModule("symmio_usdc_cctp_module", m => {
  const symmioCCTP = m.contract("SymmioCCTP", [
    CCTPconfig.USDC_CONTRACT_ADDRESS,
    CCTPconfig.TOKEN_MESSENGER_CONTRACT_ADDRESS_INPUT,
    CCTPconfig.DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT,
    CCTPconfig.DESTINATION_DOMAIN_INPUT,
  ]);

  return { symmioCCTP };
});

export default cctpModule;
