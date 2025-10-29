// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FairArtRoyaltyDistributionSystem {
    
    // Mapping of artwork IDs to their royalty recipients and corresponding shares
    mapping(uint256 => address[]) private artRoyaltyRecipients;
    mapping(uint256 => uint256[]) private artRoyaltyShares;

    // Event to log royalty distributions
    event RoyaltyDistributed(uint256 artId, address recipient, uint256 amount);

    // Function to set the royalty recipients and their share for an artwork
    function setRoyaltyInfo(uint256 artId, address[] memory recipients, uint256[] memory shares) public {
        require(recipients.length == shares.length, "Recipients and shares length mismatch");
        
        artRoyaltyRecipients[artId] = recipients;
        artRoyaltyShares[artId] = shares;
    }

    // Function to distribute royalties to the recipients based on their share
    function distributeRoyalty(uint256 artId, uint256 totalRoyaltyAmount) public {
        address[] memory recipients = artRoyaltyRecipients[artId];
        uint256[] memory shares = artRoyaltyShares[artId];
        
        require(recipients.length > 0, "No recipients set for this artwork");
        require(recipients.length == shares.length, "Mismatch between recipients and shares");

        uint256 totalShares = 0;
        for (uint256 i = 0; i < shares.length; i++) {
            totalShares += shares[i];
        }
        
        // Distribute royalties to each recipient
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 recipientRoyalty = (totalRoyaltyAmount * shares[i]) / totalShares;
            payable(recipients[i]).transfer(recipientRoyalty);
            emit RoyaltyDistributed(artId, recipients[i], recipientRoyalty);
        }
    }

    // Function to check the balance of an address (for testing)
    function getBalance(address user) public view returns (uint256) {
        return user.balance;
    }
}

