// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// contract FundMe {
//     uint256 constant WEI_DENOMINATOR = 1e18;

//     AggregatorV3Interface aggr;

//     address public owner;
//     mapping(address => uint256) public addressToAmountFunded;
//     address[] public funders;

//     constructor() {
//         aggr = AggregatorV3Interface(
//             0x694AA1769357215DE4FAC081bf1f309aDC325306
//         );
//         owner = msg.sender;
//     }

//     // Modifier that only allows owner to execute.
//     modifier onlyOwner() {
//         require(msg.sender == owner, "You are not the owner");
//         _;
//     }

//     // Fund this contract with value from message.
//     // The funding has to be at least $10.
//     function fund() external payable {
//         uint256 minDenominatedUSD = 10 * WEI_DENOMINATOR;
//         require(
//             getUSDFromWei(msg.value) >= minDenominatedUSD,
//             "You need at least USD$10."
//         );
//         addressToAmountFunded[msg.sender] += msg.value;
//         funders.push(msg.sender);
//     }

//     function withdraw() external payable onlyOwner {
//         // Transfer money to sender
//         payable(msg.sender).transfer(address(this).balance);
//         // Clear the funders array.
//         for (uint256 i; i < funders.length; i++) {
//             address funderAddr = funders[i];
//             addressToAmountFunded[funderAddr] = 0;
//         }
//         funders = new address[](0);
//     }

//     // Returns ETH price in denomimated USD i.e. multiplied by WEI_DENOMINATOR
//     function getEthPriceInUSD() public view returns (uint256) {
//         (, int256 answer, , , ) = aggr.latestRoundData();
//         return
//             (uint256(answer) * WEI_DENOMINATOR) /
//             uint256(10 ** aggr.decimals());
//     }

//     // Returns denomiated USD i.e. multiplied by WEI_DENOMINATOR for amount in Wei
//     function getUSDFromWei(uint256 amountInWei) public view returns (uint256) {
//         uint256 price = getEthPriceInUSD();
//         uint256 amountInUSD = (price * amountInWei) / WEI_DENOMINATOR;
//         return amountInUSD;
//     }
// }
