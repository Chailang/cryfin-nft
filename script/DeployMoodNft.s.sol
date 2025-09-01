// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;


import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployMoodNft is Script {
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    function run() external returns (MoodNft) {
        //读取svg文件
        string memory sadSvg = vm.readFile("./images/dynamicNft/sad.svg");
        string memory happySvg = vm.readFile("./images/dynamicNft/happy.svg");
        console.log(sadSvg);
        console.log(happySvg);
        //部署合约
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(svgToImageURI(sadSvg), svgToImageURI(happySvg));
        vm.stopBroadcast();
        return moodNft;
    }

    // 把 SVG 文本转换成可以直接在浏览器或 NFT 平台显示的 Base64 Data URI
    function svgToImageURI(string memory svg) public pure returns (string memory) {
        // 定义前缀 data URI，用于告诉浏览器这是一个 SVG 图片，且使用 Base64 编码
        string memory baseURI = "data:image/svg+xml;base64,";
        // 将 SVG 字符串转成 bytes 后进行 Base64 编码
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg))) // Removing unnecessary type castings, this line can be resumed as follows : 'abi.encodePacked(svg)'
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
