// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
提示：
使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包
*/
contract Coin is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private constant _decimals = 18;

    address public _owner;
    uint256 private _totalSupply;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    error ZeroAddress(string msg);
    error InsufficientBalance();
    error InsufficientAllowance();
    error NotOwner();

    modifier onlyOwner(){
        if (msg.sender != _owner) revert NotOwner();
        _;
    }

    constructor(string memory name_, string memory symbol_) {
       _name = name_;
       _symbol = symbol_;
       _owner = msg.sender;
    }

    function name() external view returns (string memory){ return _name; }
    function symbol() external view returns (string memory) { return _symbol; }
    function decimals() external pure returns (uint8) { return _decimals; }
    function totalSupply() external view returns (uint256){ return _totalSupply; }

    function balanceOf(address account_) external view returns (uint256){
        return _balances[account_];
    }

    function transfer(address to_, uint256 value_) external returns (bool){
        _transfer(msg.sender, to_, value_);

        return true;
    }

    function _transfer(address from_, address to_, uint256 amount_) internal{
        if (to_ == address(0) || from_ == address(0)) revert ZeroAddress("_transfer ZeroAddress");
        
        uint256 bal = _balances[from_];
        if (bal < amount_) revert InsufficientBalance();

        _balances[from_] -= amount_;
        _balances[to_] +=  amount_;
        emit Transfer(from_, to_, amount_);
    }

    function allowance(address owner_, address spender_) external view returns (uint256){
        return _allowances[owner_][spender_];
    }

    function approve(address spender_, uint256 value_) external returns (bool){
        _approve(msg.sender, spender_, value_);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        if (owner == address(0) || spender == address(0)) revert ZeroAddress("_approve ZeroAddress");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function transferFrom(address from_, address to_, uint256 value_) external returns (bool){
        uint256 currentAllowance = _allowances[from_][msg.sender];
        if (currentAllowance < value_) revert InsufficientAllowance();
        unchecked{
            _allowances[from_][msg.sender] -= value_;
        }

        _transfer(from_, to_, value_);
        return true;
    }

    function mint(address to_, uint256 value_) external onlyOwner returns (bool) {
        if (to_ == address(0)) revert ZeroAddress("mint ZeroAddress");
        _totalSupply += value_;
        _balances[to_] += value_;
        emit Transfer(address(0), to_, value_);
        return true;
    }
}