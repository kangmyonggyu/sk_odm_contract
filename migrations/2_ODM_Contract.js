const ODM_Contract = artifacts.require("ODM_Contract");

module.exports = function(deployer) {
  deployer.deploy(ODM_Contract);
};
