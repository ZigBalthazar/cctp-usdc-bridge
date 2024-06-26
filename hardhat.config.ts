import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.24",

  networks: {
    // amoy: {
    //   url: "https://rpc-amoy.polygon.technology",
    //   accounts:["<PRIVATE_LEY>"]
    // },
    base: {
      url: "https://mainnet.base.org",
      // accounts:[""]
    },
  },
  etherscan:{
    apiKey:{
      base:""
    }
  }
};

export default config;
