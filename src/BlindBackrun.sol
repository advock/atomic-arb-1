pragma solidity ^0.8.19;

import "openzeppelin/token/ERC20/IERC20.sol";
import "./BlindBackrunLogic.sol";
import "./IWETH.sol";

////0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9
// This contract is only callable by the deployer/owner, relying on internally held WETH balance
contract BlindBackrun is BlindBackrunLogic {
    constructor(IWETH _wethAddress) BlindBackrunLogic(_wethAddress) {}

    function executeArbitrage(
        address firstPairAddress,
        address secondPairAddress,
        uint percentageToPayToCoinbase
    ) external onlyOwner {
        _executeArbitrage(
            firstPairAddress,
            secondPairAddress,
            percentageToPayToCoinbase
        );
    }

    /// @notice Transfers all WETH held by the contract to the contract owner.
    /// @dev Only the contract owner can call this function.
    function withdrawWETHToOwner() external onlyOwner {
        uint256 balance = WETH.balanceOf(address(this));
        WETH.transfer(msg.sender, balance);
    }

    /// @notice Transfers all ETH held by the contract to the contract owner.
    /// @dev Only the contract owner can call this function.
    function withdrawETHToOwner() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
