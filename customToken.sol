// contract/customToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract customToken is ERC20, ERC20Burnable {
    address public companyacc = msg.sender;
    constructor() ERC20("DiscountToken", "DIST") {
        _mint(msg.sender, 10000 * 10 ** decimals());
        approve(msg.sender, 10000* 10**decimals());
    }
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual override  {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
    function burnFrom(address account, uint256 value) public virtual override  {
        _spendAllowance(account,account, value);
        _burn(account, value);
    }
    function selfapprove(address spender, uint256 value) public virtual  returns (bool){
        _approve(spender, spender, value);
        return true;
    }
    function approve(address spender, uint256 value) public virtual  override  returns (bool){
        address owner = companyacc;
        _approve(owner, spender, value);
        return true;
    }
    function transferFrom(address from, address to, uint256 value) public virtual override returns (bool) {
        address spender = companyacc;
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }
}





