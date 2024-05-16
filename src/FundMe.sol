// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;

    // Sepolia ETH / USD Address
    // https://docs.chain.link/data-feeds/price-feeds/addresses
    AggregatorV3Interface private s_priceFeed;
    address private immutable i_owner;

    constructor(address priceFeedAddr) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddr);
    }

    function fund() public payable {
        require(
            msg.value.getUsdFromWei(s_priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function getPriceConverterVersion() public view returns (uint256) {
        return PriceConverter.getPriceFeedVersion(s_priceFeed);
    }

    // Modifier that only allows owner to execute.
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        // Clear the funders array
        for (uint256 i = 0; i < s_funders.length; i++) {
            address funder = s_funders[i];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // Transfer money to sender i.e. owner
        payable(msg.sender).transfer(address(this).balance);
    }

    function cheaperWithdraw() public onlyOwner {
        // Clear the funders array
        // Read the length first to avoid loading from storage every loop
        uint256 fundersLen = s_funders.length;
        for (uint256 i = 0; i < fundersLen; i++) {
            address funder = s_funders[i];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        // Transfer money to sender i.e. owner
        payable(msg.sender).transfer(address(this).balance);
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    /**
     * View / Pure functions
     */

    function getAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
