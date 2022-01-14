var todo = artifacts.require("./todo.sol");

module.exports = function(deployer) {
    deployer.deploy(todo);
};