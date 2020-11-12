const PrivateKeyProvider = require("@truffle/hdwallet-provider");
 
const privateKey = "0xc87509a1c067bbde78beb793e6fa76530b6382a4c0241e5e4a9ec0a0f44dc0d3";
const privateKeyProviderMainnet = new PrivateKeyProvider(privateKey, "https://besu.chainz.network");
const privateKeyProviderTestnet = new PrivateKeyProvider(privateKey, "https://besutest.chainz.network");

module.exports = {
 
  networks: {
        // development env ( ganache )
        development: {
          host: "localhost",
          port: 7545,
          network_id: "5777"
        },
        // test env ( testnet )
        besuTest: {
          provider: privateKeyProviderTestnet,
          gasPrice: 0,
          network_id: "2020"
        },
        // prod env ( mainnet )
        besu: {
          provider: privateKeyProviderMainnet,
          gasPrice: 0,
          network_id: "2020"
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