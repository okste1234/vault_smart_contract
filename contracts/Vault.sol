// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {

    struct Allocation {
        address beneficiaryAdd;
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => mapping(address => Allocation)) public beneficiary;

    mapping(address => bool) public isAllocated;

    Allocation[] public allocations;

    function createBeneficiary(address _beneficiary, uint256 _amount, uint256 _unlockTime) external {

        require(address(this).balance >= _amount, "insufficient fund to allocate");

        Allocation storage allocation = beneficiary[msg.sender][_beneficiary];


        allocation.beneficiaryAdd = _beneficiary;
        allocation.unlockTime = _unlockTime;
        allocation.amount = _amount;
        allocations.push(allocation);
        isAllocated[_beneficiary] = true;
    }

    function claim() external {
        require(isAllocated[msg.sender], "You are not a valid beneficiary");
        
        Allocation storage allocation = beneficiary[msg.sender][msg.sender]; 

        require(block.timestamp >= allocation.unlockTime, "Funds are locked until the unlock time");

        payable(msg.sender).transfer(allocation.amount);
    }

    function findBeneficiary(address _beneficiary) external view {
       beneficiary[msg.sender][_beneficiary];
    }

    function getAllBeneficiary() external view returns(Allocation[] memory)  {
        return allocations;
    }

    function checkBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    receive() external payable { }

    fallback() external payable { }
}
