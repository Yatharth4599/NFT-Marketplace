pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FootballTicketNFT is ERC721 {
    address public owner;
    uint256 public tokenCounter;
    string public baseTokenURI;
    mapping(uint256 => uint256) public ticketPrices;
    mapping(uint256 => bool) public ticketRedeemed;
    mapping(uint256 => string) public ticketMetadata;

    constructor(string memory _baseTokenURI) ERC721("Football Match Ticket NFT", "FMTN") {
        owner = msg.sender;
        tokenCounter = 0;
        baseTokenURI = _baseTokenURI;
    }

    function createTicket(address to, uint256 price, string memory metadata) public returns (uint256) {
        require(msg.sender == owner, "Only owner can create tickets");
        uint256 tokenId = tokenCounter;
        _mint(to, tokenId);
        ticketPrices[tokenId] = price;
        ticketMetadata[tokenId] = metadata;
        tokenCounter++;
        return tokenId;
    }

    function redeemTicket(uint256 tokenId) public {
        require(_exists(tokenId), "Ticket does not exist");
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this ticket");
        require(ticketRedeemed[tokenId] == false, "Ticket has already been redeemed");
        ticketRedeemed[tokenId] = true;
    }

    function setBaseTokenURI(string memory _baseTokenURI) public {
        require(msg.sender == owner, "Only owner can set base token URI");
        baseTokenURI = _baseTokenURI;
    }

    function burn(uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist");
        require(ownerOf(tokenId) == msg.sender, "You are not the owner of this token");
        _burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token URI query for nonexistent token");
        bytes memory uriBytes = bytes(baseTokenURI);
        if (uriBytes.length == 0) {
            return "";
        } else {
            bytes memory tokenIdBytes = bytes(Strings.toString(tokenId));
            bytes memory slashBytes = bytes("/");
            bytes memory combinedBytes = new bytes(uriBytes.length + slashBytes.length + tokenIdBytes.length);
            uint256 k = 0;
            for (uint256 i = 0; i < uriBytes.length; i++) {
                combinedBytes[k++] = uriBytes[i];
            }
            for (uint256 i = 0; i < slashBytes.length; i++) {
                combinedBytes[k++] = slashBytes[i];
            }
            for (uint256 i = 0; i < tokenIdBytes.length; i++) {
                combinedBytes[k++] = tokenIdBytes[i];
            }
            return string(combinedBytes);
        }
    }

    function generateQRCode(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "QR code query for nonexistent token");
        string memory qrData = Strings.toString(tokenId);
        return qrData;
    }
}
