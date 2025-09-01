// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import {Test,console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "lib/base64/base64.sol";
import {stdJson} from "forge-std/StdJson.sol";
contract MoodNftTest is Test{

    string constant NFT_NAME = "Mood NFT";
    string constant NFT_SYMBOL = "MNF";
    MoodNft public moodNft;
    DeployMoodNft public deployer;
    /**
     * 使用 base64 -i sad.svg  可以编译出下面的字符串  
     * 拼接前缀 data:application/json;base64
     * 
     * 
    */
   
    string public constant SAD_MOOD_IMAGE_URI ="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNNTEyIDY0QzI2NC42IDY0IDY0IDI2NC42IDY0IDUxMnMyMDAuNiA0NDggNDQ4IDQ0OCA0NDgtMjAwLjYgNDQ4LTQ0OFM3NTkuNCA2NCA1MTIgNjR6bTAgODIwYy0yMDUuNCAwLTM3Mi0xNjYuNi0zNzItMzcyczE2Ni42LTM3MiAzNzItMzcyIDM3MiAxNjYuNiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzIgMzcyeiIvPgogIDxwYXRoIGZpbGw9IiNFNkU2RTYiIGQ9Ik01MTIgMTQwYy0yMDUuNCAwLTM3MiAxNjYuNi0zNzIgMzcyczE2Ni42IDM3MiAzNzIgMzcyIDM3Mi0xNjYuNiAzNzItMzcyLTE2Ni42LTM3Mi0zNzItMzcyek0yODggNDIxYTQ4LjAxIDQ4LjAxIDAgMCAxIDk2IDAgNDguMDEgNDguMDEgMCAwIDEtOTYgMHptMzc2IDI3MmgtNDguMWMtNC4yIDAtNy44LTMuMi04LjEtNy40QzYwNCA2MzYuMSA1NjIuNSA1OTcgNTEyIDU5N3MtOTIuMSAzOS4xLTk1LjggODguNmMtLjMgNC4yLTMuOSA3LjQtOC4xIDcuNEgzNjBhOCA4IDAgMCAxLTgtOC40YzQuNC04NC4zIDc0LjUtMTUxLjYgMTYwLTE1MS42czE1NS42IDY3LjMgMTYwIDE1MS42YTggOCAwIDAgMS04IDguNHptMjQtMjI0YTQ4LjAxIDQ4LjAxIDAgMCAxIDAtOTYgNDguMDEgNDguMDEgMCAwIDEgMCA5NnoiLz4KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPgo8L3N2Zz4=";
    string public constant HAPPY_MOOD_IMAGE_URI ="data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNzAiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
    address public constant USER = address(1);
    function setUp() public{
        deployer = new DeployMoodNft();
        moodNft = deployer.run();
    }
    //名字是否正确
    function testNameAndSymbolAreCorrect() public view{
        string memory actualName = moodNft.name();
        string memory actualSymbol = moodNft.symbol();
        assert(keccak256(abi.encodePacked(NFT_NAME)) == keccak256(abi.encodePacked(actualName)));
        assert(keccak256(abi.encodePacked(NFT_SYMBOL)) == keccak256(abi.encodePacked(actualSymbol)));
    }

     //是否可以铸造
    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        moodNft.mintNFT();
        //用户余额是否为1
        assert(moodNft.balanceOf(USER) == 1);
    }
    //
    function testCanMintAndGetTokenURI() public{
        vm.prank(USER);  
        moodNft.mintNFT();
        string memory tokenUri = moodNft.tokenURI(0);
        console.log("tokenUri=>",tokenUri);

        bytes memory tokenBytes = bytes(tokenUri);
        uint prefixLen = bytes("data:application/json;base64,").length;
        bytes memory base64Part = new bytes(tokenBytes.length - prefixLen);
        for (uint i = 0; i < base64Part.length; i++) {
            base64Part[i] = tokenBytes[i + prefixLen];
        }
       
        // Base64 解码
        bytes memory decoded = Base64.decode(string(base64Part));
        string memory json = string(decoded);
        console.log("decoded JSON=>", json);

        // 解析 JSON 字段
        string memory nameField = vm.parseJsonString(json,".name");
        string memory descriptionField = vm.parseJsonString(json,".description");
        string memory imageField = vm.parseJsonString(json,".image");

        console.log("nameField =>", nameField);
        console.log("descriptionField=>", descriptionField);
        console.log("imageField=>", imageField);
        // 断言各字段
        assertEq(nameField, "Mood NFT");
        assertEq(descriptionField, "An NFT that reflects the mood of the owner, 100% on Chain!");
        assertEq(imageField, HAPPY_MOOD_IMAGE_URI);

       

    }
    function testCanFlipMood() public{
        vm.prank(USER);  
        moodNft.mintNFT();
        string memory tokenUri = moodNft.tokenURI(0);
        console.log(tokenUri);
        assert(keccak256(abi.encodePacked(tokenUri)) == keccak256(abi.encodePacked(getMetaData(HAPPY_MOOD_IMAGE_URI))));
        vm.prank(USER);
        moodNft.flipMood(0);
        string memory tokenUri2 = moodNft.tokenURI(0);
        console.log(tokenUri2);
        assert(keccak256(abi.encodePacked(tokenUri2)) == keccak256(abi.encodePacked(getMetaData(SAD_MOOD_IMAGE_URI))));
    }

    function testCantFlipMoodIfNotOwner() public{
        //模拟下一笔交易是由 USER 发送的。
        vm.prank(USER);  
        moodNft.mintNFT();
        vm.expectRevert(MoodNft.MoodNft__CantFlipMoodIfNotOwner.selector);
        //调用者不是 NFT 的拥有者（因为 USER 铸造了，但 flipMood 不是由 USER 调用，而是由默认测试合约调用者——address(this) 调用的）。
        moodNft.flipMood(0);        
    }
    
    ///获取 metadata~~~~~
    function getMetaData(string memory imgUrl) internal pure returns(string memory){
        return string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                            abi.encodePacked(
                                '{"name":"',
                                name(), // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imgUrl,
                                '"}'
                            )
                        )
                    )
                )
        );
    }

    function _baseURI() internal pure returns (string memory) {
        return "data:application/json;base64,";
    }
    function name() public pure returns (string memory) {
        return "Mood NFT";
    }
}   