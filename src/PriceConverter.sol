// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    uint256 constant WEI_DENOMINATOR = 1e18;

    // Returns the version of the price feed
    function getPriceFeedVersion(
        AggregatorV3Interface priceFeed
    ) public view returns (uint256) {
        return priceFeed.version();
    }

    // Returns ETH price in denomimated USD i.e. multiplied by WEI_DENOMINATOR
    function getEthPriceInUsd(
        AggregatorV3Interface priceFeed
    ) public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return
            (uint256(answer) * WEI_DENOMINATOR) /
            uint256(10 ** priceFeed.decimals());
    }

    // Returns denomiated USD i.e. multiplied by WEI_DENOMINATOR for amount in Wei
    function getUsdFromWei(
        uint256 amountInWei,
        AggregatorV3Interface priceFeed
    ) public view returns (uint256) {
        uint256 price = getEthPriceInUsd(priceFeed);
        uint256 amountInUsd = (price * amountInWei) / WEI_DENOMINATOR;
        return amountInUsd;
    }
}
