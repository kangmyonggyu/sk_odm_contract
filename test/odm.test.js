const ODM_Contract = artifacts.require("ODM_Contract");

contract('ODM_Contract', function([deployer, user1, user2, user3, user4]) {
    // local truffle 환경 account
    let odm_address = "0xf2fC09221C8928BD8F2Ed4F6E37a92d61c0810a6";
    let brandowner_address = "0xBf4D68998F777A68cf1ACf88b19806e17E42d1A5";
    let A_company_address = "0xe2654CDa29E4F82aE7875a8bc011187d16Ea6A9C";
    let B_company_address = "0x38Ab676B6E148f005BBea472F94Cf20D56bff6E2";
    let C_company_address = "0xbe3E1C32d342e353827f8ba5b7a12C69bb561e8d";
    let odm_contract;

    before(async ()  => {
        console.log("Before each");
        odm_contract = await ODM_Contract.new();
    })

    it('address test', () => {
        console.log("address test");
        assert.equal(deployer,odm_address)
        assert.equal(user1,brandowner_address)
        assert.equal(user2,A_company_address)
        assert.equal(user3,B_company_address)
        assert.equal(user4,C_company_address)
    })
});