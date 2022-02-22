// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
// We import another help function
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract Domains is ERC721URIStorage {
  // Magic given to us by OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string public tld;
	
	// We'll be storing our NFT images on chain as SVGs
  string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none" viewBox="0 0 270 270"><path fill="#fff" d="M0 0h270v270H0z"/><path fill="url(#a)" d="M0 0h270v270H0z"/><g clip-path="url(#b)"><path fill="url(#c)" d="m32.354 59.43 8.352 8.352.193.211c.124.144.236.299.334.462C42.544 70.593 40.935 74 38.128 74a3.843 3.843 0 0 1-2.574-1.069L20.982 58.365a3.786 3.786 0 0 1-.37-.437c-1.429-1.967-.24-5.322 2.378-5.738.188-.03.38-.045.57-.043h58.28l.284.01c.19.015.378.045.564.088 2.461.593 3.672 4.178 1.727 6.12a3.843 3.843 0 0 1-2.576 1.064H32.355z"/><path fill="url(#d)" d="M96.407 44.86h-58.28a3.356 3.356 0 0 1-.566-.043c-2.229-.353-3.767-3.113-2.676-5.245.603-1.18 1.883-1.936 3.243-1.99h49.487L79.26 29.23l-.192-.211a3.197 3.197 0 0 1-.335-.462c-1.224-1.996.04-5.105 2.535-5.5.282-.055.57-.066.855-.033.19.013.379.043.564.09.65.168 1.245.501 1.727.968l14.57 14.56c.134.136.258.282.371.437 1.167 1.607.706 4.173-1.049 5.245-.408.249-.86.416-1.332.493a3.38 3.38 0 0 1-.568.043z"/></g><g clip-path="url(#e)"><path fill="#fff" d="M236.333 40.05c-1.166-.668-2.666-.668-4 0L223 45.568l-6.333 3.51-9.167 5.517c-1.167.669-2.667.669-4 0l-7.167-4.346c-1.166-.669-2-2.006-2-3.51V38.38c0-1.337.667-2.674 2-3.51l7.167-4.18c1.167-.668 2.667-.668 4 0l7.167 4.347c1.166.669 2 2.006 2 3.51v5.517L223 40.385v-5.683c0-1.338-.667-2.675-2-3.511l-13.333-7.857c-1.167-.668-2.667-.668-4 0L190 31.358c-1.333.669-2 2.006-2 3.344v15.713c0 1.337.667 2.675 2 3.51l13.5 7.857c1.167.669 2.667.669 4 0l9.167-5.35L223 52.756l9.167-5.349c1.166-.669 2.666-.669 4 0l7.166 4.18c1.167.668 2 2.005 2 3.51v8.358c0 1.337-.666 2.674-2 3.51l-7 4.18c-1.166.668-2.666.668-4 0l-7.166-4.18c-1.167-.668-2-2.006-2-3.51v-5.35l-6.334 3.678V67.3c0 1.337.667 2.674 2 3.51l13.5 7.857c1.167.668 2.667.668 4 0l13.5-7.857c1.167-.669 2-2.006 2-3.51V51.418c0-1.337-.666-2.675-2-3.51l-13.5-7.857z"/></g><defs><linearGradient id="a" x1="0" x2="270" y1="0" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#1D202B"/><stop offset=".37" stop-color="#1F3336"/><stop offset=".729" stop-color="#246150"/><stop offset="1" stop-color="#349C75"/></linearGradient><linearGradient id="c" x1="76.363" x2="26.447" y1="72.531" y2="43.712" gradientUnits="userSpaceOnUse"><stop stop-color="#67BC9B"/><stop offset=".2" stop-color="#66B89B"/><stop offset=".4" stop-color="#61AC9C"/><stop offset=".6" stop-color="#5A979E"/><stop offset=".8" stop-color="#507BA0"/><stop offset="1" stop-color="#4358A3"/></linearGradient><linearGradient id="d" x1="7287.09" x2="39978.3" y1="1844.81" y2="1844.81" gradientUnits="userSpaceOnUse"><stop stop-color="#67BC9B"/><stop offset=".2" stop-color="#66B89B"/><stop offset=".4" stop-color="#61AC9C"/><stop offset=".6" stop-color="#5A979E"/><stop offset=".8" stop-color="#507BA0"/><stop offset="1" stop-color="#4358A3"/></linearGradient><clipPath id="b"><path fill="#fff" d="M0 0h80v51H0z" transform="translate(20 23)"/></clipPath><clipPath id="e"><path fill="#fff" d="M0 0h64v56H0z" transform="translate(188 23)"/></clipPath></defs><defs><filter id="f" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><text x="26.5" y="231" font-size="26" fill="#fff" filter="url(#f)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
  string svgPartTwo = '</text></svg>';
	
  mapping(string => address) public domains;
  mapping(string => string) public records;
  mapping(uint => string) public names;

  address payable public owner;

  constructor(string memory _tld) ERC721("Web3 Name Service", "WNS") payable {
    owner = payable(msg.sender);
    tld = _tld;
    console.log("%s name service deployed", _tld);
  }

	// This function will give us the price of a domain based on length
	function price(string calldata name) public pure returns (uint256) {
		uint256 len = StringUtils.strlen(name);
		require(len > 0);
		if (len == 3) {
				return 1 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.1 Matic cause the faucets don't give a lot
		} else if (len == 4) {
				return 0.5 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.05
		} else {
				return 0.2 * 10**17;
		}
	}

  function register(string calldata name) public payable {
    if (domains[name] != address(0)) revert AlreadyRegistered();
    if (!valid(name)) revert InvalidName(name);
    
    require(domains[name] == address(0));

    uint256 _price = price(name);
    require(msg.value >= _price, "Not enough Matic paid");
		
		// Combine the name passed into the function  with the TLD
    string memory _name = string(abi.encodePacked(name, ".", tld));
		// Create the SVG (image) for the NFT with the name
    string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
    uint256 newRecordId = _tokenIds.current();
  	uint256 length = StringUtils.strlen(name);
		string memory strLen = Strings.toString(length);

    console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

		// Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            _name,
            '", "description": "A domain on the Web3 name service", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(finalSvg)),
            '","length":"',
            strLen,
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

		console.log("\n--------------------------------------------------------");
	  console.log("Final tokenURI", finalTokenUri);
	  console.log("--------------------------------------------------------\n");

    _safeMint(msg.sender, newRecordId);
    _setTokenURI(newRecordId, finalTokenUri);
    domains[name] = msg.sender;
    names[newRecordId] = name;

    _tokenIds.increment();
  }
	
	// This will give us the domain owners' address
	function getAddress(string calldata name) public view returns (address) {
    return domains[name];
	}

	function setRecord(string calldata name, string calldata record) public {
    // Check that the owner is the transaction sender
    if (msg.sender != domains[name]) revert Unauthorized();
    records[name] = record;
	}

	function getRecord(string calldata name)
			public
			view
			returns (string memory)
	{
			return records[name];
	}

  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  function isOwner() public view returns (bool) {
    return msg.sender == owner;
  }

  function withdraw() public onlyOwner {
    uint amount = address(this).balance;
    
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Failed to withdraw Matic");
  }

  function getAllNames() public view returns (string[] memory) {
    console.log("Getting all names from contract");
    string[] memory allNames = new string[](_tokenIds.current());
    for (uint i = 0; i < _tokenIds.current(); i++) {
      allNames[i] = names[i];
      console.log("Name for token %d is %s", i, allNames[i]);
    }

    return allNames;
  }

  function valid(string calldata name) public pure returns(bool) {
    return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
  }

  error Unauthorized();
  error AlreadyRegistered();
  error InvalidName(string name);
}