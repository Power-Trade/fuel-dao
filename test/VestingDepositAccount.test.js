const moment = require('moment');

const {BN, time, expectEvent, expectRevert, constants} = require('@openzeppelin/test-helpers');
const {latest} = time;

require('chai').should();

const SyncToken = artifacts.require('SyncToken');
const VestingDepositAccount = artifacts.require('VestingDepositAccount');

contract('VestingDepositAccount', function ([_, admin, controller, beneficiary, anotherBeneficiary]) {

    const DECIMALS = 18;
    const TEN_BILLION = new BN(10000000);
    const INITIAL_SUPPLY = TEN_BILLION.mul(new BN(10).pow(new BN(DECIMALS)));

    beforeEach(async () => {
        this.token = await SyncToken.new(INITIAL_SUPPLY, admin, admin, {from: admin});
        this.vestingDepositAccount = await VestingDepositAccount.new({from: admin});
        await this.vestingDepositAccount.init(this.token.address, controller, beneficiary);
    });

    it('should return token address, controller, and beneficary', async () => {
        (await this.vestingDepositAccount.token()).should.be.equal(this.token.address);
        (await this.vestingDepositAccount.controller()).should.be.equal(controller);
        (await this.vestingDepositAccount.beneficiary()).should.be.equal(beneficiary);
    });


    describe('reverts', async () => {

        it('when init called twice', async () => {
            await expectRevert(
                this.vestingDepositAccount.init(this.token.address, controller, beneficiary),
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
    });

});
