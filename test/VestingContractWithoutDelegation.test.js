const moment = require('moment');

const {BN, time, expectEvent, expectRevert, constants} = require('@openzeppelin/test-helpers');
const {latest} = time;

require('chai').should();

const VestingContract = artifacts.require('VestingContractWithoutDelegationFixedTime')
const ActualVestingContract = artifacts.require('VestingContractWithoutDelegation')
const SyncToken = artifacts.require('SyncToken')

contract('VestingContractWithoutDelegation', function ([_, admin, random, beneficiary1, beneficiary2, beneficiary3]) {
    const DECIMALS = 18;
    const TEN_BILLION = new BN(10000000);
    const FIFTY_BILLION = new BN(50000000000);
    const INITIAL_SUPPLY = TEN_BILLION.mul(new BN(10).pow(new BN(DECIMALS)));

    const TEN_THOUSAND_TOKENS = new BN(10000).mul(new BN(10).pow(new BN(DECIMALS)));
    const FIVE_THOUSAND_TOKENS = new BN(5000).mul(new BN(10).pow(new BN(DECIMALS)));
    const _3333_THOUSAND_TOKENS = new BN(3333).mul(new BN(10).pow(new BN(DECIMALS)));

    console.log('INITIAL_SUPPLY', INITIAL_SUPPLY.toString());
    console.log('TEN_THOUSAND_TOKENS', TEN_THOUSAND_TOKENS.toString());
    console.log('FIVE_THOUSAND_TOKENS', FIVE_THOUSAND_TOKENS.toString());
    console.log('_3333_THOUSAND_TOKENS', _3333_THOUSAND_TOKENS.toString());

    const _100days = 100;
    const _7days = 7;
    const _10days = 10;


    const PERIOD_ONE_DAY_IN_SECONDS = new BN('86400');

    const fromAdmin = {from: admin};
    const fromRandom = {from: random};

    beforeEach(async () => {
        this.token = await SyncToken.new(INITIAL_SUPPLY, admin, admin, fromAdmin);

        // Assert the token is constructed correctly
        const creatorBalance = await this.token.balanceOf(admin);
        creatorBalance.should.be.bignumber.equal(INITIAL_SUPPLY);


        this.now = moment.unix(await latest()).unix().valueOf();

        this.start = this.now;
        this.end = this.now + (_10days * parseInt(PERIOD_ONE_DAY_IN_SECONDS.toString()));
        this.cliffDuration = 0;

    // Construct new vesting contract
    this.vestingContract = await VestingContract.new(
      this.token.address,
      this.start,
      this.end,
      this.cliffDuration,
      fromAdmin
    );

    await this.vestingContract.fixTime(this.now);

        // Ensure vesting contract approved to move tokens
        await this.token.approve(this.vestingContract.address, INITIAL_SUPPLY, fromAdmin);

        // Ensure allowance set for vesting contract
        const vestingAllowance = await this.token.allowance(admin, this.vestingContract.address);
        vestingAllowance.should.be.bignumber.equal(INITIAL_SUPPLY);
    });

    it.skip('should return token address', async () => {
        const token = await this.vestingContract.token();
        token.should.be.equal(this.token.address);
    });

  it.skip('reverts when trying to create the contract with zero address token', async () => {
    await expectRevert.unspecified(VestingContract.new(constants.ZERO_ADDRESS, this.baseDepositAccount.address, fromAdmin))
  })

    describe('reverts', async () => {
        describe('createVestingSchedule() reverts when', async () => {
            it('specifying a zero address beneficiary', async () => {
                await expectRevert(
                    givenAVestingSchedule({
                        beneficiary: constants.ZERO_ADDRESS,
                        ...fromAdmin
                    }),
                    'Beneficiary cannot be empty'
                );
            });

            it('specifying a zero vesting amount', async () => {
                await expectRevert(
                    givenAVestingSchedule({
                        amount: 0,
                        ...fromAdmin
                    }),
                    'Amount cannot be empty'
                );
            });

            it('trying to overwrite an inflight schedule', async () => {
                await givenAVestingSchedule(fromAdmin);
                await expectRevert(
                    givenAVestingSchedule(fromAdmin),
                    'Schedule already in flight'
                );
            });
        });

        describe('drawDown() reverts when', async () => {
            it('no schedule is in flight', async () => {
                await expectRevert(
                    this.vestingContract.drawDown(),
                    'There is no schedule currently in flight'
                );
            });

            it('a beneficiary has no remaining balance', async () => {
                await givenAVestingSchedule(fromAdmin);

                // fast forward 15 days (past the end of the schedule so that all allowance is withdrawn)
                this._15DaysAfterScheduleStart = moment.unix(await latest()).add(15, 'day').unix().valueOf();
                await this.vestingContract.fixTime(this._15DaysAfterScheduleStart, fromAdmin);

                await this.vestingContract.drawDown({from: beneficiary1});
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

                await expectRevert(
                    this.vestingContract.drawDown({from: beneficiary1}),
                    'VestingContract::_drawDown: No allowance left to withdraw'
                );
            });

            it.skip('the allowance for a particular second has been exceeded (two calls in the same block scenario)', async () => {
                this.now = moment.unix(await latest()).valueOf();

                await this.vestingContract.createVestingScheduleConfig(
                    SCHEDULE_2_ID,
                    this.now,
                    _10days,
                    0,
                    fromAdmin
                );

                await givenAVestingSchedule({
                    scheduleConfigId: SCHEDULE_2_ID,
                    ...fromAdmin
                });

                // fast forward 8 days
                this._8DaysAfterScheduleStart = moment.unix(this.now).add(8, 'day').unix().valueOf();
                await this.vestingContract.fixTime(this._8DaysAfterScheduleStart, fromAdmin);

                await this.vestingContract.drawDown({from: beneficiary1});
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.not.equal(TEN_THOUSAND_TOKENS);

                await expectRevert(
                    this.vestingContract.drawDown({from: beneficiary1}),
                    'No allowance left to withdraw'
                );
            });
        });

    });

    describe.skip('single schedule - incomplete draw down', async () => {
        beforeEach(async () => {
            this.now = moment.unix(await latest()).add(1, 'day').unix().valueOf();

            await this.vestingContract.createVestingScheduleConfig(
                SCHEDULE_2_ID,
                this.now,
                _10days,
                0,
                fromAdmin
            );

            await this.vestingContract.fixTime(this.now);
            this.transaction = await givenAVestingSchedule({
                scheduleConfigId: SCHEDULE_2_ID,
                ...fromAdmin
            });
        });

        it('beneficiary 1 balance should equal vested tokens when called direct', async () => {
            const tokenBalance = await this.token.balanceOf(await this.vestingContract.depositAccountAddress({from: beneficiary1}));
            tokenBalance.should.be.bignumber.equal(TEN_THOUSAND_TOKENS);
        });

        it('vesting contract balance should equal vested tokens when proxied through', async () => {
            const tokenBalance = await this.vestingContract.tokenBalance({from: beneficiary1});
            tokenBalance.should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

            const tokenBalanceDirect = await this.token.balanceOf(await this.vestingContract.depositAccountAddress({from: beneficiary1}));
            tokenBalanceDirect.should.be.bignumber.equal(tokenBalance);
        });

        it('should be able to get my balance', async () => {
            const beneficiaryBalance = await this.vestingContract.remainingBalance(beneficiary1);
            beneficiaryBalance.should.be.bignumber.equal(TEN_THOUSAND_TOKENS);
        });

        it('correctly emits ScheduleCreated log', async () => {
            expectEvent(this.transaction, 'ScheduleCreated', {
                _beneficiary: beneficiary1,
                _amount: TEN_THOUSAND_TOKENS.toString(),
                //_start: this.now.toString(),
                //_duration: _10days.toString()
            });
        });

        it('vestingScheduleForBeneficiary()', async () => {
            const start = new BN(this.now.toString());
            const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
            const end = start.add(totalDuration);
            await validateVestingScheduleForBeneficiary(beneficiary1, {
                start,
                end,
                amount: TEN_THOUSAND_TOKENS,
                totalDrawn: '0',
                lastDrawnAt: '0',
                drawDownRate: TEN_THOUSAND_TOKENS.div(totalDuration),
                remainingBalance: TEN_THOUSAND_TOKENS
            });
        });

        it('lastDrawDown()', async () => {
            const lastDrawDown = await this.vestingContract.lastDrawnAt(beneficiary1);
            lastDrawDown.should.be.bignumber.equal('0');
        });

        it('PERIOD_ONE_DAY_IN_SECONDS()', async () => {
            const PERIOD_ONE_DAY_IN_SECONDS = await this.vestingContract.PERIOD_ONE_DAY_IN_SECONDS();
            PERIOD_ONE_DAY_IN_SECONDS.should.be.bignumber.equal('86400');
        });

        it('validateAvailableDrawDownAmount()', async () => {
            // move forward 1 day
            const _1DayInTheFuture = moment.unix(this.now).add(1, 'day').unix().valueOf();
            await this.vestingContract.fixTime(_1DayInTheFuture);

            await validateAvailableDrawDownAmount(beneficiary1, {
                amount: '999999999999999993600',
                timeLastDrawn: this.now.toString(),
                drawDownRate: '11574074074074074'
            });
        });

        describe('single drawn down', async () => {
            beforeEach(async () => {
                this._1DayInTheFuture = moment.unix(this.now).add(1, 'day').unix().valueOf();
                await this.vestingContract.fixTime(this._1DayInTheFuture);
                this.transaction = await this.vestingContract.drawDown({from: beneficiary1});
            });

            it('should emit DrawDown events', async () => {
                expectEvent(this.transaction, 'DrawDown', {
                    _beneficiary: beneficiary1,
                    _amount: '999999999999999993600',
                    _time: this._1DayInTheFuture.toString()
                });
            });

            it('should move tokens to beneficiary', async () => {
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('999999999999999993600');
            });

            it('should reduce validateAvailableDrawDownAmount()', async () => {
                const {_amount} = await this.vestingContract.availableDrawDownAmount(beneficiary1);
                _amount.should.be.bignumber.equal('0');
            });

            it('should update vestingScheduleForBeneficiary()', async () => {
                const expectedTotalDrawn = new BN('999999999999999993600');

                const start = new BN(this.now.toString());
                const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                const end = start.add(totalDuration);
                await validateVestingScheduleForBeneficiary(beneficiary1, {
                    start,
                    end,
                    amount: TEN_THOUSAND_TOKENS,
                    totalDrawn: expectedTotalDrawn,
                    lastDrawnAt: this._1DayInTheFuture.toString(),
                    drawDownRate: TEN_THOUSAND_TOKENS.div(totalDuration),
                    remainingBalance: TEN_THOUSAND_TOKENS.sub(expectedTotalDrawn)
                });
            });
        });

        describe('completes drawn down in several attempts', async () => {
            describe('after 1 day', async () => {
                beforeEach(async () => {
                    this._1DayAfterScheduleStart = moment.unix(this.now).add(1, 'day').unix().valueOf();
                    this.expectedTotalDrawnAfter1Day = new BN('999999999999999993600');
                    await this.vestingContract.fixTime(this._1DayAfterScheduleStart);
                    this.transaction = await this.vestingContract.drawDown({from: beneficiary1});
                });

                it('some tokens issued', async () => {
                    const start = new BN(this.now.toString());
                    const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const end = start.add(totalDuration);
                    await validateVestingScheduleForBeneficiary(beneficiary1, {
                        start,
                        end,
                        amount: TEN_THOUSAND_TOKENS,
                        totalDrawn: this.expectedTotalDrawnAfter1Day,
                        lastDrawnAt: this._1DayAfterScheduleStart.toString(),
                        drawDownRate: TEN_THOUSAND_TOKENS.div(totalDuration),
                        remainingBalance: TEN_THOUSAND_TOKENS.sub(this.expectedTotalDrawnAfter1Day)
                    });

                    await validateAvailableDrawDownAmount(beneficiary1, {
                        amount: '0', // no more left ot draw down
                        timeLastDrawn: this._1DayAfterScheduleStart.toString(),
                        drawDownRate: '11574074074074074'
                    });

                    (await this.token.balanceOf(beneficiary1))
                        .should.be.bignumber.equal(this.expectedTotalDrawnAfter1Day);

                    (await this.token.balanceOf(await this.vestingContract.depositAccountAddress({from: beneficiary1})))
                        .should.be.bignumber.equal(TEN_THOUSAND_TOKENS.sub(this.expectedTotalDrawnAfter1Day));

                    (await this.vestingContract.remainingBalance(beneficiary1))
                        .should.be.bignumber.equal(TEN_THOUSAND_TOKENS.sub(this.expectedTotalDrawnAfter1Day));

                    expectEvent(this.transaction, 'DrawDown', {
                        _beneficiary: beneficiary1,
                        _amount: this.expectedTotalDrawnAfter1Day,
                        _time: this._1DayAfterScheduleStart.toString()
                    });
                });

                describe('after 5 day - half tokens issues', async () => {
                    beforeEach(async () => {
                        this._5DaysAfterScheduleStart = moment.unix(this.now).add(5, 'day').unix().valueOf();
                        await this.vestingContract.fixTime(this._5DaysAfterScheduleStart);
                        this.transaction = await this.vestingContract.drawDown({from: beneficiary1});
                    });

                    it('more tokens issued', async () => {
                        const expectedTotalDrawnAfter5Day = this.expectedTotalDrawnAfter1Day.mul(new BN('5'));

                        const start = new BN(this.now.toString());
                        const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                        const end = start.add(totalDuration);
                        await validateVestingScheduleForBeneficiary(beneficiary1, {
                            start,
                            end,
                            amount: TEN_THOUSAND_TOKENS,
                            totalDrawn: expectedTotalDrawnAfter5Day.toString(),
                            lastDrawnAt: this._5DaysAfterScheduleStart.toString(),
                            drawDownRate: TEN_THOUSAND_TOKENS.div(totalDuration),
                            remainingBalance: TEN_THOUSAND_TOKENS.sub(expectedTotalDrawnAfter5Day)
                        });

                        await validateAvailableDrawDownAmount(beneficiary1, {
                            amount: '0', // no more left ot draw down
                            timeLastDrawn: this._5DaysAfterScheduleStart.toString(),
                            drawDownRate: '11574074074074074'
                        });

                        (await this.token.balanceOf(beneficiary1))
                            .should.be.bignumber.equal(expectedTotalDrawnAfter5Day);

                        (await this.token.balanceOf(await this.vestingContract.depositAccountAddress({from: beneficiary1})))
                            .should.be.bignumber.equal(TEN_THOUSAND_TOKENS.sub(expectedTotalDrawnAfter5Day));

                        (await this.vestingContract.remainingBalance(beneficiary1))
                            .should.be.bignumber.equal(TEN_THOUSAND_TOKENS.sub(expectedTotalDrawnAfter5Day));

                        expectEvent(this.transaction, 'DrawDown', {
                            _beneficiary: beneficiary1,
                            _amount: this.expectedTotalDrawnAfter1Day.mul(new BN('4')),
                            _time: this._5DaysAfterScheduleStart.toString()
                        });
                    });

                    describe('after 11 days - over schedule - all remaining tokens issues', async () => {
                        beforeEach(async () => {
                            this._11DaysAfterScheduleStart = moment.unix(this.now).add(11, 'day').unix().valueOf();
                            await this.vestingContract.fixTime(this._11DaysAfterScheduleStart);
                            this.transaction = await this.vestingContract.drawDown({from: beneficiary1});
                        });

                        it('all tokens issued', async () => {
                            const start = new BN(this.now.toString());
                            const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                            const end = start.add(totalDuration);
                            await validateVestingScheduleForBeneficiary(beneficiary1, {
                                start,
                                end,
                                amount: TEN_THOUSAND_TOKENS,
                                totalDrawn: TEN_THOUSAND_TOKENS,
                                lastDrawnAt: this._11DaysAfterScheduleStart.toString(),
                                drawDownRate: TEN_THOUSAND_TOKENS.div(totalDuration),
                                remainingBalance: '0'
                            });

                            await validateAvailableDrawDownAmount(beneficiary1, {
                                amount: '0', // no more left ot draw down
                                timeLastDrawn: this._11DaysAfterScheduleStart.toString(),
                                drawDownRate: '0' // no more left ot draw down
                            });

                            (await this.token.balanceOf(beneficiary1))
                                .should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

                            (await this.token.balanceOf(this.vestingContract.address))
                                .should.be.bignumber.equal('0');

                            (await this.vestingContract.remainingBalance(beneficiary1))
                                .should.be.bignumber.equal('0');

                            expectEvent(this.transaction, 'DrawDown', {
                                _beneficiary: beneficiary1,
                                _amount: TEN_THOUSAND_TOKENS.sub(this.expectedTotalDrawnAfter1Day.mul(new BN('5'))),
                                _time: this._11DaysAfterScheduleStart.toString()
                            });
                        });
                    });
                });
            });
        });
    });

    describe.skip('single schedule - future start date', async () => {
        beforeEach(async () => {
            this.now = await latest();
            this.onyDayFromNow = moment.unix(this.now).add(1, 'days').unix().valueOf();

            await this.vestingContract.createVestingScheduleConfig(
                SCHEDULE_2_ID,
                this.onyDayFromNow,
                _7days,
                0,
                fromAdmin
            );

            await givenAVestingSchedule({
                scheduleConfigId: SCHEDULE_2_ID,
                amount: FIVE_THOUSAND_TOKENS,
                ...fromAdmin
            });
        });

        it('lastDrawnAt()', async () => {
            const lastDrawDown = await this.vestingContract.lastDrawnAt(beneficiary1);
            lastDrawDown.should.be.bignumber.equal('0');
        });

        it('vestingScheduleForBeneficiary()', async () => {
            const start = new BN(this.onyDayFromNow.toString());
            const totalDuration = new BN(`${_7days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
            const end = start.add(totalDuration);
            await validateVestingScheduleForBeneficiary(beneficiary1, {
                start,
                end,
                amount: FIVE_THOUSAND_TOKENS,
                totalDrawn: '0',
                lastDrawnAt: '0',
                drawDownRate: FIVE_THOUSAND_TOKENS.div(totalDuration),
                remainingBalance: FIVE_THOUSAND_TOKENS
            });
        });

        it('remainingBalance()', async () => {
            const remainingBalance = await this.vestingContract.remainingBalance(beneficiary1);
            remainingBalance.should.be.bignumber.equal('5000000000000000000000');
        });

        it('validateAvailableDrawDownAmount() is zero as not started yet', async () => {
            await expectRevert(
                this.vestingContract.availableDrawDownAmount(beneficiary1),
                'Schedule not started'
            );
        });
    });

    describe('single schedule - starts now - full draw after end date', async () => {
        beforeEach(async () => {
            this.transaction = await givenAVestingSchedule({
                ...fromAdmin
            });

            this._11DaysAfterScheduleStart = moment.unix(this.now).add(11, 'day').unix().valueOf();
            await this.vestingContract.fixTime(this._11DaysAfterScheduleStart);
        });

        it('should draw down full amount in one call', async () => {
            (await this.vestingContract.tokenBalance({from: beneficiary1})).should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

            (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('0');

            await this.vestingContract.drawDown({from: beneficiary1});

            (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

            (await this.vestingContract.tokenBalance({from: beneficiary1})).should.be.bignumber.equal('0');
        });
    });

    describe.skip('single schedule - future start - completes on time - attempts to withdraw after completed', async () => {
        beforeEach(async () => {
            this.now = moment.unix(await latest()).unix().valueOf();

            await this.vestingContract.createVestingScheduleConfig(
                SCHEDULE_2_ID,
                this.now,
                _100days,
                0,
                fromAdmin
            );

            this.transaction = await givenAVestingSchedule({
                scheduleConfigId: SCHEDULE_2_ID,
                ...fromAdmin,
                beneficiary: beneficiary1,
                amount: _3333_THOUSAND_TOKENS
            });
            await this.vestingContract.fixTime(this.now);
        });

        describe('After all time has passed and all tokens claimed', async () => {
            beforeEach(async () => {
                this._100DaysAfterScheduleStart =
                    moment.unix(this.now)
                        .add(100, 'day')
                        .add(1, 'second') // plus 1 second so the time has passed!
                        .unix().valueOf();
                await this.vestingContract.fixTime(this._100DaysAfterScheduleStart);

                (await this.vestingContract.tokenBalance({from: beneficiary1})).should.be.bignumber.equal(_3333_THOUSAND_TOKENS);

                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('0');

                await this.vestingContract.drawDown({from: beneficiary1});
            });

            it('mo more tokens left to claim', async () => {
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(_3333_THOUSAND_TOKENS);

                (await this.vestingContract.tokenBalance()).should.be.bignumber.equal('0');
            });

            it('draw down rates show correct values', async () => {
                const totalDuration = new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);

                await validateVestingScheduleForBeneficiary(beneficiary1, {
                    start: this.now.toString(),
                    end: addDaysToTime(this.now, 100),
                    amount: _3333_THOUSAND_TOKENS,
                    totalDrawn: _3333_THOUSAND_TOKENS,
                    lastDrawnAt: this._100DaysAfterScheduleStart.toString(),
                    drawDownRate: _3333_THOUSAND_TOKENS.div(totalDuration),
                    remainingBalance: '0'
                });

                await validateAvailableDrawDownAmount(beneficiary1, {
                    amount: '0', // no more left ot draw down
                    timeLastDrawn: this._100DaysAfterScheduleStart.toString(),
                    drawDownRate: '0' // no more left ot draw down
                });
            });

            it('no further tokens can be drawn down', async () => {
                await expectRevert(
                    this.vestingContract.drawDown({from: beneficiary1}),
                    'No allowance left to withdraw'
                );
            });
        });
    });

    describe.skip('single schedule - update beneficary', async () => {
        beforeEach(async () => {
            this.now = moment.unix(await latest()).unix().valueOf();

            await givenAVestingSchedule(fromAdmin);
            await this.vestingContract.fixTime(this.now);
        });

        describe('after 5 days you can update the beneficiary', async () => {
            beforeEach(async () => {
                this._10DaysAfterScheduleStart =
                    moment.unix(this.now)
                        .add(6, 'day')
                        .add(1, 'second') // plus 1 second so the time has passed!
                        .unix().valueOf();
                await this.vestingContract.fixTime(this._10DaysAfterScheduleStart);

                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('0');

                (await this.token.balanceOf(beneficiary2)).should.be.bignumber.equal('0');


            });

            it('should have draw down to original beneficiary and transferred', async () => {

                await this.vestingContract.updateScheduleBeneficiary(beneficiary1, beneficiary2, fromAdmin);

                // original has been paid due tokens at point of update
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.gt(FIVE_THOUSAND_TOKENS);

                const amountDrawn = await this.vestingContract.totalDrawn(beneficiary1);

                // recorded the drawn amount
                amountDrawn.should.be.bignumber.gt(FIVE_THOUSAND_TOKENS);

                const {_amount, _totalDrawn, _lastDrawnAt} = await this.vestingContract.vestingScheduleForBeneficiary(beneficiary2);
                _amount.should.be.bignumber.lt(FIVE_THOUSAND_TOKENS);
                (_totalDrawn).should.be.bignumber.equal('0');
                (_lastDrawnAt).should.be.bignumber.equal('0');
            });
        });
    });

    describe.skip('multiple schedules', async () => {
        beforeEach(async () => {
            this.now = moment.unix(await latest()).unix().valueOf();

            await this.vestingContract.createVestingScheduleConfig(
                SCHEDULE_2_ID,
                this.now,
                _10days,
                0,
                fromAdmin
            );

            await givenAVestingSchedule({
                scheduleConfigId: SCHEDULE_2_ID,
                ...fromAdmin,
                beneficiary: beneficiary1,
                amount: _3333_THOUSAND_TOKENS
            });

            this._1DayInTheFuture = moment.unix(this.now).add(1, 'day').unix().valueOf();

            await this.vestingContract.createVestingScheduleConfig(
                SCHEDULE_3_ID,
                this._1DayInTheFuture,
                _100days,
                0,
                fromAdmin
            );

            await givenAVestingSchedule({
                scheduleConfigId: SCHEDULE_3_ID,
                ...fromAdmin,
                beneficiary: beneficiary2,
                amount: TEN_THOUSAND_TOKENS
            });

            this._3DayInTheFuture = moment.unix(this.now).add(3, 'day').unix().valueOf();

            await this.vestingContract.createVestingScheduleConfig(
                SCHEDULE_4_ID,
                this._3DayInTheFuture,
                _7days,
                0,
                fromAdmin
            );

            await givenAVestingSchedule({
                scheduleConfigId: SCHEDULE_4_ID,
                ...fromAdmin,
                beneficiary: beneficiary3,
                amount: FIVE_THOUSAND_TOKENS
            });
            await this.vestingContract.fixTime(this.now);
        });

        it('schedule 1 setup correctly', async () => {
            const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);

            await validateVestingScheduleForBeneficiary(beneficiary1, {
                start: this.now.toString(),
                end: moment.unix(this.now).add(_10days, 'day').unix().valueOf().toString(),
                amount: _3333_THOUSAND_TOKENS,
                totalDrawn: '0',
                lastDrawnAt: '',
                drawDownRate: _3333_THOUSAND_TOKENS.div(totalDuration),
                remainingBalance: _3333_THOUSAND_TOKENS
            });

            await validateAvailableDrawDownAmount(beneficiary1, {
                amount: '0',
                timeLastDrawn: this.now.toString(), // defaults to start date if not drawn down anything
                drawDownRate: _3333_THOUSAND_TOKENS.div(totalDuration)
            });

            (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('0');
        });

        it('schedule 2 setup correctly', async () => {
            const totalDuration = new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);

            await validateVestingScheduleForBeneficiary(beneficiary2, {
                start: this._1DayInTheFuture.toString(),
                end: addDaysToTime(this._1DayInTheFuture, 100),
                amount: TEN_THOUSAND_TOKENS,
                totalDrawn: '0',
                lastDrawnAt: '',
                drawDownRate: TEN_THOUSAND_TOKENS.div(totalDuration),
                remainingBalance: TEN_THOUSAND_TOKENS
            });

            // reverts as not started yet
            await expectRevert(
                this.vestingContract.availableDrawDownAmount(beneficiary2),
                'Schedule not started'
            );

            (await this.token.balanceOf(beneficiary2)).should.be.bignumber.equal('0');
        });

        it('schedule 3 setup correctly', async () => {
            const totalDuration = new BN(`${_7days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);

            await validateVestingScheduleForBeneficiary(beneficiary3, {
                start: this._3DayInTheFuture.toString(),
                end: moment.unix(this._3DayInTheFuture).add(_7days, 'day').unix().valueOf().toString(),
                amount: FIVE_THOUSAND_TOKENS,
                totalDrawn: '0',
                lastDrawnAt: '',
                drawDownRate: FIVE_THOUSAND_TOKENS.div(totalDuration),
                remainingBalance: FIVE_THOUSAND_TOKENS
            });

            // reverts as not started yet
            await expectRevert(
                this.vestingContract.availableDrawDownAmount(beneficiary3),
                'Schedule not started'
            );

            (await this.token.balanceOf(beneficiary3)).should.be.bignumber.equal('0');
        });

        describe('2 days in the future', async () => {
            beforeEach(async () => {
                this._2DaysInTheFuture = moment.unix(this.now).add(2, 'days').unix().valueOf();
                await this.vestingContract.fixTime(this._2DaysInTheFuture);
            });

            describe('schedule 1 & 2 can be drawn down', async () => {
                beforeEach(async () => {
                    await this.vestingContract.drawDown({from: beneficiary1});
                    await this.vestingContract.drawDown({from: beneficiary2});
                });

                it('beneficiary 1 has valid number of issued tokens', async () => {
                    const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const timePassed = new BN('2').mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const lastDrawnAt = this._2DaysInTheFuture.toString();
                    const drawDownRate = _3333_THOUSAND_TOKENS.div(totalDuration);
                    const totalDrawn = drawDownRate.mul(new BN(timePassed));

                    // Check beneficiary schedule correct
                    await validateVestingScheduleForBeneficiary(beneficiary1, {
                        start: this.now.toString(),
                        end: moment.unix(this.now).add(_10days, 'day').unix().valueOf().toString(),
                        amount: _3333_THOUSAND_TOKENS,
                        totalDrawn: totalDrawn,
                        lastDrawnAt: lastDrawnAt,
                        drawDownRate: drawDownRate,
                        remainingBalance: _3333_THOUSAND_TOKENS.sub(
                            totalDrawn
                        )
                    });

                    // Check beneficiary balance correct
                    (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(totalDrawn);
                });

                it('beneficiary 2 has valid number of issued tokens', async () => {
                    const totalDuration = new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const timePassed = new BN('1').mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const lastDrawnAt = this._2DaysInTheFuture.toString();
                    const drawDownRate = TEN_THOUSAND_TOKENS.div(totalDuration);
                    const totalDrawn = drawDownRate.mul(new BN(timePassed));

                    // Check beneficiary schedule correct
                    await validateVestingScheduleForBeneficiary(beneficiary2, {
                        start: this._1DayInTheFuture.toString(),
                        end: addDaysToTime(this._1DayInTheFuture, 100),
                        amount: TEN_THOUSAND_TOKENS,
                        totalDrawn: totalDrawn,
                        lastDrawnAt: lastDrawnAt,
                        drawDownRate: drawDownRate,
                        remainingBalance: TEN_THOUSAND_TOKENS.sub(
                            totalDrawn
                        )
                    });

                    // Check beneficiary balance correct
                    (await this.token.balanceOf(beneficiary2)).should.be.bignumber.equal(totalDrawn);
                });

                it('vesting contract balances correctly marry up', async () => {
                    const schedule1DrawDown = _3333_THOUSAND_TOKENS
                        .div(
                            new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS) // total duration
                        ).mul(
                            new BN('2').mul(PERIOD_ONE_DAY_IN_SECONDS) // time passed
                        );

                    const schedule2DrawDown = TEN_THOUSAND_TOKENS
                        .div(
                            new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS) // total duration
                        ).mul(
                            new BN('1').mul(PERIOD_ONE_DAY_IN_SECONDS) // time passed
                        );

                    const beneficiary1RemainingBalance = await this.vestingContract.tokenBalance({from: beneficiary1});
                    beneficiary1RemainingBalance.should.be.bignumber.equal(_3333_THOUSAND_TOKENS.sub(schedule1DrawDown));

                    const beneficiary2RemainingBalance = await this.vestingContract.tokenBalance({from: beneficiary2});
                    beneficiary2RemainingBalance.should.be.bignumber.equal(TEN_THOUSAND_TOKENS.sub(schedule2DrawDown));
                });
            });

            describe('11 days in the future', async () => {
                beforeEach(async () => {
                    this._11DaysInTheFuture = moment.unix(this.now).add(11, 'days').unix().valueOf();
                    await this.vestingContract.fixTime(this._11DaysInTheFuture);
                });

                beforeEach(async () => {
                    await this.vestingContract.drawDown({from: beneficiary1});
                    await this.vestingContract.drawDown({from: beneficiary2});
                    await this.vestingContract.drawDown({from: beneficiary3});
                });

                it('beneficiary 1 drawn down complete', async () => {
                    const totalDuration = new BN(`${_10days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);

                    // Check beneficiary schedule correct
                    await validateVestingScheduleForBeneficiary(beneficiary1, {
                        start: this.now.toString(),
                        end: moment.unix(this.now).add(_10days, 'day').unix().valueOf().toString(),
                        amount: _3333_THOUSAND_TOKENS,
                        totalDrawn: _3333_THOUSAND_TOKENS,
                        lastDrawnAt: this._11DaysInTheFuture.toString(),
                        drawDownRate: _3333_THOUSAND_TOKENS.div(totalDuration),
                        remainingBalance: '0'
                    });

                    // Check beneficiary balance correct
                    (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(_3333_THOUSAND_TOKENS);
                });

                it('beneficiary 2 in flight', async () => {
                    const totalDuration = new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const timePassed = new BN('10').mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const drawDownRate = TEN_THOUSAND_TOKENS.div(totalDuration);
                    const totalDrawn = drawDownRate.mul(new BN(timePassed));

                    // Check beneficiary schedule correct
                    await validateVestingScheduleForBeneficiary(beneficiary2, {
                        start: this._1DayInTheFuture.toString(),
                        end: addDaysToTime(this._1DayInTheFuture, 100),
                        amount: TEN_THOUSAND_TOKENS,
                        totalDrawn: totalDrawn,
                        lastDrawnAt: this._11DaysInTheFuture.toString(),
                        drawDownRate: drawDownRate,
                        remainingBalance: TEN_THOUSAND_TOKENS.sub(
                            totalDrawn
                        )
                    });

                    // Check beneficiary balance correct
                    (await this.token.balanceOf(beneficiary2)).should.be.bignumber.equal(totalDrawn);
                });

                it('beneficiary 3 drawn down complete', async () => {
                    const totalDuration = new BN(`${_7days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);

                    // Check beneficiary schedule correct
                    await validateVestingScheduleForBeneficiary(beneficiary3, {
                        start: this._3DayInTheFuture.toString(),
                        end: moment.unix(this._3DayInTheFuture).add(_7days, 'day').unix().valueOf().toString(),
                        amount: FIVE_THOUSAND_TOKENS,
                        totalDrawn: FIVE_THOUSAND_TOKENS,
                        lastDrawnAt: this._11DaysInTheFuture.toString(),
                        drawDownRate: FIVE_THOUSAND_TOKENS.div(totalDuration),
                        remainingBalance: '0'
                    });

                    // Check beneficiary balance correct
                    (await this.token.balanceOf(beneficiary3)).should.be.bignumber.equal(FIVE_THOUSAND_TOKENS);
                });

                it('vesting contract balances correctly marry up', async () => {
                    const schedule2DrawDown = TEN_THOUSAND_TOKENS.div(
                        new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS) // total drawn down
                    ).mul(
                        new BN('10').mul(PERIOD_ONE_DAY_IN_SECONDS) // time passed
                    );

                    const beneficiary2RemainingBalance = await this.vestingContract.tokenBalance({from: beneficiary2});
                    beneficiary2RemainingBalance.should.be.bignumber.equal(TEN_THOUSAND_TOKENS.sub(schedule2DrawDown));
                });

                it('beneficiary 1 cannot drawn down anymore', async () => {
                    await expectRevert(
                        this.vestingContract.drawDown({from: beneficiary1}),
                        'No allowance left to withdraw'
                    );
                    (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(_3333_THOUSAND_TOKENS);
                });

                it('beneficiary 2 has remaining balance', async () => {
                    const totalDuration = new BN(`${_100days}`).mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const timePassed = new BN('10').mul(PERIOD_ONE_DAY_IN_SECONDS);
                    const drawDownRate = TEN_THOUSAND_TOKENS.div(totalDuration);
                    const totalDrawn = drawDownRate.mul(new BN(timePassed));

                    const scheduleRemainingBalance = await this.vestingContract.remainingBalance(beneficiary2);
                    scheduleRemainingBalance.should.be.bignumber.eq(TEN_THOUSAND_TOKENS.sub(
                        totalDrawn
                    ));

                    await validateAvailableDrawDownAmount(beneficiary2, {
                        amount: '0', // no more left to draw dome immediately
                        timeLastDrawn: this._11DaysInTheFuture.toString(),
                        drawDownRate: drawDownRate
                    });
                });

                it('beneficiary 3 cannot drawn down anymore', async () => {
                    await expectRevert(
                        this.vestingContract.drawDown({from: beneficiary3}),
                        'No allowance left to withdraw'
                    );
                    (await this.token.balanceOf(beneficiary3)).should.be.bignumber.equal(FIVE_THOUSAND_TOKENS);
                });
            });
        });
    });

  describe.skip('VestingContract', async () => {
    beforeEach(async () => {
      this.vestingContract = await ActualVestingContract.new(this.token.address, this.baseDepositAccount.address, fromAdmin)
    })

        it('returns zero for empty vesting schedule', async () => {
            const {_amount, _timeLastDrawn, _drawDownRate} = await this.vestingContract.availableDrawDownAmount(beneficiary1);
            _amount.should.be.bignumber.equal('0');
            _timeLastDrawn.should.be.bignumber.equal('0');
            _drawDownRate.should.be.bignumber.equal('0');
        });
    });

    const generateDefaultVestingSchedule = async () => {
        return {
            beneficiary: beneficiary1,
            amount: TEN_THOUSAND_TOKENS
        };
    };

    const applyOptions = (options, object) => {
        if (!options) return object;
        Object.keys(options).forEach(key => {
            object[key] = options[key];
        });
        return object;
    };

    const givenAVestingSchedule = async (options) => {
        const defaultVestingSchedule = await generateDefaultVestingSchedule();
        const {beneficiary, amount} = applyOptions(options, defaultVestingSchedule);
        return this.vestingContract.createVestingSchedule(
            beneficiary,
            amount,
            {from: options.from}
        );
    };

    const validateVestingScheduleForBeneficiary = async (beneficiary, expectations) => {
        const {_scheduleConfigId, _amount, _totalDrawn, _lastDrawnAt, _drawDownRate, _remainingBalance} = await this.vestingContract.vestingScheduleForBeneficiary(beneficiary);

        const scheduleRemainingBalance = await this.vestingContract.remainingBalance(beneficiary);

        _amount.should.be.bignumber.equal(expectations.amount);

        _totalDrawn.should.be.bignumber.equal(expectations.totalDrawn);

        _lastDrawnAt.should.be.bignumber.equal(expectations.lastDrawnAt);

        _drawDownRate.should.be.bignumber.equal(expectations.drawDownRate);

        _remainingBalance.should.be.bignumber.equal(expectations.remainingBalance);
        scheduleRemainingBalance.should.be.bignumber.equal(expectations.remainingBalance);
    };

    const validateAvailableDrawDownAmount = async (beneficiary, expectations) => {
        const {_amount, _timeLastDrawn, _drawDownRate} = await this.vestingContract.availableDrawDownAmount(beneficiary);

        _amount.should.be.bignumber.equal(expectations.amount);
        _timeLastDrawn.should.be.bignumber.equal(expectations.timeLastDrawn);
        _drawDownRate.should.be.bignumber.equal(expectations.drawDownRate);
    };

    const addDaysToTime = (unixTime, days) => {
        const NUM_SECONDS_IN_A_DAY = 86400;
        return (new BN(unixTime.toString()).add(new BN((days * NUM_SECONDS_IN_A_DAY).toString()))).toString();
    };
});
