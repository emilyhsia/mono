// SPDX-License-Identifier: MIT

pragma solidity ^0.6.8;

import './Pool.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "@nomiclabs/buidler/console.sol";

// TODO: This should be upgradable!
contract CreditLine is Ownable {
  // Credit line terms
  address public borrower;
  uint public collateral;
  uint public limit;
  uint public interestApr;
  uint public minCollateralPercent;
  uint public paymentPeriodInDays;
  uint public termInDays;

  // Accounting variables
  uint public balance;
  uint public interestOwed;
  uint public principalOwed;
  uint public prepaymentBalance;
  uint public collateralBalance;
  uint public termEndBlock;
  uint public nextDueBlock;
  uint public lastUpdatedBlock;

  constructor(
    address _borrower,
    uint _limit,
    uint _interestApr,
    uint _minCollateralPercent,
    uint _paymentPeriodInDays,
    uint _termInDays
  ) public {
    borrower = _borrower;
    limit = _limit;
    interestApr = _interestApr;
    minCollateralPercent = _minCollateralPercent;
    paymentPeriodInDays = _paymentPeriodInDays;
    termInDays = _termInDays;
    lastUpdatedBlock = block.number;
  }

  function setTermEndBlock(uint newTermEndBlock) external onlyOwner returns (uint) {
    return termEndBlock = newTermEndBlock;
  }

  function setBalance(uint newBalance) external onlyOwner {
    balance = newBalance;
  }

  function setInterestOwed(uint newInterestOwed) external onlyOwner returns (uint) {
    return interestOwed = newInterestOwed;
  }

  function setPrincipalOwed(uint newPrincipalOwed) external onlyOwner returns (uint) {
    return principalOwed = newPrincipalOwed;
  }

  function setLastUpdatedBlock(uint newLastUpdatedBlock) external onlyOwner returns (uint) {
    return lastUpdatedBlock = newLastUpdatedBlock;
  }

  function receiveCollateral() external payable onlyOwner returns (uint) {
    return collateralBalance = collateralBalance + msg.value;
  }

  function receivePrepayment() external payable onlyOwner returns (uint) {
    return prepaymentBalance = prepaymentBalance + msg.value;
  }
}