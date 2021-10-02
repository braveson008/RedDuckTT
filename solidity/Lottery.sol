//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address payable[] players;
    address  public admin;
    address latest_address;
    uint highest_deposit;
    uint public playersCount;

    constructor() {
        admin = payable(msg.sender);
        highest_deposit = 0;
    }
    
    
    modifier onlyOwner() {
        require(admin == msg.sender,"You are not the owner");
        _; 
    }
    
     receive() external payable {
        require(msg.value >= 1 ether,'Must send minimum 1 ether');
        
        require(msg.sender != admin ,'Admin can not take part in the game');
        
        incrementCount();
        players.push(payable(msg.sender));
        
        require(msg.value > highest_deposit);
        
        highest_deposit = msg.value;
        latest_address = msg.sender;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance; 
    }
    
    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(latest_address, highest_deposit, players.length)));
    }
    
    function pickWinner() public onlyOwner {
        require(players.length >= 3, 'Not enough players participating');
        
        address payable winner;
        
        
        winner = players[random() % players.length];
        
        winner.transfer(getBalance());
        
        players = new address payable[](0);
        
    }
    
    function incrementCount() internal {
        playersCount +=1;
    }
    
}