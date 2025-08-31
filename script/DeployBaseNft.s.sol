
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import{Script} from "forge-std/Script.sol";
import {BaseNft} from "../src/BasicNft.sol";
contract DeployBaseNft is Script{

    function run() external returns (BaseNft){
        vm.startBroadcast();
        BaseNft nft = new BaseNft();
        vm.stopBroadcast();
        return nft;
    }
}