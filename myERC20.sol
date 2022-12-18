//SPDX-License-Identifier: SPDX-License
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./SafeERC20.sol";
import "./Evaluator.sol";

contract ERC20TD is SafeERC20 {
  Evaluator public evaluator; 
  string public name;
  string public symbol;
  uint256 public totalSupply;

  mapping(address => bool) public teachers;
  mapping(address => bool) public customerAllowList;
  mapping(address => bool) public allowList;
  mapping(address => uint) public customerTier;

  address public owner;

  constructor(string memory name, string memory symbol, uint256 initialSupply, Evaluator _evaluator) public ERC20(name, symbol, initialSupply) {
    evaluator = _evaluator;
    // Get the ticker and supply from the evaluator
    (ticker, supply) = evaluator.ex1_getTickerAndSupply();
    name = "TokenR";
    symbol = ticker;
    totalSupply = supply;
    owner = msg.sender;
    // Configure the contract
    evaluator.submitExercise(address(this));
  }

  event DenyTransfer(address recipient, uint256 amount);
  event DenyTransferFrom(address sender, address recipient, uint256 amount);

  function distributeTokens(address tokenReceiver, uint256 amount)
  public
  onlyTeachers
  {
    uint256 decimals = decimals();
    uint256 multiplicator = 10**decimals;
    _mint(tokenReceiver, amount * multiplicator);
  }

  function setTeacher(address teacherAddress, bool isTeacher)
  public
  onlyTeachers
  {
    teachers[teacherAddress] = isTeacher;
  }

  modifier onlyTeachers() {
    require(teachers[msg.sender]);
    _;
  }

  function transfer(address recipient, uint256 amount) public override returns (bool) {
    emit DenyTransfer(recipient, amount);
    return false;
  }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    emit DenyTransferFrom(sender, recipient, amount);
    return false;
  }

  function setCustomerAllowList(address customerAddress, bool isAllowed) public {
    // Only the owner can set the customer allow list
    require(msg.sender == owner, "Only the owner can set the customer allow list");
    customerAllowList[customerAddress] = isAllowed;
  }

  function addToAllowList(address customer) public {
    // Only the owner can add customers to the allow list
    require(msg.sender == owner, "Only the owner can add customers to the allow list");
    allowList[customer] = true;
  }

  function removeFromAllowList(address customer) public {
    // Only the owner can remove customers from the allow list
    require(msg.sender == owner, "Only the owner can remove customers from the allow list");
    allowList[customer] = false;
  }

  function getToken(uint256 amount) public {
    // Check if the caller is on the allow list
  require(customerAllowList[msg.sender], "You are not on the allow list");
    // Distribute the tokens to the caller
  distributeTokens(msg.sender, amount);
  }
// Mapping of customer addresses to their tier level
mapping(address => uint) public customerTier;

// Mapping of customer tier levels to the number of tokens they can buy for a given amount of ETH
mapping(uint => uint) public tokenMultipliers;

// Function to set the customer tier for a given address
function setCustomerTier(address customer, uint tier) public {
  // Only the owner can set the customer tier
  require(msg.sender == owner, "Only the owner can set the customer tier");
  customerTier[customer] = tier;
}

// Function to set the token multiplier for a given customer tier
function setTokenMultiplier(uint tier, uint multiplier) public {
  // Only the owner can set the token multiplier
  require(msg.sender == owner, "Only the owner can set the token multiplier");
  tokenMultipliers[tier] = multiplier;
}

// Function to buy tokens
function buyTokens(uint256 amount) public payable {
  // Check if the caller is on the allow list
  require(allowList[msg.sender], "You are not on the allow list");

  // Get the customer's tier level
  uint tier = customerTier[msg.sender];

  // Get the token multiplier for the customer's tier
  uint multiplier = tokenMultipliers[tier];

  // Calculate the number of tokens to be distributed
  uint tokens = amount * multiplier;

  // Distribute the tokens to the caller
  distributeTokens(msg.sender, tokens);
}
}
