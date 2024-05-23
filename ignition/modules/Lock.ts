import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const cctpModule = buildModule("symmio_usdc_cctp_module", (m) => {

  const symmioCCTP = m.contract("SymmioCCTP", []);

  return { symmioCCTP };
});

export default cctpModule;
