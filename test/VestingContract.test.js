const moment = require('moment');

const {BN, time, expectEvent, expectRevert, constants} = require('@openzeppelin/test-helpers');
const {latest} = time;

require('chai').should();

const VestingDepositAccount = artifacts.require('VestingDepositAccount');
const VestingContract = artifacts.require('VestingContractWithFixedTime');
const ActualVestingContract = artifacts.require('VestingContract');
const SyncToken = artifacts.require('SyncToken');

contract('VestingContract', function ([_, admin, random, beneficiary1, beneficiary2, beneficiary3]) {
    const DECIMALS = 18;
    const TEN_BILLION = new BN(10000000);
    const INITIAL_SUPPLY = TEN_BILLION.mul(new BN(10).pow(new BN(DECIMALS)));

    const TEN_THOUSAND_TOKENS = new BN(10000).mul(new BN(10).pow(new BN(DECIMALS)));
    const FIVE_THOUSAND_TOKENS = new BN(5000).mul(new BN(10).pow(new BN(DECIMALS)));
    const _3333_THOUSAND_TOKENS = new BN(3333).mul(new BN(10).pow(new BN(DECIMALS)));

    console.log('INITIAL_SUPPLY', INITIAL_SUPPLY.toString());
    console.log('TEN_THOUSAND_TOKENS', TEN_THOUSAND_TOKENS.toString());
    console.log('FIVE_THOUSAND_TOKENS', FIVE_THOUSAND_TOKENS.toString());
    console.log('_3333_THOUSAND_TOKENS', _3333_THOUSAND_TOKENS.toString());

    const PERIOD_ONE_DAY_IN_SECONDS = new BN('86400');

    const _100days = 100;
    const _7days = 7;
    const _10days = 10;

    beforeEach(async () => {
        this.token = await SyncToken.new(INITIAL_SUPPLY, admin, admin, {from: admin});

        // Assert the token is constructed correctly
        const creatorBalance = await this.token.balanceOf(admin);
        creatorBalance.should.be.bignumber.equal(INITIAL_SUPPLY);

        // Construct new vesting contract
        this.baseDepositAccount = await VestingDepositAccount.new({from: admin});
    });

    const createNewVestingContract = async ({_start, _end, _cliffDurationInSecs}) => {
        this.now = _start;
        this.vestingContract = await VestingContract.new(
            this.token.address,
            this.baseDepositAccount.address,
            _start,
            _end,
            _cliffDurationInSecs,
            {from: admin}
        );

        await this.vestingContract.fixTime(this.now);

        // Ensure vesting contract approved to move tokens
        await this.token.approve(this.vestingContract.address, INITIAL_SUPPLY, {from: admin});

        // Ensure allowance set for vesting contract
        const vestingAllowance = await this.token.allowance(admin, this.vestingContract.address);
        vestingAllowance.should.be.bignumber.equal(INITIAL_SUPPLY);
    };

    it('should return token and baseDepositAccount address', async () => {
        // Current time
        this.now = moment.unix(await latest()).unix().valueOf();

        // create schedule - starting in 1 day, going for 10 days
        await createNewVestingContract({
            _start: this.now,
            _end: new BN(this.now).add(new BN(_10days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
            _cliffDurationInSecs: 0
        });

        (await this.vestingContract.token()).should.be.equal(this.token.address);
        (await this.vestingContract.baseVestingDepositAccount()).should.be.equal(this.baseDepositAccount.address);
    });

    it('reverts when trying to create the contract with zero address token', async () => {
        await expectRevert.unspecified(VestingContract.new(constants.ZERO_ADDRESS, this.baseDepositAccount.address, 0, 0, 0, {from: admin}));
    });

    describe('reverts', async () => {
        beforeEach(async () => {
            // Current time
            this.now = moment.unix(await latest()).unix().valueOf();

            // create schedule - starting in 1 day, going for 10 days
            let start = moment.unix(await latest()).add(1, 'day').unix().valueOf();
            await createNewVestingContract({
                _start: start,
                _end: new BN(start).add(new BN(_10days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
                _cliffDurationInSecs: 0
            });

            // move time to start time
            this.now = start;
            await this.vestingContract.fixTime(this.now);
        });

        describe('createVestingSchedule() reverts when', async () => {
            it('specifying a zero address beneficiary', async () => {
                await expectRevert(
                    givenAVestingSchedule({
                        beneficiary: constants.ZERO_ADDRESS,
                        amount: TEN_THOUSAND_TOKENS,
                        from: admin,
                    }),
                    'Beneficiary cannot be empty'
                );
            });

            it('specifying a zero vesting amount', async () => {
                await expectRevert(
                    givenAVestingSchedule({
                        beneficiary: beneficiary1,
                        amount: 0,
                        from: admin,
                    }),
                    'Amount cannot be empty'
                );
            });

            it('trying to overwrite an inflight schedule', async () => {
                await givenAVestingSchedule({
                    beneficiary: beneficiary1,
                    amount: TEN_THOUSAND_TOKENS,
                    from: admin,
                });
                await expectRevert(
                    givenAVestingSchedule({
                        beneficiary: beneficiary1,
                        amount: TEN_THOUSAND_TOKENS,
                        from: admin,
                    }),
                    'Schedule already in flight'
                );
            });

            it('trying to update schedule beneficiary when not owner', async () => {
                await givenAVestingSchedule({
                    beneficiary: beneficiary1,
                    amount: TEN_THOUSAND_TOKENS,
                    from: admin,
                });
                await expectRevert(
                    this.vestingContract.updateScheduleBeneficiary(beneficiary1, beneficiary2, {from: beneficiary1}),
                    'VestingContract::updateScheduleBeneficiary: Only owner'
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
                await givenAVestingSchedule({
                    beneficiary: beneficiary1,
                    amount: TEN_THOUSAND_TOKENS,
                    from: admin,
                });

                // fast forward 15 days (past the end of the schedule so that all allowance is withdrawn)
                this._15DaysAfterScheduleStart = moment.unix(await latest()).add(15, 'day').unix().valueOf();
                await this.vestingContract.fixTime(this._15DaysAfterScheduleStart, {from: admin});

                await this.vestingContract.drawDown({from: beneficiary1});
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

                await expectRevert(
                    this.vestingContract.drawDown({from: beneficiary1}),
                    'No allowance left to withdraw'
                );
            });

            it.skip('the allowance for a particular second has been exceeded (two calls in the same block scenario)', async () => {
                this.now = moment.unix(await latest()).valueOf();

                await givenAVestingSchedule({
                    beneficiary: beneficiary1,
                    amount: TEN_THOUSAND_TOKENS,
                    from: admin,
                });

                // fast forward 8 days
                this._8DaysAfterScheduleStart = moment.unix(this.now).add(8, 'day').unix().valueOf();
                await this.vestingContract.fixTime(this._8DaysAfterScheduleStart, {from: admin});

                await this.vestingContract.drawDown({from: beneficiary1});
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.not.equal(TEN_THOUSAND_TOKENS);

                await expectRevert(
                    this.vestingContract.drawDown({from: beneficiary1}),
                    'No allowance left to withdraw'
                );
            });
        });
    });

    describe('single schedule - incomplete draw down', async () => {
        beforeEach(async () => {
            // Current time
            this.now = moment.unix(await latest()).unix().valueOf();

            // create schedule - starting in 1 day, going for 10 days
            let start = moment.unix(await latest()).add(1, 'day').unix().valueOf();
            await createNewVestingContract({
                _start: start,
                _end: new BN(start).add(new BN(_10days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
                _cliffDurationInSecs: 0
            });

            // move time to start time
            this.now = start;
            await this.vestingContract.fixTime(this.now);

            // setup schedule
            this.transaction = await givenAVestingSchedule({
                beneficiary: beneficiary1,
                amount: TEN_THOUSAND_TOKENS,
                from: admin,
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

        // FIXME should this be timeLastDrawn zero?
        it.skip('validateAvailableDrawDownAmount()', async () => {
            // move forward 1 day
            const _1DayInTheFuture = moment.unix(this.now).add(1, 'day').unix().valueOf();
            await this.vestingContract.fixTime(_1DayInTheFuture);

            await validateAvailableDrawDownAmount(beneficiary1, {
                amount: '999999999999999993600',
                timeLastDrawn: this.now.toString()
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
                const _amount = await this.vestingContract.availableDrawDownAmount(beneficiary1);
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

    describe('single schedule - future start date', async () => {
        beforeEach(async () => {
            // Current time
            this.now = moment.unix(await latest()).unix().valueOf();

            // create schedule - starting in 1 day, going for 10 days
            this.onyDayFromNow = moment.unix(await latest()).add(1, 'day').unix().valueOf();
            await createNewVestingContract({
                _start: this.onyDayFromNow,
                _end: new BN(this.onyDayFromNow).add(new BN(_7days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
                _cliffDurationInSecs: 0
            });

            // fixed to now
            await this.vestingContract.fixTime(this.now);

            await givenAVestingSchedule({
                beneficiary: beneficiary1,
                amount: FIVE_THOUSAND_TOKENS,
                from: admin,
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
            (await this.vestingContract.availableDrawDownAmount(beneficiary1)).should.be.bignumber.equal('0');
        });
    });

    describe('single schedule - starts now - full draw after end date', async () => {
        beforeEach(async () => {
            // Current time
            this.now = moment.unix(await latest()).unix().valueOf();

            // create schedule - starting in 1 day, going for 10 days
            await createNewVestingContract({
                _start: this.now,
                _end: new BN(this.now).add(new BN(_10days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
                _cliffDurationInSecs: 0
            });

            // fixed to now
            await this.vestingContract.fixTime(this.now);

            await givenAVestingSchedule({
                beneficiary: beneficiary1,
                amount: TEN_THOUSAND_TOKENS,
                from: admin,
            });

            // move to after
            this._11DaysAfterScheduleStart = moment.unix(this.now).add(11, 'day').unix().valueOf();
            await this.vestingContract.fixTime(this._11DaysAfterScheduleStart);
        });

        it('should draw down full amount in one call', async () => {
            (await this.vestingContract.tokenBalance({from: beneficiary1})).should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

            (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('0');

            await this.vestingContract.drawDown({from: beneficiary1});

            (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal(TEN_THOUSAND_TOKENS);

            (await this.vestingContract.tokenBalance()).should.be.bignumber.equal('0');
        });
    });

    describe('single schedule - future start - completes on time - attempts to withdraw after completed', async () => {
        beforeEach(async () => {
            // Current time
            this.now = moment.unix(await latest()).unix().valueOf();

            // create schedule - starting in 1 day, going for 10 days
            this.onyDayFromNow = moment.unix(await latest()).add(1, 'day').unix().valueOf();
            await createNewVestingContract({
                _start: this.now,
                _end: new BN(this.now).add(new BN(_100days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
                _cliffDurationInSecs: 0
            });

            // fixed to now
            await this.vestingContract.fixTime(this.now);

            this.transaction = await givenAVestingSchedule({
                beneficiary: beneficiary1,
                amount: _3333_THOUSAND_TOKENS,
                from: admin,
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

    describe('single schedule - update beneficary', async () => {
        beforeEach(async () => {
            // Current time
            this.now = moment.unix(await latest()).unix().valueOf();

            // create schedule - starting in 1 day, going for 10 days
            await createNewVestingContract({
                _start: this.now,
                _end: new BN(this.now).add(new BN(_10days).mul(PERIOD_ONE_DAY_IN_SECONDS)),
                _cliffDurationInSecs: 0
            });

            // fixed to now
            await this.vestingContract.fixTime(this.now);

            await givenAVestingSchedule({
                beneficiary: beneficiary1,
                amount: TEN_THOUSAND_TOKENS,
                from: admin,
            });
        });

        describe('after 6 days you can update the beneficiary', async () => {
            beforeEach(async () => {
                this._6DaysAfterScheduleStart =
                    moment.unix(this.now)
                        .add(6, 'day')
                        .add(1, 'second') // plus 1 second so the time has passed!
                        .unix().valueOf();
                await this.vestingContract.fixTime(this._6DaysAfterScheduleStart);

                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.equal('0');

                (await this.token.balanceOf(beneficiary2)).should.be.bignumber.equal('0');
            });

            it('should have draw down to original beneficiary and transferred', async () => {

                await this.vestingContract.updateScheduleBeneficiary(beneficiary1, beneficiary2, {from: admin});

                // original has been paid due tokens at point of update
                (await this.token.balanceOf(beneficiary1)).should.be.bignumber.gt(FIVE_THOUSAND_TOKENS);
                (await this.vestingContract.voided(beneficiary1)).should.be.equal(true);

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

    const givenAVestingSchedule = async ({beneficiary, amount, from}) => {
        return this.vestingContract.createVestingSchedule(
            beneficiary,
            amount,
            {from: from}
        );
    };

    const validateVestingScheduleForBeneficiary = async (beneficiary, expectations) => {
        const {_amount, _totalDrawn, _lastDrawnAt, _drawDownRate, _remainingBalance} = await this.vestingContract.vestingScheduleForBeneficiary(beneficiary);

        const scheduleRemainingBalance = await this.vestingContract.remainingBalance(beneficiary);

        _amount.should.be.bignumber.equal(expectations.amount);

        _totalDrawn.should.be.bignumber.equal(expectations.totalDrawn);

        _lastDrawnAt.should.be.bignumber.equal(expectations.lastDrawnAt);

        _drawDownRate.should.be.bignumber.equal(expectations.drawDownRate);

        _remainingBalance.should.be.bignumber.equal(expectations.remainingBalance);
        scheduleRemainingBalance.should.be.bignumber.equal(expectations.remainingBalance);
    };

    const validateAvailableDrawDownAmount = async (beneficiary, expectations) => {
        const _amount = await this.vestingContract.availableDrawDownAmount(beneficiary);
        const _timeLastDrawn = await this.vestingContract.lastDrawnAt(beneficiary);

        _amount.should.be.bignumber.equal(expectations.amount);
        _timeLastDrawn.should.be.bignumber.equal(expectations.timeLastDrawn);
    };

    const addDaysToTime = (unixTime, days) => {
        const NUM_SECONDS_IN_A_DAY = 86400;
        return (new BN(unixTime.toString()).add(new BN((days * NUM_SECONDS_IN_A_DAY).toString()))).toString();
    };
});
