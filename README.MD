# Contract Function List

ODM Bidding Contact에서 구현한 function list는 다음과 같습니다.

## 1. reset_auction

`함수 설명`<br>
Vickrey 경매를 초기화 하는 Function

###   - modifier (function 수행 시, 선행 조건)

`onlyPaymentGuarantee`

    require(msg.sender == payment_guarantee_address, "Only owner/payment guarantee can call this function.");
    -> payment_guarantee address로 function이 호출될 시에만 수행

###   - Parameter
    
    
###   - Return
    
    
## 2. api_brandowner_to_paymentguarantee

`함수 설명`<br>
Senario 2. Brand Owner 계좌에서 Payment Guarantee 계좌로 OBT(ODM Bidding Token) Deposit

###   - modifier (function 수행 시, 선행 조건)

`onlyBrandOwner`

    require(msg.sender == brandowner_address, "Only brand owner can call this function.");
    -> brand owner address로 function이 호출될 시에만 수행

###   - Parameter

`uint256 _token <br>
-> Brand Owner 계좌에서 Payment Guarantee 계좌로 송금할 금액`

###   - Return

