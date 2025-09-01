// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721,Ownable{
    //错误
    error ERC721Metadata__URI_QueryFor_NonExistentToken();
    error MoodNft__CantFlipMoodIfNotOwner();
    //类型声明
    enum NFTState{
        HAPPY,
        SAD
    }
    //状态变量
    uint256 private s_tokenCounter;
    string private s_sadSvgUri;
    string private s_happySvgUri;
    mapping(uint256 => NFTState) private s_tokenIdToState;

    //事件
    event CreatedNFT(uint256 indexed tokenId);
    event MoodFlipped(uint256 indexed tokenId,NFTState mood);


    constructor(string memory sadSvgUri,string memory happySvgUri) ERC721("Mood NFT","MNF") Ownable(msg.sender){
        s_tokenCounter = 0;
        s_sadSvgUri = sadSvgUri;
        s_happySvgUri = happySvgUri;
    }

    function mintNFT() public {
        _safeMint(msg.sender,s_tokenCounter);
        emit CreatedNFT(s_tokenCounter);
        s_tokenCounter++;
    } 

    ///返回某个 tokenId 对应的 NFT Metadata JSON（Base64编码后的 Data URI）。 
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
         // 如果这个 tokenId 没有被 mint（owner = 0 地址），直接报错
        if (ownerOf(tokenId) == address(0)) { 
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        }
        // 默认图片是 "开心" 表情
        string memory imgUrl = s_happySvgUri;
        // 如果 token 的状态是 SAD，就换成 "难过" 表情
        if(s_tokenIdToState[tokenId] == NFTState.SAD){
            imgUrl = s_sadSvgUri;
        }
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

       //ase64 解码之后会得到：
        // {
        //   "name": "MoodNFT",
        //   "description": "An NFT that reflects the mood of the owner, 100% on Chain!",
        //   "attributes": [
        //     {
        //       "trait_type": "moodiness",
        //       "value": 100
        //     }
        //   ],
        //   "image": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0..."
        // }
        // name: NFT 名称（整个合约的名字，不是单个 token 的名字）
        // description: 描述信息
        // attributes: 属性数组（这里写死了 moodiness=100）
        // image: 一个内嵌的 SVG 图片（也是 base64 编码的，来自 s_happySvgUri 或 s_sadSvgUri）
    }
    ///base64 文件前缀，
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function flipMood(uint256 tokenId) public {
        if (msg.sender != ownerOf(tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdToState[tokenId] == NFTState.HAPPY){
            s_tokenIdToState[tokenId] = NFTState.SAD;
        }else{
            s_tokenIdToState[tokenId] = NFTState.HAPPY;
        }
        emit MoodFlipped(tokenId,s_tokenIdToState[tokenId]);
    }

    function getHappySVG() public view returns (string memory) {
        return s_happySvgUri;
    }

    function getSadSVG() public view returns (string memory) {
        return s_sadSvgUri;
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

}