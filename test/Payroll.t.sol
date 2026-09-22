// SPDX-License-Identifier: MIT
pragma solidity ^0.8.36;

import {Test} from "forge-std/Test.sol";
import {Payroll} from "../src/Payroll.sol";
import {MockTIP20} from "./mocks/MockTIP20.sol";

contract PayrollTest is Test {
    Payroll public payroll;
    MockTIP20 public token;

    address public owner;
    address public worker1 = address(0x1);
    address public worker2 = address(0x2);

    function setUp() public {
        owner = address(this);
        token = new MockTIP20();
        payroll = new Payroll(address(token));
    }

    function test_AddWorker() public {
        payroll.addWorker(worker1, 1_000_000);
        assertEq(payroll.getWorkerCount(), 1);

        Payroll.Worker memory w = payroll.getWorker(0);
        assertEq(w.wallet, worker1);
        assertEq(w.amount, 1_000_000);
        assertEq(uint256(w.status), uint256(Payroll.PayoutStatus.Pending));
    }

    function test_OnlyOwnerCanAddWorker() public {
        vm.prank(worker1);
        vm.expectRevert(Payroll.NotOwner.selector);
        payroll.addWorker(worker2, 1_000_000);
    }

    function test_PayWorkerChangesStatus() public {
        payroll.addWorker(worker1, 1_000_000);

        token.mint(owner, 10_000_000);
        token.approve(address(payroll), 10_000_000);

        payroll.payWorker(0);

        Payroll.Worker memory w = payroll.getWorker(0);
        assertEq(uint256(w.status), uint256(Payroll.PayoutStatus.Sent));
        assertEq(token.balanceOf(worker1), 1_000_000);
    }

    function test_CannotPayWorkerTwice() public {
        payroll.addWorker(worker1, 1_000_000);
        token.mint(owner, 10_000_000);
        token.approve(address(payroll), 10_000_000);
        payroll.payWorker(0);

        vm.expectRevert("already paid");
        payroll.payWorker(0);
    }

    function test_PayAllWorkers() public {
        payroll.addWorker(worker1, 1_000_000);
        payroll.addWorker(worker2, 2_000_000);

        token.mint(owner, 10_000_000);
        token.approve(address(payroll), 10_000_000);

        payroll.payAllWorkers();

        assertEq(token.balanceOf(worker1), 1_000_000);
        assertEq(token.balanceOf(worker2), 2_000_000);

        Payroll.Worker memory w1 = payroll.getWorker(0);
        Payroll.Worker memory w2 = payroll.getWorker(1);
        assertEq(uint256(w1.status), uint256(Payroll.PayoutStatus.Sent));
        assertEq(uint256(w2.status), uint256(Payroll.PayoutStatus.Sent));
    }
}
