const PrivateKeyProvider = require("@truffle/hdwallet-provider");

const testnet_privateKey = "0x39fcb451a731a0ad58e58fe1cbaa851c953062813dffe070e6a5a623f67b91de";
const mainnet_privateKey = "0xa4aaa8c1db80d6449b11c6ed2e2d40c17f5a6c5304c9599371152632e64b2bdf";

const privateKeyProviderTestnet = new PrivateKeyProvider(testnet_privateKey, "https://besutest.chainz.network");
const privateKeyProviderMainnet = new PrivateKeyProvider(mainnet_privateKey, "https://besu.chainz.network");

module.exports = {

  networks: {
        // development env ( ganache )
        development: {
          host: "localhost",
          port: 7545,
          network_id: "5777"
        },
        // test env ( testnet )
        test: {
          provider: privateKeyProviderTestnet,
          gasPrice: 0,
          network_id: "2020",
        },
        // prod env ( mainnet )
        besu: {
          provider: privateKeyProviderMainnet,
          gasPrice: 0,
          network_id: "2020",
        },
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "^0.5.8",    // Fetch exact version from solc-bin (default: truffle's version)
      docker: false,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {           // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: false,
         runs: 200
       },
       evmVersion: "constantinople"
      }
    }
  }
};