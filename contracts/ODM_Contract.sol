pragma solidity ^0.5.8;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract ODM_Contract is ERC20, ERC20Detailed {

    // MainNet
    address private brandowner_address = 0xc5D50eCcb13a6428BEd539ccB02294A1Bb90FDD6;
    address private A_company_address = 0xACb3907F9c6cdb834EA1277D99278F283cD82066;
    address private B_company_address = 0x5B3eCaB5c578A26992C2F8677d84812362A036E7;
    address private C_company_address = 0x8A711d936aDBBf9495FF3064395B7D2590D64ceE;

    // TestNet
//    address private brandowner_address = 0x4ACB42d6CD76001c2e427E2De6ACb27C4466eB12;
//    address private A_company_address = 0xC96c845d3246F52BEC42C13050bc36B9f1860298;
//    address private B_company_address = 0x9bE87345B869B2b331D4E91c7A7B30bc981Ee36E;
//    address private C_company_address = 0xc9BeF9a0e1b49Bc55a3c9e6f4dC24039793d8F6b;

    // Ganache

//     address private brandowner_address = 0xBf4D68998F777A68cf1ACf88b19806e17E42d1A5;
//     address private A_company_address = 0xe2654CDa29E4F82aE7875a8bc011187d16Ea6A9C;
//     address private B_company_address = 0x38Ab676B6E148f005BBea472F94Cf20D56bff6E2;
//     address private C_company_address = 0xbe3E1C32d342e353827f8ba5b7a12C69bb561e8d;

    // REMIX (VM)
//    address private brandowner_address = 0xBf4D68998F777A68cf1ACf88b19806e17E42d1A5;
//    address private A_company_address = 0xe2654CDa29E4F82aE7875a8bc011187d16Ea6A9C;
//    address private B_company_address = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
//    address private C_company_address = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;

    address private payment_guarantee_address;

    mapping(address => Company) private company;
    struct Company {
        string name;  // 'A' , 'B', 'C'
        bool is_bidding_company; //TODO: need check
        bool is_finished_bidding;
    }

    Bidding[] private bidding;
    struct Bidding {
        string company_name;
        address company_address;
        uint256 token_amount;
    }

    struct Winner {
        string company_name;
        address company_address;
        uint256 token_amount;
    }

    Winner public winner;

    event event_transfer(string tx,address from, address to, uint256 token);

    string private winner_company_name;
    address private winner_company_address;
    uint256 private winner_payment_token_amount;
    uint256 private deposit_token_amount = 0;

    uint256 public   lowest_2nd_token_amount;
    uint    public   lowest_1st_token_index;
    uint    public   lowest_2nd_token_index;

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

    function reset_auction() public onlyPaymentGuarantee {
        // reset variable
        company[A_company_address] = Company('A', true, false);
        company[B_company_address] = Company('B', true, false);
        company[C_company_address] = Company('C', true, false);
        delete bidding;
        deposit_token_amount = 0;
        lowest_2nd_token_amount = 0;
        lowest_1st_token_index = 0;
        lowest_2nd_token_index = 0;
        winner_payment_token_amount = 0;

        winner.company_name = "";
        winner.company_address = address(0);
        winner.token_amount = 0;

        transfer(brandowner_address,  1500 * (10 ** uint256(decimals())));
        transfer(A_company_address,   2000 * (10 ** uint256(decimals())));
        transfer(B_company_address,   2000 * (10 ** uint256(decimals())));
        transfer(C_company_address,   2000 * (10 ** uint256(decimals())));
    }

    // Senario 2 @ brandowner to paymentGuaranteeAddress api :
    // input _token : 1500000000000000000000
    function api_brandowner_to_paymentguarantee(uint256 _token) public onlyBrandOwner {
        transfer(payment_guarantee_address, _token);
        deposit_token_amount = _token;
    }

    // Senario 3 @ bidding api :
    // input _token :
    // A company : 1700000000000000000000
    // B company : 1500000000000000000000
    // C company : 1200000000000000000000
    function api_bidding_company_to_paymentguarantee(uint256 _token) public onlyCompany {
        require(!company[msg.sender].is_finished_bidding,"You have already participated in the bidding.");
        transfer(payment_guarantee_address, _token);
        bidding.push(Bidding(company[msg.sender].name, msg.sender, _token));
        company[msg.sender].is_finished_bidding = true;
    }

    // Senario 4 @ bidding processing ,
    // Senario 6 @ Transfer Payment to Company
    function api_bidding_processing() public  onlyPaymentGuarantee {
        lowest_1st_token_index = find_minimum_bidding_company_index(bidding);

        lowest_2nd_token_index = find_minimum_bidding_company_index(bidding, lowest_1st_token_index);
        lowest_2nd_token_amount = bidding[lowest_2nd_token_index].token_amount;

        winner_company_name = bidding[lowest_1st_token_index].company_name;
        winner_company_address = bidding[lowest_1st_token_index].company_address;
        winner_payment_token_amount = lowest_2nd_token_amount;

        winner.company_name = winner_company_name;
        winner.company_address = winner_company_address;
        winner.token_amount = winner_payment_token_amount;

        refund_bidding_token();
        refund_deposit_token_to_brandowner();
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

        if (ignore_index == 0) {
            for (uint i = 1; i < _bidding_list.length ; i++) {
                if ( i == 1 ) {
                    minimum_token_company_index = i;
                    minimum_token_amount = _bidding_list[i].token_amount;
                } else {
                    if (minimum_token_amount > _bidding_list[i].token_amount) { //TODO: discussion same senario is not
                        minimum_token_company_index = i;
                        minimum_token_amount = _bidding_list[i].token_amount;
                    }
                }
            }
        } else {
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
        }
        return minimum_token_company_index;
    }

    function refund_bidding_token () private {
        for (uint i = 0 ; i < bidding.length ; i++) {
            transfer(bidding[i].company_address, bidding[i].token_amount);
            //            emit event_transfer(msg.sender,)
            //            event_transfer(string tx,address from, address to, uint256 token);
        }
    }

    // refund reposit token to brandowner
    function refund_deposit_token_to_brandowner () private {
        if (deposit_token_amount > winner_payment_token_amount) {
            transfer(brandowner_address, deposit_token_amount - winner_payment_token_amount);
        }
    }

    // Senario 6 @ payment to winner
    function payment_winner_bidding_token (address _winner_address, uint256 _winner_token) private {
        transfer(_winner_address, _winner_token);

        company[A_company_address] = Company('A', true, false);
        company[B_company_address] = Company('B', true, false);
        company[C_company_address] = Company('C', true, false);

        delete bidding;
        deposit_token_amount = 0;
        lowest_2nd_token_amount = 0;
        lowest_1st_token_index = 0;
        lowest_2nd_token_index = 0;
        winner_payment_token_amount = 0;
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