// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // 1. Deploy mocks when we are on a local Anvil chain
    // 2. Keep track of contract addresses across different chains
    uint constant SEPOLIA_CHAIN_ID = 11155111;
    address constant SEPOLIA_PRICE_FEED_ADDR =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;

    uint8 constant ANVIL_PRICE_FEED_INITIAL_DECIMALS = 8;
    int256 constant ANVIL_PRICE_FEED_INITIAL_PRICE = 2000e8;

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; // ETH / USD price feed address
    }

    constructor() {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: SEPOLIA_PRICE_FEED_ADDR
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            ANVIL_PRICE_FEED_INITIAL_DECIMALS,
            ANVIL_PRICE_FEED_INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
