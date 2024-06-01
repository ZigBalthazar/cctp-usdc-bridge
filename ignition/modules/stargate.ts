import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { StargateConfig } from "./config";

const StargateModule = buildModule("symmio_usde_stargate_module", m => {
  const symmioStargate = m.contract("SymmioStargate", [
    StargateConfig.STABLE_COIN_CONTRACT_ADDRESS_INPUT,
    StargateConfig.STARGATE_ROUTER_CONTRACT_ADDRESS_INPUT,
    StargateConfig.DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT,
    StargateConfig.DESTINATION_CHAINID_INPUT,
    StargateConfig.DESTINATION_POOLID_INPUT,
    StargateConfig.SOURCE_POOLID_INPUT,
  ]);

  return { symmioStargate };
});

export default StargateModule;
