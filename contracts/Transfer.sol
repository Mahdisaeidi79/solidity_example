//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

contract Transfer {
    address payable sender;
    constructor() payable {
        sender = payable(msg.sender);
    }
    function transferFrom(address payable _from, address payable _to, uint _value) public payable returns (bool success) {
        require(_from == sender);
        require(_to != sender);
        require(_value <= address(this).balance);
        _to.transfer(_value*1 ether);
        return true;
    }
}