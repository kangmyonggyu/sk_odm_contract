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
    uint256 _token
    -> Brand Owner 계좌에서 Payment Guarantee 계좌로 송금할 금액

###   - Return
    
## 3. api_bidding_company_to_paymentguarantee
`함수 설명`<br>
Senario 3. 각 업체별 OBT token 제안가로 입찰 참여

###   - modifier (function 수행 시, 선행 조건)
`onlyCompany`

    require(company[msg.sender].is_bidding_company, "Only Company can call this function.");
    -> Bidding 참여 업체 address로 function이 호출될 시에만 수행

###   - Parameter
    uint256 _token
    -> 각 업체별 입찰에 참여할 금액

###   - Return

## 4. api_bidding_processing
`함수 설명`<br>
Senario 4. Vickrey 경매 조건에 따른 낙찰 업체 선정 -> main function

###   - modifier (function 수행 시, 선행 조건)
`onlyCompany`

    require(company[msg.sender].is_bidding_company, "Only Company can call this function.");
    -> Bidding 참여 업체 address로 function이 호출될 시에만 수행

###   - Parameter
    
###   - Return

## 5. find_minimum_bidding_company_index
`함수 설명`<br>
Senario 4. Vickrey 경매 조건에 따른 낙찰 업체 선정 -> 최저가 입찰 업체 확인

###   - modifier (function 수행 시, 선행 조건)
    
###   - Parameter
    Bidding[] memory _bidding_list
    -> 입찰에 참여한 업체들의 정보(struct type)를 담은 list

###   - Return
    uint minimum_token_company_index
    -> 최저가 입찰 업체의 index 번호

## 6. find_minimum_bidding_company_index
`함수 설명`<br>
Senario 4. Vickrey 경매 조건에 따른 낙찰 업체 선정 -> 하위 2번째 입찰 업체 확인

###   - modifier (function 수행 시, 선행 조건)
    
###   - Parameter
    Bidding[] memory _bidding_list
    -> 입찰에 참여한 업체들의 정보(struct type)를 담은 list
    uint ignore_index
    -> 최저가 입찰 업체의 index 번호

###   - Return
    uint minimum_token_company_index
    -> 하위 2번째 입찰 업체의 index 번호
    
## 7. refund_bidding_token
`함수 설명`<br>
Senario 4. Vickrey 경매 조건에 따른 낙찰 업체 선정 -> 업체 선정 후, 입찰 참여 업체에 OBD token refund

###   - modifier (function 수행 시, 선행 조건)
    
###   - Parameter
    
###   - Return
    
## 8. refund_deposit_token_to_brandowner
`함수 설명`<br>
Senario 4. Vickrey 경매 조건에 따른 낙찰 업체 선정 -> 업체 선정 후, Brand Owner에게 ODM token refund

###   - modifier (function 수행 시, 선행 조건)
    
###   - Parameter
    
###   - Return
