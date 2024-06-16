// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

interface IUniswapV2Router02 {

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;

    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);

}