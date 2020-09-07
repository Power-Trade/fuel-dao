const moment = require('moment');

const {BN, time, expectEvent, expectRevert, constants} = require('@openzeppelin/test-helpers');
const {latest} = time;

require('chai').should();

const VestingDepositAccount = artifacts.require('VestingDepositAccount');

contract('VestingDepositAccount', function ([_, admin, token, controller, beneficiary, anotherBeneficiary]) {

    beforeEach(async () => {
        this.vestingDepositAccount = await VestingDepositAccount.new({from: admin});
        await this.vestingDepositAccount.init(token, controller, beneficiary);
    });

    it('should return token address, controller, and beneficary', async () => {
        (await this.vestingDepositAccount.token()).should.be.equal(token);
        (await this.vestingDepositAccount.controller()).should.be.equal(controller);
        (await this.vestingDepositAccount.beneficiary()).should.be.equal(beneficiary);
    });


    describe('reverts', async () => {

        it('when init called twice', async () => {
            await expectRevert(
                this.vestingDepositAccount.init(token, controller, beneficiary),
                'VestingDepositAccount::init: Contract already initialized'
            );
        });

        it('when transferToBeneficiary not called by controller', async () => {
            await expectRevert(
                this.vestingDepositAccount.transferToBeneficiary(new BN("100"), {from: beneficiary}),
                'VestingDepositAccount::transferToBeneficiary: Only controller'
            );
        });

        it('when switchBeneficiary not called by controller', async () => {
            await expectRevert(
                this.vestingDepositAccount.switchBeneficiary(anotherBeneficiary, {from: beneficiary}),
                'VestingDepositAccount::switchBeneficiary: Only controller'
            );
        });

        it('when updateVotingDelegation not called by controller', async () => {
            await expectRevert(
                this.vestingDepositAccount.updateVotingDelegation(anotherBeneficiary, {from: beneficiary}),
                'VestingDepositAccount::updateVotingDelegation: Only controller'
            );
        });
    });

});
