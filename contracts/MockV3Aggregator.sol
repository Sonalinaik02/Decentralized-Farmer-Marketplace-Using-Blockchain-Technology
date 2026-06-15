// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract MockV3Aggregator {
    int256 private answer;
    uint8 public decimals = 8;

    constructor(int256 _initialAnswer) {
        answer = _initialAnswer;
    }

    function latestRoundData()
        public
        view
        returns (
            uint80 roundId,
            int256 _answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (0, answer, 0, block.timestamp, 0);
    }

    function updateAnswer(int256 _answer) public {
        answer = _answer;
    }
}
