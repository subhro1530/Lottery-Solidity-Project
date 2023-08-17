// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    //  Entities - manager, players and winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager=msg.sender;
    }

    function participate() public payable{
        require(msg.value==0.001 ether,"Please pay 1 ether only");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){//Limited only to manager
        require(manager==msg.sender,"You are not the manager");
        return address(this).balance;
    }

    function random() internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
        require(manager==msg.sender,"You are not the manager!");
        require(players.length>=3,"Less than 3 players!");

        uint r=random();
        uint index=r%players.length;
        winner=players[index];
        winner.transfer(getBalance());
        players=new address payable [](0); //This will initialize the players array back to 0.
    }
}