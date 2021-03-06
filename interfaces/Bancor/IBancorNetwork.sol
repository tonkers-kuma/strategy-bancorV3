// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IPoolCollection} from "./IPoolCollection.sol";
import {IPoolToken} from "./IPoolToken.sol";


/**
 * @dev Bancor Network interface
 */
interface IBancorNetwork {
    /**
     * @dev returns the set of all valid pool collections
     */
    function poolCollections() external view returns (IPoolCollection[] memory);

    /**
     * @dev returns the most recent collection that was added to the pool collections set for a specific type
     */
    function latestPoolCollection(uint16 poolType) external view returns (IPoolCollection);

    /**
     * @dev returns the set of all liquidity pools
     */
    function liquidityPools() external view returns (IERC20[] memory);

    /**
     * @dev returns the respective pool collection for the provided pool
     */
    function collectionByPool(IERC20 pool) external view returns (IPoolCollection);

    /**
     * @dev returns whether the pool is valid
     */
    function isPoolValid(IERC20 pool) external view returns (bool);

    /**
     * @dev deposits liquidity for the specified provider and returns the respective pool token amount
     *
     * requirements:
     *
     * - the caller must have approved the network to transfer the tokens on its behalf (except for in the
     *   native token case)
     */
    function depositFor(
        address provider,
        IERC20 pool,
        uint256 tokenAmount
    ) external payable returns (uint256);

    /**
     * @dev deposits liquidity for the current provider and returns the respective pool token amount
     *
     * requirements:
     *
     * - the caller must have approved the network to transfer the tokens on its behalf (except for in the
     *   native token case)
     */
    function deposit(IERC20 pool, uint256 tokenAmount) external payable returns (uint256);

    /**
     * @dev deposits liquidity for the specified provider by providing an EIP712 typed signature for an EIP2612 permit
     * request and returns the respective pool token amount
     *
     * requirements:
     *
     * - the caller must have provided a valid and unused EIP712 typed signature
     */
    function depositForPermitted(
        address provider,
        IERC20 pool,
        uint256 tokenAmount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256);

    /**
     * @dev deposits liquidity by providing an EIP712 typed signature for an EIP2612 permit request and returns the
     * respective pool token amount
     *
     * requirements:
     *
     * - the caller must have provided a valid and unused EIP712 typed signature
     */
    function depositPermitted(
        IERC20 pool,
        uint256 tokenAmount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256);

    /**
     * @dev initiates liquidity withdrawal
     *
     * requirements:
     *
     * - the caller must have approved the contract to transfer the pool token amount on its behalf
     */
    function initWithdrawal(IPoolToken poolToken, uint256 poolTokenAmount) external returns (uint256);

    /**
     * @dev initiates liquidity withdrawal by providing an EIP712 typed signature for an EIP2612 permit request
     *
     * requirements:
     *
     * - the caller must have provided a valid and unused EIP712 typed signature
     */
    function initWithdrawalPermitted(
        IPoolToken poolToken,
        uint256 poolTokenAmount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256);

    /**
     * @dev cancels a withdrawal request
     *
     * requirements:
     *
     * - the caller must have already initiated a withdrawal and received the specified id
     */
    function cancelWithdrawal(uint256 id) external;

    /**
     * @dev withdraws liquidity and returns the withdrawn amount
     *
     * requirements:
     *
     * - the provider must have already initiated a withdrawal and received the specified id
     * - the specified withdrawal request is eligible for completion
     * - the provider must have approved the network to transfer VBNT amount on its behalf, when withdrawing BNT
     * liquidity
     */
    function withdraw(uint256 id) external returns (uint256);

    /**
     * @dev performs a trade by providing the input source amount
     *
     * requirements:
     *
     * - the caller must have approved the network to transfer the source tokens on its behalf (except for in the
     *   native token case)
     */
    function tradeBySourceAmount(
        IERC20 sourceToken,
        IERC20 targetToken,
        uint256 sourceAmount,
        uint256 minReturnAmount,
        uint256 deadline,
        address beneficiary
    ) external payable;

    /**
     * @dev performs a trade by providing the input source amount and providing an EIP712 typed signature for an
     * EIP2612 permit request
     *
     * requirements:
     *
     * - the caller must have provided a valid and unused EIP712 typed signature
     */
    function tradeBySourceAmountPermitted(
        IERC20 sourceToken,
        IERC20 targetToken,
        uint256 sourceAmount,
        uint256 minReturnAmount,
        uint256 deadline,
        address beneficiary,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev performs a trade by providing the output target amount
     *
     * requirements:
     *
     * - the caller must have approved the network to transfer the source tokens on its behalf (except for in the
     *   native token case)
     */
    function tradeByTargetAmount(
        IERC20 sourceToken,
        IERC20 targetToken,
        uint256 targetAmount,
        uint256 maxSourceAmount,
        uint256 deadline,
        address beneficiary
    ) external payable;

    /**
     * @dev performs a trade by providing the output target amount and providing an EIP712 typed signature for an
     * EIP2612 permit request and returns the target amount and fee
     *
     * requirements:
     *
     * - the caller must have provided a valid and unused EIP712 typed signature
     */
    function tradeByTargetAmountPermitted(
        IERC20 sourceToken,
        IERC20 targetToken,
        uint256 targetAmount,
        uint256 maxSourceAmount,
        uint256 deadline,
        address beneficiary,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev deposits liquidity during a migration
     */
    function migrateLiquidity(
        IERC20 token,
        address provider,
        uint256 amount,
        uint256 availableAmount,
        uint256 originalAmount
    ) external payable;
}

interface IBancorNetworkInfo {
    /**
     * @dev returns the network contract
     */
    function network() external view returns (IBancorNetwork);

    /**
     * @dev returns the BNT contract
     */
    function bnt() external view returns (address);

    /**
     * @dev returns the BNT governance contract
     */
    function bntGovernance() external view returns (address);

    /**
     * @dev returns the VBNT contract
     */
    function vbnt() external view returns (address);

    /**
     * @dev returns the VBNT governance contract
     */
    function vbntGovernance() external view returns (address);

    /**
     * @dev returns the network settings contract
     */
    function networkSettings() external view returns (address);

    /**
     * @dev returns the master vault contract
     */
    function masterVault() external view returns (address);

    /**
     * @dev returns the address of the external protection vault
     */
    function externalProtectionVault() external view returns (address);

    /**
     * @dev returns the address of the external rewards vault
     */
    function externalRewardsVault() external view returns (address);

    /**
     * @dev returns the BNT pool contract
     */
    function bntPool() external view returns (address);

    /**
     * @dev returns the pool token contract for a given pool
     */
    function poolToken(address pool) external view returns (IPoolToken);

    /**
     * @dev returns the pending withdrawals contract
     */
    function pendingWithdrawals() external view returns (address);

    /**
     * @dev returns the pool migrator contract
     */
    function poolMigrator() external view returns (address);

    /**
     * @dev returns the output amount when trading by providing the source amount
     */
    function tradeOutputBySourceAmount(
        address sourceToken,
        address targetToken,
        uint256 sourceAmount
    ) external view returns (uint256);

    /**
     * @dev returns the input amount when trading by providing the target amount
     */
    function tradeInputByTargetAmount(
        address sourceToken,
        address targetToken,
        uint256 targetAmount
    ) external view returns (uint256);

    /**
     * @dev returns whether the given request is ready for withdrawal
     */
    function isReadyForWithdrawal(uint256 id) external view returns (bool);

    /**
     * @dev converts the specified pool token amount to the underlying token amount
     */
    function poolTokenToUnderlying(address pool, uint256 poolTokenAmount) external view returns (uint256);

    /**
     * @dev converts the specified underlying base token amount to pool token amount
     */
    function underlyingToPoolToken(address pool, uint256 tokenAmount) external view returns (uint256);

    /**
     * @dev returns the amounts that would be returned if the position is currently withdrawn,
     * along with the breakdown of the base token and the BNT compensation
     */
    function withdrawalAmounts(address pool, uint256 poolTokenAmount) external view returns (WithdrawalAmounts memory);

    struct WithdrawalAmounts {
        uint256 totalAmount;
        uint256 baseTokenAmount;
        uint256 bntAmount;
    }
}
