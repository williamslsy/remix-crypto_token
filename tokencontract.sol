pragma solidity 0.8.12; // SPDX-License-Identifier: MIT

// THE CONTRACT ALLOWS ONLY ITS OWNER TO CREATE NEW COINS
// Anyone can send tokens to others without permission . all that is needed is an eth keypair.

contract Token {
    address public minter;
    mapping(address => uint256) public balances;
    //public is makung the variables here accessible from other contracts

    event Sent(address from, address to, uint256 amount);

    //Event is an inheritable member of a contract. An event is emitted. it stores the
    //arguments passed in transaction logs. These logs are stored on blocckchain
    //and are accesible using address of the contract till the contract is present on the blockchain.
    //events that allow the coins to react to changes in the contract
    constructor() {
        minter = msg.sender;
    }

    // to make new coins and swnd to an address
    // only owner can send coins
    function mint(address receiver, uint256 amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint256 requested, uint256 available);

    //send any amount if coins to an existing address from any caller addrress

    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        //require(balances[msg.sender > amount], Insufficient balance");

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
