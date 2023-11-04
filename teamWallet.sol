// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TeamWallet {
    address deployer;
    uint memberCount; // Count of team members
    mapping(uint => address) membersById; // Mapping of member IDs to addresses
    uint creditsAvailable;

    struct Transaction {
        uint amount;
        uint approvals;
        uint rejections;
        bool executed;
        bool failed;
    }

    Transaction[] transactions;
    mapping(address => mapping(uint => bool)) hasApprovedOrRejected;

    // Modifier to restrict access to only the deployer
    modifier onlyDeployer() {
        require(msg.sender == deployer, "Only the deployer can call this function");
        _;
    }

    // Function to check if an address is a team member
    function isMember(address _address) internal view returns (bool) {
        for (uint i = 1; i <= memberCount; i++) {
            if (membersById[i] == _address) {
                return true;
            }
        }
        return false;
    }

    // Modifier to restrict access to team members
    modifier onlyMembers() {
        require(isMember(msg.sender), "Only team members can call this function");
        _;
    }

    // Modifier to check if a transaction with a given index exists
    modifier transactionExists(uint n) {
        require(n < transactions.length, "Transaction does not exist");
        _;
    }

    constructor() {
        deployer = msg.sender;
        memberCount = 0; // Initialize member count to 0
    }

    // Function to set up the wallet with team members and initial credits
    function setWallet(address[] memory _members, uint _credits) public onlyDeployer {
        require(_members.length > 0, "At least one member is required");
        require(_credits > 0, "Credits must be greater than 0");
        require(!isMember(msg.sender), "Deployer cannot be a team member");
        require(creditsAvailable == 0, "Wallet is already initialized");

        for (uint i = 0; i < _members.length; i++) {
            memberCount++;
            membersById[memberCount] = _members[i];
        }

        creditsAvailable = _credits;
    }

    // Function to propose a spending transaction
    function spend(uint _amount) public onlyMembers {
        require(_amount > 0, "Amount must be greater than 0");

        // Record the spend request
        transactions.push(Transaction(_amount, 1, 0, false, false));
    }

    // Function to approve a spending transaction
    function approve(uint _n) public onlyMembers transactionExists(_n) {
        require(!hasApprovedOrRejected[msg.sender][_n], "Already approved or rejected");
        require(!transactions[_n].executed, "Transaction already executed");

        transactions[_n].approvals += 1;
        hasApprovedOrRejected[msg.sender][_n] = true;

        // Check if the transaction has enough approvals to be executed
        if (transactions[_n].approvals >= (memberCount * 70) / 100) {
            transactions[_n].executed = true;
            // Deduct the amount from available credits
            if (transactions[_n].amount <= creditsAvailable) {
                creditsAvailable -= transactions[_n].amount;
            } else {
                // If the amount exceeds available credits, mark the transaction as failed
                transactions[_n].failed = true;
            }
        }
    }

    // Function to reject a spending transaction
    function reject(uint _n) public onlyMembers transactionExists(_n) {
        require(!hasApprovedOrRejected[msg.sender][_n], "Already approved or rejected");
        require(!transactions[_n].executed, "Transaction already executed");

        transactions[_n].rejections += 1;
        hasApprovedOrRejected[msg.sender][_n] = true;

        // Check if the transaction has too many rejections to be executed
        if (transactions[_n].rejections > (memberCount * 30) / 100) {
            transactions[_n].failed = true;
        }
    }

    // Function to check available credits
    function credits() public view onlyMembers returns (uint) {
        return creditsAvailable;
    }

    // Function to view transaction details
    function viewTransaction(uint _n) public view onlyMembers transactionExists(_n) returns (uint amount, string memory status) {
        Transaction storage transaction = transactions[_n];

        if (transaction.executed) {
            if (transaction.failed) {
                status = "failed";
            } else {
                status = "debited";
            }
        } else if (transaction.approvals >= (memberCount * 70) / 100) {
            status = "pending";
        } else if (transaction.rejections > (memberCount * 30) / 100) {
            status = "failed";
        } else {
            status = "pending";
        }

        amount = transaction.amount;
    }

    // Function to get transaction statistics
    function transactionStats() public view onlyMembers returns (uint debitedCount, uint pendingCount, uint failedCount) {
        for (uint i = 0; i < transactions.length; i++) {
            Transaction storage transaction = transactions[i];

            if (transaction.executed) {
                if (transaction.failed) {
                    failedCount++;
                } else {
                    debitedCount++;
                }
            } else if (transaction.approvals >= (memberCount * 70) / 100) {
                pendingCount++;
            } else if (transaction.rejections > (memberCount * 30) / 100) {
                failedCount++;
            } else {
                pendingCount++;
            }
        }
    }
}
