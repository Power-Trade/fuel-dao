const {utils} = require('ethers');
var prompt = require('prompt-sync')();

module.exports = function () {
    const gwei = prompt('Gas price? (gwei) ');
    if(!gwei) throw new Error('Gas price must be specified');
    const bnWei = utils.parseUnits(gwei, "gwei");
    return {
        gasPrice:bnWei
    }
}