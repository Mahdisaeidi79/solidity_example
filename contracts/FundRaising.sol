//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

contract FundRaising {

    mapping(address => uint) public contributions;
    uint public totalContributions;
    uint public minimumContribution;
    uint public goal;
    uint public deadline;
    uint public raiseAmount = 0;
    address public admin;

   struct  Request  {
        string description;
        uint value;
        address recipient;
        bool completed;
        uint numberOfVoters;
        mapping(address=>bool) voters;
    }

    Request[] public requests;

    constructor(uint _deadline,uint _goal) {
        minimumContribution = 10000000;
        deadline = block.number  + _deadline;
        goal = _goal;
        admin = msg.sender;
    }

    modifier onlyAdmin {
        require(msg.sender == admin);
        _;
    }

    function contribute() public payable {
        require(msg.value >= minimumContribution);
        require(block.number <= deadline);
        
        if(contributions[msg.sender] == 0){
            totalContributions ++;
        }

        contributions[msg.sender] += msg.value;
        raiseAmount += msg.value;
    }   

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getRefund() public{
        require(block.number > deadline);
        require(raiseAmount < goal);
        require(contributions[msg.sender] > 0);

        payable(msg.sender).transfer(contributions[msg.sender]);
        contributions[msg.sender] = 0;
    }

    function voteForRequest(uint index) public {
        Request storage thisRequest = requests[index];
        require(contributions[msg.sender] > 0);
        require(!thisRequest.voters[msg.sender]);

        thisRequest.voters[msg.sender] = true;
        thisRequest.numberOfVoters++;
    }

    function makePayment(uint index) public onlyAdmin{
        Request storage thisRequest = requests[index];
        require(thisRequest.completed == false);
        require(thisRequest.numberOfVoters > totalContributions/2);
        payable(thisRequest.recipient).transfer(thisRequest.value);
        thisRequest.completed = true;
    }
}