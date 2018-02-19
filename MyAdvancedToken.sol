pragma solidity ^0.4.16;

import "./owned.sol";
import "./TokenERC20.sol";

contract MyAdvancedToken is owned, TokenERC20 {
  // 设置卖出价格
  uint256 public sellPrice;
  // 设置买入价格
  uint256 public buyPrice;
  // 设置交易余额阈值
  uint256 minBalanceForAccounts;

  mapping (address => bool) public fronzenAccount;

  event FrozenFunds(address target, bool frozen);

  function MyAdvancedToken(
    uint256 initalSupply,
    string tokenName,
    string tokenSymbol
  ) TokenERC20(initialSupply, tokenName, tokenSymbol) payable public {}

  function _transfer(address _from, address _to, uint _value) interal {
    require(_to != 0x0);
    require(balanceOf[_from] >= _value);
    require(_value > 0);
    // 确保交易账户双方都没有被冻结
    require(!frozenAccount[_from]);
    require(!fronzenAccount[_to]);

    // 如果用于的余额低于阈值不足以支付费用给矿工
    // 则合约自动售出一部分代币来补充余额
    if(msg.sender.balance < minBalanceForAccounts)
      sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
    // if(_to.balance < minBalanceForAccounts)
    //  _to.send(sell(minBalanceForAccounts - _to.balance) / sellPrice);

    // 进行交易计算
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    Transfer(_from, _to, _value);
  }

  // 代币增发
  function mintToken(address target, uint256 mintedAmount) onlyOwner public {
    balanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, this, mintedAmount);
    Transfer(this, target, mintedAmount);
  }

  // 冻结账户
  function freezeAccount(address target, bool freeze) onlyOwner public {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
  }

  // 设置买入价格和卖出价格
  function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
    sellPrice = newSellPrice;
    buyPrice = newBuyPrice;
  }

  // 购买
  function buy() payable public {
    uint amount = msg.value / buyPrice;
    _transfer(this, msg.sender, amount);
  }

  // 卖出
  function sell(uint256 amount) public {
    require(this.balance >= amount * sellPrice);
    _transfer(msg.sender, this, amount);
    msg.sender.transfer(amount * sellPrice);
  }

  // 设置交易阈值
  function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
    minBalanceForAccounts = minBalanceForAccounts * 1 * finney;
  }

}
