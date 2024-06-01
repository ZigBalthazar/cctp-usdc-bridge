// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IStargateRouter.sol";

contract SymmioStargate {
    address STABLE_COIN_CONTRACT_ADDRESS;
    address STARGATE_ROUTER_CONTRACT_ADDRESS;
    address DESTINATION_MINT_RECIPIENT_ADDRESS;
    uint16 DESTINATION_CHAINID;
    uint256 DESTINATION_POOLID;
    uint256 SOURCE_POOLID;

    IERC20 STABLE_COIN;
    IStargateRouter Stargate;

    event newBridge(uint64 _nonce);

    constructor(
        address STABLE_COIN_CONTRACT_ADDRESS_INPUT,
        address STARGATE_ROUTER_CONTRACT_ADDRESS_INPUT,
        address DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT,
        uint16 DESTINATION_CHAINID_INPUT,
        uint32 DESTINATION_POOLID_INPUT,
        uint32 SOURCE_POOLID_INPUT
    ) {
        STABLE_COIN_CONTRACT_ADDRESS = STABLE_COIN_CONTRACT_ADDRESS_INPUT;
        STARGATE_ROUTER_CONTRACT_ADDRESS = STARGATE_ROUTER_CONTRACT_ADDRESS_INPUT;
        DESTINATION_MINT_RECIPIENT_ADDRESS = DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT;

        DESTINATION_CHAINID = DESTINATION_CHAINID_INPUT;
        DESTINATION_POOLID = DESTINATION_POOLID_INPUT;
        SOURCE_POOLID = SOURCE_POOLID_INPUT;

        STABLE_COIN = IERC20(STABLE_COIN_CONTRACT_ADDRESS);
        Stargate = IStargateRouter(STARGATE_ROUTER_CONTRACT_ADDRESS);
    }

    function bridge(uint256 amount, uint256, uint256 minAmount) external payable {
        STABLE_COIN.transferFrom(msg.sender, address(this), amount);

        STABLE_COIN.approve(STARGATE_ROUTER_CONTRACT_ADDRESS, amount);
        uint256 fee = estimateFee();

        IStargateRouter.lzTxObj memory txParams = IStargateRouter.lzTxObj({ dstGasForCall: 0, dstNativeAmount: 0, dstNativeAddr: "0x" });

        Stargate.swap{ value: fee }(
            DESTINATION_CHAINID,
            SOURCE_POOLID,
            DESTINATION_POOLID,
            payable(DESTINATION_MINT_RECIPIENT_ADDRESS),
            amount,
            minAmount,
            txParams,
            abi.encode(DESTINATION_MINT_RECIPIENT_ADDRESS),
            "0x"
        );
    }

    function estimateFee() public view returns (uint256) {
        IStargateRouter.lzTxObj memory txParams = IStargateRouter.lzTxObj({ dstGasForCall: 0, dstNativeAmount: 0, dstNativeAddr: "0x" });

        (uint256 fee, ) = Stargate.quoteLayerZeroFee(
            DESTINATION_CHAINID, // _dstChainId
            1, // _functionType
            abi.encode(DESTINATION_MINT_RECIPIENT_ADDRESS), // _toAddress
            "0x", // _transferAndCallPayload
            txParams // _lzTxParams
        );

        return fee;
    }
}
