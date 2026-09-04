// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ScamShield Registry
/// @notice A decentralized, community-driven registry for flagging suspicious
///         wallet addresses. Anyone can submit a report against an address,
///         and anyone can vote (upvote/downvote) on existing reports to build
///         a crowd-sourced trust score for that address.
/// @dev Built for ONE HACK 8-hour hackathon. Kept intentionally simple and
///      gas-light so it is easy to reason about, test, and demo.
contract ScamRegistry {
    struct Report {
        address reporter;      // who filed the report
        address flaggedAddress; // the address being reported
        string reason;         // short human-readable reason
        string evidenceURI;    // optional link (IPFS/URL) to evidence
        uint256 timestamp;
        int256 score;          // upvotes - downvotes
    }

    // All reports, indexed by an auto-incrementing id
    Report[] public reports;

    // reportId => voter => hasVoted (prevents double voting)
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // flaggedAddress => list of report IDs against it
    mapping(address => uint256[]) public reportsByAddress;

    event ReportFiled(
        uint256 indexed reportId,
        address indexed reporter,
        address indexed flaggedAddress,
        string reason
    );

    event Voted(
        uint256 indexed reportId,
        address indexed voter,
        bool upvote,
        int256 newScore
    );

    /// @notice File a new scam report against an address.
    /// @param _flaggedAddress The address being reported as suspicious.
    /// @param _reason A short description of why this address is suspicious.
    /// @param _evidenceURI Optional link to supporting evidence (can be empty string).
    function fileReport(
        address _flaggedAddress,
        string calldata _reason,
        string calldata _evidenceURI
    ) external {
        require(_flaggedAddress != address(0), "Invalid address");
        require(bytes(_reason).length > 0, "Reason required");

        reports.push(
            Report({
                reporter: msg.sender,
                flaggedAddress: _flaggedAddress,
                reason: _reason,
                evidenceURI: _evidenceURI,
                timestamp: block.timestamp,
                score: 0
            })
        );

        uint256 newReportId = reports.length - 1;
        reportsByAddress[_flaggedAddress].push(newReportId);

        emit ReportFiled(newReportId, msg.sender, _flaggedAddress, _reason);
    }

    /// @notice Vote on an existing report to confirm or dispute it.
    /// @param _reportId The id of the report being voted on.
    /// @param _upvote True to confirm the report is legitimate, false to dispute it.
    function vote(uint256 _reportId, bool _upvote) external {
        require(_reportId < reports.length, "Report does not exist");
        require(!hasVoted[_reportId][msg.sender], "Already voted");

        hasVoted[_reportId][msg.sender] = true;

        if (_upvote) {
            reports[_reportId].score += 1;
        } else {
            reports[_reportId].score -= 1;
        }

        emit Voted(_reportId, msg.sender, _upvote, reports[_reportId].score);
    }

    /// @notice Get the total number of reports filed against an address.
    function getReportCount(address _addr) external view returns (uint256) {
        return reportsByAddress[_addr].length;
    }

    /// @notice Get all report IDs filed against a given address.
    function getReportIds(address _addr) external view returns (uint256[] memory) {
        return reportsByAddress[_addr];
    }

    /// @notice Compute a simple aggregate trust score for an address by summing
    ///         the scores of all reports filed against it. More negative =
    ///         more strongly confirmed as suspicious by the community.
    function getTrustScore(address _addr) external view returns (int256) {
        uint256[] memory ids = reportsByAddress[_addr];
        int256 total = 0;
        for (uint256 i = 0; i < ids.length; i++) {
            total += reports[ids[i]].score;
        }
        return total;
    }

    /// @notice Total number of reports filed across the whole registry.
    function totalReports() external view returns (uint256) {
        return reports.length;
    }
}
