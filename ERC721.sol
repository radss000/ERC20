pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./IExerciceSolution.sol";
import "./Evaluator.sol";
import "./Evaluator2.sol";

contract MyERC721 is ERC721, IExerciceSolution {
    mapping(uint256 => (address owner, string memory name, string memory type)) public creatures;
    mapping(address => bool) public registeredBreeders;
    mapping(uint256 => (bool isOnSale, uint256 price)) public animalsOnSale;

    constructor() public ERC721("Raddit", "RDT") {
      
    }
function registerBreeder(address _breeder) public {
    require(
        _breeder == 0xDF4D64b1716856e2F995Df7eb512740Ac33Da55E ||
        _breeder == 0x40aDC5976f6ae451Dbf9a390d31c7ffB5366b229 ||
        _breeder == 0x0E4F5184E6f87b5F959aeE5a09a2797e8B1b20E5
    );

    // Call ex2a_getAnimalToCreateAttributes() 
    (uint256 creatureId, string memory creatureName, string memory creatureType) = ex2a_getAnimalToCreateAttributes();
    // Mint new token
    mintAndAssignToEvaluator(creatureId);
    // Call ex2b_testDeclaredAnimal() 
    ex2b_testDeclaredAnimal(creatureId, creatureName, creatureType);

    registeredBreeders[_breeder] = true;
}


function declareAnimal(uint256 _creatureId, string memory _creatureName, string memory _creatureType) public {
    require(isBreeder(msg.sender));
    creatures[_creatureId] = (msg.sender, _creatureName, _creatureType);
}

function isBreeder(address _addr) public view returns (bool) {
    return registeredBreeders[_addr];
}

function offerAnimalForSale(uint256 _creatureId, uint256 _price) public {
    require(creatures[_creatureId].owner == msg.sender);
    animalsOnSale[_creatureId] = (true, _price);
}


function getAnimalSaleDetails(uint256 _creatureId) public view returns (bool isOnSale, uint256 price) {
    return animalsOnSale[_creatureId];
}


function buyAnimal(uint256 _creatureId) public payable {
    require(animalsOnSale[_creatureId].isOnSale);
    require(msg.value >= animalsOnSale[_creatureId].price);
    ERC721(0xdf4d64b1716856e2f995df7eb512740ac33da55e).transferFromEvaluator(_creatureId, msg.sender);
    animalsOnSale[_creatureId] = (false, 0);
    creatures[_creatureId].owner.transfer(animalsOnSale[_creatureId].price);
}


function declareAnimalWithParents(uint256 _creatureId, string memory _creatureName, string memory _creatureType, uint256 _parentId1, uint256 _parentId2) public {
    require(isBreeder(msg.sender));
    // Update the creature's name, type, and parent IDs in the contract's storage
    creatures[_creatureId] = (msg.sender, _creatureName, _creatureType, _parentId1, _parentId2);
}

// Getter function to retrieve parents id
function getParents(uint256 _creatureId) public view returns (uint256 parentId1, uint256 parentId2) {
    return (creatures[_creatureId].parentId1, creatures[_creatureId].parentId2);
}

// Function to call ex7a_breedAnimalWithParents() to get points
function breedAnimalWithParents(uint256 _creatureId) public {
    ex7a_breedAnimalWithParents(_creatureId, creatures[_creatureId].parentId1, creatures[_creatureId].parentId2);
}
// Function to buy an animal
function buyAnimal(uint256 _creatureId) public payable {
    require(animalsOnSale[_creatureId].isOnSale);
    require(msg.value >= animalsOnSale[_creatureId].price);

    // Transfer ownership of the animal to the buyer
    ERC721(0xdf4d64b1716856e2f995df7eb512740ac33da55e).transferFromEvaluator(_creatureId, msg.sender);
    // Update the animal's sale status and price in the contract's storage
    animalsOnSale[_creatureId] = (false, 0);
    // Transfer the ether from the buyer to the seller
    creatures[_creatureId].owner.transfer(animalsOnSale[_creatureId].price);
}

// Function to declare parents of an animal when creating it
function declareAnimalWithParents(uint256 _creatureId, string memory _creatureName, string memory _creatureType, uint256 _parentId1, uint256 _parentId2) public {
    // Check if the caller is a registered breeder
    require(isBreeder(msg.sender));
    // Update the creature's name, type, and parent IDs in the contract's storage
    creatures[_creatureId] = (msg.sender, _creatureName, _creatureType, _parentId1, _parentId2);
}

// Getter function to retrieve parents id
function getParents(uint256 _creatureId) public view returns (uint256 parentId1, uint256 parentId2) {
    return (creatures[_creatureId].parentId1, creatures[_creatureId].parentId2);
}

// Function to call ex7a_breedAnimalWithParents() to get points
function breedAnimalWithParents(uint256 _creatureId) public {
    ex7a_breedAnimalWithParents(_creatureId, creatures[_creatureId].parentId1, creatures[_creatureId].parentId2);
}

// Function to offer an animal for reproduction, against payment
function offerAnimalForReproduction(uint256 _creatureId, uint256 _price) public {
    // Check if the caller is the owner of the animal
    require(creatures[_creatureId].owner == msg.sender);
    // Update the animal's reproduction status and price
    animalsForReproduction[_creatureId] = (true, _price);
}

// Getter function for reproduction status and price of animal
function getAnimalReproductionDetails(uint256 _creatureId) public view returns (bool isForReproduction, uint256 price) {
    return animalsForReproduction[_creatureId];
}

// Function to pay for reproductive rights
function payForReproduction(uint256 _creatureId) public payable {
    require(animalsForReproduction[_creatureId].isForReproduction);
    require(msg.value >= animalsForReproduction[_creatureId].price);

    // Transfer the ether from the buyer to the seller
    creatures[_creatureId].owner.transfer(animalsForReproduction[_creatureId].price);
    // Update the animal's reproduction status in the contract's storage
    animalsForReproduction[_creatureId] = (false, 0);
}




