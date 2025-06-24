# 🏆 Auction Smart Contract

> 🚀 A comprehensive auction smart contract built on Ethereum, featuring advanced bidding mechanics, automatic time extensions, and secure deposit management.

<div align="center">

![Solidity](https://img.shields.io/badge/Solidity-363636?style=for-the-badge&logo=solidity&logoColor=white)
![Ethereum](https://img.shields.io/badge/Ethereum-3C3C3D?style=for-the-badge&logo=Ethereum&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)
![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg?style=for-the-badge)

</div>

## 📖 Overview

This smart contract implements a complete auction system with cutting-edge features designed for maximum security and user experience! 🎯

### ✨ Key Features
- 📈 **Minimum bid increments** (5% higher than current highest bid)
- ⏰ **Automatic time extension** when bids are placed in the final 10 minutes
- 🔒 **Secure deposit management** with partial withdrawal capabilities
- 💰 **Commission-based refund system** (2% fee for non-winners)
- 📡 **Event-driven architecture** for real-time updates

## 🌟 Features

### 🎯 Core Functionality
- 🔨 **Bidding System**: Participants can place bids that must be at least 5% higher than the current highest bid
- ⏱️ **Time Management**: Automatic 10-minute extension when bids are placed within the last 10 minutes
- 🏅 **Winner Determination**: Clear identification of auction winner and winning amount
- 💳 **Deposit Management**: Secure handling of participant deposits with withdrawal capabilities

### 🚀 Advanced Features
- 💸 **Partial Refunds**: Participants can withdraw excess deposits during active auction
- 🏦 **Commission System**: 2% commission charged on non-winning deposits upon auction completion
- 📊 **Event Logging**: Comprehensive event system for tracking auction activities
- 🛡️ **Security Modifiers**: Built-in protection against common smart contract vulnerabilities

## 🏗️ Contract Architecture

### 📋 State Variables
- 👑 `owner`: Address of the auction creator
- ⏰ `auctionEndTime`: Timestamp when auction ends
- 💎 `highestBid`: Current highest bid amount
- 🥇 `highestBidder`: Address of current highest bidder
- 🏁 `ended`: Boolean flag indicating auction status
- 💰 `deposits`: Mapping of participant addresses to their deposit amounts

### 📡 Events
- 🎉 `NewBid`: Emitted when a new bid is placed
- 🏆 `AuctionEnded`: Emitted when auction concludes
- 💸 `DepositWithdrawn`: Emitted when participant withdraws deposits

### 🛡️ Modifiers
- ⚡ `onlyWhileActive`: Ensures functions only execute during active auction
- 👑 `onlyOwner`: Restricts certain functions to contract owner

## 🔧 Functions

### 🌐 Public Functions

#### 🔨 `bid()`
- **Purpose**: Place a bid in the auction
- **Requirements**: 
  - ✅ Auction must be active
  - 📈 New total bid must be at least 5% higher than current highest bid
- **💰 Payable**: Yes
- **⛽ Gas Limit**: ~100,000

#### 🏆 `showWinner()`
- **Purpose**: Display current auction winner and winning bid
- **Returns**: `(address winner, uint256 winningBid)`
- **👁️ View Function**: Yes

#### 📊 `showBids()`
- **Purpose**: Return array of all bids placed in auction
- **Returns**: `Bid[] memory`
- **👁️ View Function**: Yes

#### 💸 `withdrawExcess()`
- **Purpose**: Allow participants to withdraw excess deposits during auction
- **Requirements**: Must have available excess deposits

#### 🏁 `finalizeAuction()`
- **Purpose**: End the auction (callable by owner or after time expires)
- **Requirements**: Auction time expired OR caller is owner

#### 💰 `returnDeposits()`
- **Purpose**: Return deposits to non-winning participants (minus 2% commission)
- **Requirements**: Auction must be finalized, caller must not be winner

#### 🎊 `withdrawWinnings()`
- **Purpose**: Allow owner to withdraw winning bid amount
- **Requirements**: Auction finalized, caller must be owner
- **🔐 Access**: Owner only

### 👁️ View Functions

#### ⏳ `timeRemaining()`
- **Returns**: Seconds remaining in auction (0 if expired)

#### 📈 `auctionStatus()`
- **Returns**: Complete auction state information
- **Data**: owner, end time, highest bid, highest bidder, status, time remaining

## 🚀 Deployment

### 📋 Prerequisites
- 🦊 Ethereum wallet (MetaMask recommended)
- ⛽ Sufficient ETH for gas fees
- 🌐 Access to Ethereum network (Mainnet/Testnet)

### ⚙️ Constructor Parameters
- `_durationMinutes`: Auction duration in minutes

### 💡 Example Deployment
```solidity
// Deploy with 60-minute duration
Auction auction = new Auction(60);
```

## 🎮 Usage Examples

### 🔨 Placing a Bid
```javascript
// Connect to contract
const auction = new web3.eth.Contract(ABI, contractAddress);

// Place bid (value in Wei)
await auction.methods.bid().send({
    from: bidderAddress,
    value: web3.utils.toWei('1.05', 'ether') // Must be 5% higher than current
});
```

### 📊 Checking Auction Status
```javascript
// Get current auction state
const status = await auction.methods.auctionStatus().call();
console.log('Current highest bid:', web3.utils.fromWei(status._highestBid, 'ether'));
console.log('Time remaining:', status._timeRemaining, 'seconds');
```

### 💸 Withdrawing Excess Deposits
```javascript
// Withdraw excess deposits during auction
await auction.methods.withdrawExcess().send({
    from: participantAddress
});
```

## 🛡️ Security Features

### 🔒 Reentrancy Protection
- ✅ Uses checks-effects-interactions pattern
- 🔄 State changes before external calls
- ⚠️ Proper error handling for failed transfers

### 🔐 Access Control
- 👑 Owner-only functions protected by modifiers
- ⏰ Time-based restrictions for auction phases
- ✅ Input validation for all public functions

### ⚡ Gas Optimization
- 📦 Efficient storage patterns
- 🔗 Minimal external calls
- 🔄 Optimized loops and calculations

## 🧪 Testing

### ✅ Recommended Test Cases
1. **🎯 Basic Bidding**: Test normal bidding flow
2. **📈 Minimum Increment**: Verify 5% minimum requirement
3. **⏰ Time Extension**: Test automatic extension mechanism
4. **💸 Withdrawal**: Test excess deposit withdrawal
5. **🏁 Finalization**: Test auction ending and refunds
6. **🔍 Edge Cases**: Test boundary conditions and error states

### 🌐 Test Networks
- **🔥 Sepolia**: Recommended for testing
- **🌊 Goerli**: Alternative testnet
- **🏠 Local**: Ganache/Hardhat for development

## ⛽ Gas Estimates

<div align="center">

| Function | Estimated Gas | Status |
|----------|---------------|--------|
| `bid()` | ~80,000 - 120,000 | 🔥 |
| `withdrawExcess()` | ~50,000 - 80,000 | 🚀 |
| `returnDeposits()` | ~40,000 - 60,000 | ✅ |
| `finalizeAuction()` | ~30,000 - 50,000 | 💚 |

</div>

## 📡 Events and Logging

### 👂 Event Monitoring
```javascript
// Listen for new bids
auction.events.NewBid()
    .on('data', (event) => {
        console.log('🎉 New bid:', event.returnValues);
    });

// Listen for auction end
auction.events.AuctionEnded()
    .on('data', (event) => {
        console.log('🏆 Auction ended:', event.returnValues);
    });
```

## ⚠️ Error Handling

### 🚨 Common Errors
- ❌ `"Auction already ended"`: Attempting to bid after auction ends
- 📉 `"Bid not high enough"`: Bid doesn't meet 5% minimum requirement
- 💸 `"No deposits to withdraw"`: Attempting withdrawal with zero balance
- 🚫 `"Transfer failed"`: Network or balance issues during transfers

## 📄 License

<div align="center">

📜 **MIT License** - see LICENSE file for details

</div>

## 🤝 Contributing

1. 🍴 Fork the repository
2. 🌟 Create feature branch (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit changes (`git commit -m 'Add AmazingFeature'`)
4. 🚀 Push to branch (`git push origin feature/AmazingFeature`)
5. 🔃 Open Pull Request

## 📋 Changelog

### 🎉 Version 1.0.0
- 🚀 Initial release with core auction functionality
- 🔨 Implemented bidding system with 5% minimum increment
- ⏰ Added automatic time extension feature
- 💰 Integrated deposit management system
- 🏦 Added commission-based refund mechanism

## 💬 Support

For questions or support, please open an issue in the GitHub repository! 💡

<div align="center">

### 🌟 Star this repository if you found it helpful! 🌟

[![GitHub stars](https://img.shields.io/github/stars/yourusername/auction-smart-contract.svg?style=social&label=Star)](https://github.com/yourusername/auction-smart-contract)
[![GitHub forks](https://img.shields.io/github/forks/yourusername/auction-smart-contract.svg?style=social&label=Fork)](https://github.com/yourusername/auction-smart-contract/fork)

</div>

## ⚠️ Disclaimer

> 🚨 This smart contract is provided as-is for educational and development purposes. Users should conduct thorough testing and security audits before deploying to mainnet with real funds.

---

<div align="center">

**Made with ❤️ by Kevin Gomez**

**🔗 Connect with me:**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/yourprofile)
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/yourhandle)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/yourusername)

</div>
