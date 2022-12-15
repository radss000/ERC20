pragma solidity ^0.8.17;
import "./Evaluator.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";



contract ERC20TD is ERC20 {
  Evaluator public evaluator; 
  string public name = "My Token";
  string public symbol;
  uint256 public totalSupply;

  constructor(string memory name, string memory symbol, uint256 initialSupply, Evaluator _evaluator)
  public ERC20(name, symbol) {
    evaluator = _evaluator;
    (ticker, supply) = evaluator.ex1_getTickerAndSupply();
    name = "TokenR";
    symbol = ticker;
    totalSupply = supply;
  }

  string public name = "Radia";
  string public symbol;
  uint256 punlic totalSupply;

  constructor(string )
mapping(address => bool) public teachers;
event DenyTransfer(address recipient, uint256 amount);
event DenyTransferFrom(address sender, address recipient, uint256 amount);

public constructor(string memory name, string memory symbol,uint256 initialSupply) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        teachers[msg.sender] = true;
    }

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

}
