pragma solidity ^0.5.8;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract ODM_Contract is ERC20, ERC20Detailed {

    address private payment_guarantee_address;
    address private brandowner_address = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address private A_company_address = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    address private B_company_address = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
    address private C_company_address = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

    mapping(address => uint256) public balances;
    mapping(address => Company) private company;
    Bidding[] private bidding;

    string private winner_company_name;
    address private winner_company_address;
    uint256 private winner_payment_token_amount;

    struct Bidding {
        string company_name;
        address company_address;
        uint256 token_amount;
    }

    struct Company {
        string name;  // 'A' , 'B', 'C'
        bool is_bidding_company; //TODO: need check
        bool is_finished_bidding;
    }

    modifier onlyPaymentGuarantee(){
        require(msg.sender == payment_guarantee_address, "Only owner/payment guarantee can call this function.");
        _;
    }

    modifier onlyBrandOwner(){
        require(msg.sender == brandowner_address, "Only brand owner can call this function.");
        _;
    }

    modifier onlyCompany(){
        require(company[msg.sender].is_bidding_company, "Only Company can call this function.");
        _;
    }

    constructor () public ERC20Detailed("ODM Bidding Token", "OBT", 18) {
        company[A_company_address] = Company('A', true, false);
        company[B_company_address] = Company('B', true, false);
        company[C_company_address] = Company('C', true, false);
        _mint(msg.sender, 10000 * (10 ** uint256(decimals())));
        payment_guarantee_address = msg.sender;

        transfer(brandowner_address,  1500 * (10 ** uint256(decimals())));
        transfer(A_company_address,   2000 * (10 ** uint256(decimals())));
        transfer(B_company_address,   2000 * (10 ** uint256(decimals())));
        transfer(C_company_address,   2000 * (10 ** uint256(decimals())));
    }

    function deposit_to_paymentguarantee(uint256 _token) private {
        transfer(payment_guarantee_address, _token);
    }

    // Senario 2 @ brandonwer to paymentGuaranteeAddress api :
    // input _token : 1500000000000000000000
    function api_brandonwer_to_paymentguarantee(uint256 _token) public onlyBrandOwner {
        deposit_to_paymentguarantee(_token);
    }

    // Senario 3 @ bidding api :
    // input _token :
    // A company : 1700000000000000000000
    // B company : 1500000000000000000000
    // C company : 1200000000000000000000
    function api_bidding_company_to_paymentguarantee(uint256 _token) public onlyCompany {
        require(!company[msg.sender].is_finished_bidding,"You have already participated in the bidding.");
        bidding.push(Bidding(company[msg.sender].name, msg.sender, _token)); //TODO: transaction processing
        company[msg.sender].is_finished_bidding = true;                             //TODO: transaction processing
        deposit_to_paymentguarantee(_token);
    }

    uint256 public   lowest_2nd_token_amount;
    uint    public   lowest_1st_token_index;
    uint    public   lowest_2nd_token_index;

    // Senario 4 @ bidding processing
    function api_bidding_processing() public onlyPaymentGuarantee {
        lowest_1st_token_index = find_minimum_bidding_company_index(bidding);

        lowest_2nd_token_index = find_minimum_bidding_company_index(bidding, lowest_1st_token_index);
        lowest_2nd_token_amount = bidding[lowest_2nd_token_index].token_amount;

        winner_company_name = bidding[lowest_1st_token_index].company_name;
        winner_company_address = bidding[lowest_1st_token_index].company_address;
        winner_payment_token_amount = lowest_2nd_token_amount;

        refund_bidding_token();

        payment_winner_bidding_token(winner_company_address, winner_payment_token_amount);

    }

    function find_minimum_bidding_company_index(Bidding[] memory _bidding_list) private pure returns (uint) {
        uint minimum_token_company_index;
        uint256 minimum_token_amount;

        for (uint i = 0; i < _bidding_list.length ; i++) {
            if ( i == 0 ) {
                minimum_token_company_index = 0;
                minimum_token_amount = _bidding_list[i].token_amount;
            } else {
                if (minimum_token_amount > _bidding_list[i].token_amount) { //TODO: discussion same senario is not
                    minimum_token_company_index = i;
                    minimum_token_amount = _bidding_list[i].token_amount;
                }
            }
        }
        return minimum_token_company_index;
    }

    // find seconds bidding company
    function find_minimum_bidding_company_index(Bidding[] memory _bidding_list, uint ignore_index ) private pure returns (uint) {
        uint minimum_token_company_index;
        uint256 minimum_token_amount;

        for (uint i = 0; i < _bidding_list.length ; i++) {
            if ( i != ignore_index) {
                if ( i == 0 ) {
                    minimum_token_company_index = 0;
                    minimum_token_amount = _bidding_list[i].token_amount;
                } else {
                    if (minimum_token_amount > _bidding_list[i].token_amount) { //TODO: discussion same senario is not
                        minimum_token_company_index = i;
                        minimum_token_amount = _bidding_list[i].token_amount;
                    }
                }
            }
        }
        return minimum_token_company_index;
    }


    function refund_bidding_token () private {
        for (uint i = 0 ; i < bidding.length ; i++) {
            transfer(bidding[i].company_address, bidding[i].token_amount);
        }
    }

    // Senario 6 @ payment to winner
    function payment_winner_bidding_token (address _winner_address, uint256 _winner_token) private {
        transfer(_winner_address, _winner_token);
    }

    function get_winner_company_name() public view returns (string memory) {
        return winner_company_name;
    }

    function get_winner_company_address() public view returns (address) {
        return winner_company_address;
    }

    function get_winner_payment_token_amount() public view returns (uint256) {
        return winner_payment_token_amount;
    }

}
