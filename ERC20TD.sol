
//SPDX-License-Identifier: SPDX-License
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IExerciceSolution.sol";

contract ERC20TD is ERC20, IExerciceSolution {
    // Mapping to store whether an address is a teacher or not
    mapping(address => bool) public teachers;

    // Events for denied transfers
    event DenyTransfer(address recipient, uint256 amount);
    event DenyTransferFrom(address sender, address recipient, uint256 amount);

    // Arrays and mappings for whitelisted addresses
    address[] public whitelist;
    mapping(address => bool) public firstTier;
    mapping(address => bool) public secondTier;

    constructor(string memory name, string memory symbol, uint256 initialSupply) public ERC20(name, symbol) {
        // The contract creator gets half of the tokens
        _mint(msg.sender, initialSupply / 2);
        teachers[msg.sender] = true;

        // Uncomment the following lines to add an address to the whitelist
        // whitelist.push(0x7C5629d850eCD1E640b1572bC0d4ac5210b38FA5);
        // secondTier[0x7C5629d850eCD1E640b1572bC0d4ac5210b38FA5] = true;
    }

    // Function to distribute tokens to a specific address
    function distributeTokens(address tokenReceiver, uint256 amount) public onlyTeachers {
        // Calculate the total number of tokens to mint
        uint256 decimals = decimals();
        uint256 multiplicator = 10 ** decimals;
        _mint(tokenReceiver, amount * multiplicator);
    }

    // Function to set an address as a teacher
    function setTeacher(address teacherAddress, bool isTeacher) public onlyTeachers {
        teachers[teacherAddress] = isTeacher;
    }

    // Modifier to allow only teachers to call a function
    modifier onlyTeachers() {
        require(teachers[msg.sender]);
        _;
    }

    // Override ERC20 transfer function to deny all transfers
    function transfer(address recipient, uint256 amount) public override(ERC20, IERC20) returns (bool) {
        emit DenyTransfer(recipient, amount);
        return false;
    }

    // Override ERC20 transferFrom function to deny all transfers
    function transferFrom(address sender, address recipient, uint256 amount) public override(ERC20, IERC20) returns (bool) {
        emit DenyTransferFrom(sender, recipient, amount);
        return false;
    }

    // Override ERC20 symbol function to always return "z"
    function symbol() public view override(ERC20, IExerciceSolution) returns (string memory) {
        return 'z';
    }

    // Function to get a token for a whitelisted address
    function getToken() public override(IExerciceSolution) returns (bool) {
    if (this.isCustomerWhiteListed(msg.sender)) {
        _mint(msg.sender, 2);
        return true;
    }
    return false;
}
    // Function to buy tokens for a whitelisted address
function buyToken() public payable override returns (bool) {
    if (msg.value > 0) {
        if (this.isCustomerWhiteListed(msg.sender)) {
            if (this.customerTierLevel(msg.sender) == 1) {
                _mint(msg.sender, msg.value);
                return true;
            }
            if (this.customerTierLevel(msg.sender) == 2) {
                _mint(msg.sender, 2 * msg.value);
                return true;
            }
        }
    }
    return false;
}

// Function to check if an address is in the whitelist
function isCustomerWhiteListed(address customerAddress) public override returns (bool) {
    for (uint i = 0; i < whitelist.length; i++) {
        if (whitelist[i] == customerAddress) {
            return true;
        }
    }
    return false;
}

// Function to remove an address from the whitelist
function removeFromWhitelist(address _address) public {
    // Create a temporary array to store the updated whitelist
    address[] memory temp = whitelist;
    whitelist = new address[](0); // Reset the whitelist

    for (uint i = 0; i < temp.length; i++) {
        if (temp[i] != _address) {
            whitelist.push(temp[i]);
        }
    }
}

// Function to add an address to the whitelist
function addInWhitelist(address _address) public {
    whitelist.push(_address);
}

// Function to get the tier level of a whitelisted address
function customerTierLevel(address customerAddress) public override returns (uint256) {
    if (secondTier[customerAddress]) {
        return 2;
    }
    if (firstTier[customerAddress]) {
        return 1;
    }
    return 0;
}

   // Function to set the tier level of a whitelisted address
function setCustomerTierLevel(address customerAddress, uint256 tier) public {
    firstTier[customerAddress] = false;
    secondTier[customerAddress] = false;

    if (tier == 1) {
        firstTier[customerAddress] = true;
    }
    if (tier == 2) {
        secondTier[customerAddress] = true;
    }
}
}
