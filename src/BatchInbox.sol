// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract BatchInbox {
    StorageContract public immutable esStorageContract;

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
    }

    fallback() external payable {
        store();
    }

    receive() external payable {
        store();
    }
}

interface StorageContract {
    function putBlob(bytes32 key, uint256 blobIdx, uint256 length) external payable;
    function upfrontPayment() external view returns (uint256);
}
