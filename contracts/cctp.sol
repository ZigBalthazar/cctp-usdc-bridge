// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ITokenMessenger.sol";

contract SymmioCCTP {
    address USDC_CONTRACT_ADDRESS;
    address TOKEN_MESSENGER_CONTRACT_ADDRESS;
    bytes32 DESTINATION_MINT_RECIPIENT_ADDRESS;
    uint32 DESTINATION_DOMAIN;

    IERC20 USDC;
    ITokenMessenger TokenMessenger;

    event newBridge(uint64 _nonce);

    constructor(
        address USDC_CONTRACT_ADDRESS_INPUT,
        address TOKEN_MESSENGER_CONTRACT_ADDRESS_INPUT,
        address DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT,
        uint32 DESTINATION_DOMAIN_INPUT
    ) {
        USDC_CONTRACT_ADDRESS = USDC_CONTRACT_ADDRESS_INPUT;
        TOKEN_MESSENGER_CONTRACT_ADDRESS = TOKEN_MESSENGER_CONTRACT_ADDRESS_INPUT;
        DESTINATION_MINT_RECIPIENT_ADDRESS = addressToBytes32(DESTINATION_MINT_RECIPIENT_ADDRESS_INPUT);
        DESTINATION_DOMAIN = DESTINATION_DOMAIN_INPUT;

        USDC = IERC20(USDC_CONTRACT_ADDRESS);
        TokenMessenger = ITokenMessenger(TOKEN_MESSENGER_CONTRACT_ADDRESS);
    }

    function bridge(uint256 amount) public {
        USDC.transferFrom(msg.sender, address(this), amount);

        USDC.approve(TOKEN_MESSENGER_CONTRACT_ADDRESS, amount);
        uint64 nonce = TokenMessenger.depositForBurn(amount, DESTINATION_DOMAIN, DESTINATION_MINT_RECIPIENT_ADDRESS, USDC_CONTRACT_ADDRESS);

        emit newBridge(nonce);
    }

    function addressToBytes32(address addr) public pure returns (bytes32) {
        return bytes32(uint256(uint160(addr)));
    }
}
