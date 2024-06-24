// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.22;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "contract/customToken.sol";

contract XYZStore {
    customToken public xyzToken;  // Changed from IERC20 to CustomToken to access burn function
    address payable public  admin = payable (msg.sender);
    mapping(address => bool) public validatedcustomers;

    // Discount thresholds
    uint256 TEN_TOKENS = 10e18;
    uint256 TWENTY_TOKENS = 20e18;
    uint256 THIRTY_TOKENS = 30e18;
    uint256 FOURTY_TOKENS = 40e18;
    uint256 FIFTY_TOKENS = 50e18;

    constructor(address _xyzToken) payable {
        xyzToken = customToken(_xyzToken);  // Cast to CustomToken
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this");
        _;
    }

    receive() external payable {}
    fallback() external payable {}

    function validateCustomer(address cust) external onlyAdmin returns (uint256) {
        xyzToken.approve(cust,5e18);
        validatedcustomers[cust]=true;
        return xyzToken.allowance(admin,cust);
    }

    function buyProduct(bool wantDiscount) public payable {
        require(msg.value>0,"Number of product buying is 0");
        require(msg.value<=msg.sender.balance,"not enough ether in account");
        require(validatedcustomers[msg.sender],"Not a valid customer");

        if (wantDiscount){
            uint256 discAmt = availDiscount() ;
            payable(admin).transfer((msg.value - discAmt));
            payable(msg.sender).transfer(discAmt);
            xyzToken.transferFrom(admin,msg.sender,5e18);
        }
        else{
            payable(admin).transfer(msg.value);
            xyzToken.transferFrom(admin,msg.sender,5e18);
        }
    }

    function availDiscount() internal  returns (uint256)  {
        uint256 userBalance = xyzToken.balanceOf(msg.sender);
        uint256 rebateAmount=0;
        if(userBalance >= FIFTY_TOKENS) {
            rebateAmount = msg.value * 70/100;
            xyzToken.selfapprove(msg.sender,FIFTY_TOKENS);
            // Burn tokens using the burn function
            xyzToken.burnFrom(msg.sender,FIFTY_TOKENS);
        } 
        else if(userBalance >= FOURTY_TOKENS) {
            rebateAmount = (msg.value * 55)/100;
            xyzToken.selfapprove(msg.sender,FOURTY_TOKENS);
            // Burn tokens using the burn function
            xyzToken.burnFrom(msg.sender,FOURTY_TOKENS);
        } 
        else if(userBalance >= THIRTY_TOKENS) {
            rebateAmount = (msg.value / 5)*2;
            xyzToken.selfapprove(msg.sender,THIRTY_TOKENS);
            // Burn tokens using the burn function
            xyzToken.burnFrom(msg.sender,THIRTY_TOKENS);
        } 
        else if(userBalance >= TWENTY_TOKENS) {
            rebateAmount = msg.value / 4;  
            xyzToken.selfapprove(msg.sender,TWENTY_TOKENS);
            // Burn tokens using the burn function
            xyzToken.burnFrom(msg.sender,TWENTY_TOKENS);
        } 
        else if(userBalance >= TEN_TOKENS) {
            rebateAmount = msg.value / 10;
            xyzToken.selfapprove(msg.sender,TEN_TOKENS);
             // Burn tokens using the burn function
            xyzToken.burnFrom(msg.sender,TEN_TOKENS);
        } 
        else {
            return 0;
        }
        return  rebateAmount;
    }
}
