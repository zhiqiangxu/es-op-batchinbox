// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract BatchInbox {
    StorageContract public immutable esStorageContract;
    mapping(address => uint256) public balances;

    error BalanceNotEnough();

    constructor(address _esStorageContract) {
        esStorageContract = StorageContract(_esStorageContract);
    }

    function store() internal {
        uint256 i = 0;
        uint256 payment = 0;
        bytes32 h;
        do {
            h = blobhash(i);
            if (h == bytes32(0)) break;
            if (payment == 0) payment = esStorageContract.upfrontPayment();
            esStorageContract.putBlob{value: payment}(h, i, 4096 * 32);
            unchecked {
                i++;
            }
        } while (true);

        // deduct fee from balance
        if (i == 0) return;
        uint256 toDeduct = payment * i;
        uint256 balance = balances[msg.sender];
        if (balance < toDeduct) revert BalanceNotEnough();
        balances[msg.sender] = balance - toDeduct;
    }

    fallback() external payable {
        _deposit(msg.sender, msg.value);
        store();
    }

    receive() external payable {
        _deposit(msg.sender, msg.value);
        store();
    }

    function deposit(address _to) external payable {
        _deposit(_to, msg.value);
    }

    function _deposit(address _to_to, uint256 _amount) internal {
        if (_amount == 0) return;

        balances[_to_to] += _amount;
    }

    function withdraw(address _to, uint256 _amount) external {
        uint256 balance = balances[msg.sender];
        if (balance < _amount) revert BalanceNotEnough();

        balances[msg.sender] = balance - _amount;
        payable(_to).transfer(_amount);
    }
}

interface StorageContract {
    function putBlob(bytes32 key, uint256 blobIdx, uint256 length) external payable;
    function upfrontPayment() external view returns (uint256);
}
