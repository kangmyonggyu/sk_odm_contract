# Contract Function List

ODM Bidding Contact에서 구현한 function list는 다음과 같습니다.

## reset_auction

`함수 설명`<br>
Vickrey 경매를 초기화 하는 Function

### modifier (function 수행 시, 선행 조건)

`onlyPaymentGuarantee`

    msg.sender == payment_guarantee_address
    -> payment_guarantee address로 function이 호출될 시에만 수행

### Parameter

    
    []
