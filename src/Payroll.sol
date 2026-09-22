// SPDX-License-Identifier: MIT
pragma solidity ^0.8.36;

import {ITIP20} from "tempo-std/interfaces/ITIP20.sol";

contract Payroll {
    ITIP20 public token;
    address public owner;

    enum PayoutStatus { None, Pending, Sent }

    struct Worker {
        address wallet;
        uint256 amount;
        PayoutStatus status;
    }

    Worker[] public workers;

    event WorkerAdded(address indexed wallet, uint256 amount);
    event PayoutStatusChanged(address indexed wallet, PayoutStatus status);
    event PayoutSent(address indexed wallet, uint256 amount);

    error NotOwner();
    error TransferFailed();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(address _token) {
        token = ITIP20(_token);
        owner = msg.sender;
    }

    function addWorker(address wallet, uint256 amount) external onlyOwner {
        workers.push(Worker(wallet, amount, PayoutStatus.Pending));
        emit WorkerAdded(wallet, amount);
        emit PayoutStatusChanged(wallet, PayoutStatus.Pending);
    }

    function payWorker(uint256 index) external onlyOwner {
        Worker storage w = workers[index];
        require(w.status == PayoutStatus.Pending, "already paid");

        bool success = token.transferFrom(msg.sender, w.wallet, w.amount);
        if (!success) revert TransferFailed();

        w.status = PayoutStatus.Sent;
        emit PayoutStatusChanged(w.wallet, PayoutStatus.Sent);
        emit PayoutSent(w.wallet, w.amount);
    }

    function payAllWorkers() external onlyOwner {
        for (uint256 i = 0; i < workers.length; i++) {
            Worker storage w = workers[i];
            if (w.status == PayoutStatus.Pending) {
                bool success = token.transferFrom(msg.sender, w.wallet, w.amount);
                if (!success) revert TransferFailed();
                w.status = PayoutStatus.Sent;
                emit PayoutStatusChanged(w.wallet, PayoutStatus.Sent);
                emit PayoutSent(w.wallet, w.amount);
            }
        }
    }

    function getWorkerCount() external view returns (uint256) {
        return workers.length;
    }

    function getWorker(uint256 index) external view returns (Worker memory) {
        return workers[index];
    }
}
