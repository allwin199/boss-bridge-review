// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/* 
* @title TokenFactory
* @dev Allows the owner to deploy new ERC20 contracts
* @dev This contract will be deployed on both an L1 & an L2
*/
contract TokenFactory is Ownable {
    mapping(string tokenSymbol => address tokenAddress) private s_tokenToAddress;

    event TokenDeployed(string symbol, address addr);

    constructor() Ownable(msg.sender) { }

    /*
     * @dev Deploys a new ERC20 contract
     * @param symbol The symbol of the new token
     * @param contractBytecode The bytecode of the new token
     */
    function deployToken(string memory symbol, bytes memory contractBytecode) public onlyOwner returns (address addr) {
        // @audit-high this won't work on zk-sync
        // https://docs.zksync.io/build/developer-reference/differences-with-ethereum.html#create-create2
        assembly {
            addr := create(0, add(contractBytecode, 0x20), mload(contractBytecode))
        }

        // create(v, p, n)
        // create new contract with code mem[p…(p+n)) and send v wei and return the new address; returns 0 on error
        // create(0, add(contractBytecode, 0x20), mload(contractBytecode))
        // v = 0
        // since it is a contract creation we are sending no wei
        // add(contractBytecode, 0x20)
        // 0x20 will be at top of the stack
        // contractBytecode will be at bottom of the stack
        // this code is saying take the `0x20`bytes of `contractBytecode` and load it into `stack`
        // mload(contractBytecode)
        // load `contractBytecode` into the memory
        // create(0, add(contractBytecode, 0x20), mload(contractBytecode))
        // will return the new address
        // returns 0 on error

        // addr :=
        // setting the returned address in `addr`

        s_tokenToAddress[symbol] = addr;
        emit TokenDeployed(symbol, addr);
    }

    function getTokenAddressFromSymbol(string memory symbol) public view returns (address addr) {
        return s_tokenToAddress[symbol];
    }
}
