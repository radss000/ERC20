pragma solidity ^0.8.17;

import "./Evaluator.sol";

contract WorkshopCompleter {
  Evaluator public evaluator;
  address public pointsContract;

  constructor() public {
    // Initialize the evaluator contract
    evaluator = Evaluator();
    // Initialize the points contract using the provided address
    pointsContract = 0x09f14a40Fd672B5B056FF8b5c343498452CAC4b2;
  }

  function completeWorkshop() public {
    // Call the ex10_allInOne function of the Evaluator contract
    evaluator.ex10_allInOne();
    // Credit all points to the points contract
    evaluator.creditTo(pointsContract, evaluator.getTotalPoints());
  }
}

