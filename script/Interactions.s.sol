
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {BaseNft} from "../src/BasicNft.sol";
import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
contract MintBaseNft is Script{
    string public constant TOKEN_URL = "ipfs://bafybeihdwdcefgh4dqkjv67uzcmw7ojee6xedzdetojuzjevtenxquvyku/";
    function run() external {
        address recentLyDeployed = DevOpsTools.get_most_recent_deployment("BaseNft", block.chainid);
        console.log(recentLyDeployed);
        vm.startBroadcast();
        mintNft(recentLyDeployed, TOKEN_URL);
        vm.stopBroadcast();
    }
    function mintNft(address nftAddress, string memory tokenUrl) public {
        BaseNft(nftAddress).mint(tokenUrl);
    }
}