// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
contract BaseNft is ERC721{
    mapping (uint256 tokenId => string tokenURI) public s_tokenIdToUrl;
    uint256 s_tokenCounter;
    constructor() ERC721("Dogie","Dog"){
        s_tokenCounter = 0;
    }

    function mint(string memory tokenUrl) public {
        s_tokenIdToUrl[s_tokenCounter] = tokenUrl;
        _safeMint(msg.sender,s_tokenCounter);
        s_tokenCounter++;

    } 
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUrl[tokenId];
    }

}