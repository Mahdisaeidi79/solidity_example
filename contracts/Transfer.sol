//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;
error

contract Transfer {
    address payable sender;
    mapping(address => uint256) balances;
    
    constructor() payable {
        balances[msg.sender] = msg.value;
        sender = payable(msg.sender);
    }
    function transferFrom(address payable _from, address payable _to, uint _value) public returns (bool success) {
        if(_from != sender){
            revert('from must be sender');
        }
        if(_to == sender){
            revert('to must not be sender');
        }
        uint balance = balances[msg.sender];
        if(_value > balance){
            revert('insufficient balance');
        }
        _to.transfer(_value);

        unchecked {
            balances[msg.sender] = balance - _value;      
            balances[_to] += _value; 
        }             
        return true;
    }
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}