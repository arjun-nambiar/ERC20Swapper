// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20Swapper} from "./interfaces/IERC20Swapper.sol";
import {IWETH} from "./interfaces/IWETH.sol";
import {IUniswapV2Router02} from "./interfaces/ISwapRouter.sol";

contract ERC20Swapper is IERC20Swapper {

    /////////////////////////////////
    //     Custom Errors           //
    /////////////////////////////////

    error ZeroAddress();
    error NotOwner();
    error MinAmountZero();

    /////////////////////////////////
    //     State Variables         //
    /////////////////////////////////

    address internal owner;
    address internal weth;

    address internal router;

    /////////////////////////////////
    //         Modifiers           //
    /////////////////////////////////

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    modifier nonZeroAddress(address addr) {
        if (addr == address(0)) {
            revert ZeroAddress();
        }
        _;
    }

    constructor(address routerAddres, address wethAddress) {
        if (
            wethAddress == address(0) ||
            routerAddres == address(0)
        ) {
            revert ZeroAddress();
        }
        owner = msg.sender;
        weth = wethAddress;
        router = routerAddres;
    }

    /////////////////////////////////
    //          Functions          //
    /////////////////////////////////

    function swapEtherToToken(
        address token,
        uint256 minAmount
    ) public payable returns (uint) {

        if (minAmount == 0) {
            revert MinAmountZero();
        }

        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = token;

        IUniswapV2Router02(router).swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
            minAmount, path, msg.sender, block.timestamp
        );

        uint[] memory amounts= IUniswapV2Router02(router).getAmountsOut(msg.value, path);

        return amounts[1];
    }

    function transferOwnership(
        address newOwner
    ) external onlyOwner nonZeroAddress(newOwner) {
        owner = newOwner;
    }

    function setRouterAddress(
        address newRouterAddress
    ) external onlyOwner nonZeroAddress(newRouterAddress) {
        router = newRouterAddress;
    }

    function setWethAddress(
        address newWeth
    ) external onlyOwner nonZeroAddress(newWeth) {
        weth = newWeth;
    }

    /////////////////////////////////
    //        View Functions       //
    /////////////////////////////////

    function getWethAddress() external view returns (address) {
        return address(weth);
    }


    function getOwner() external view returns (address) {
        return address(owner);
    }


    function getRouterAddress() external view returns (address) {
        return address(router);
    }
}