
// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {Test} from "forge-std/Test.sol";
import {DeployBaseNft} from "../script/DeployBaseNft.s.sol";
import {BaseNft} from "../src/BasicNft.sol";
contract BaseNftTest is Test(){
    BaseNft public nft;
    DeployBaseNft public deployer; 
    function setUp() public{
        deployer = new DeployBaseNft();
        nft = deployer.run();
    }

    function testNameIsCorrect() public view{
        string memory expectName = "Dogie";
        string memory actualName = nft.name();
        assert(keccak256(abi.encodePacked(expectName)) == keccak256(abi.encodePacked(actualName)));
    }
}