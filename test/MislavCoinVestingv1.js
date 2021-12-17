const MislavCoinVestingv1 = artifacts.require("MislavCoinVestingv1");
const MislavCoinSupply = artifacts.require("MislavCoinSupply");

// Traditional Truffle test
contract("MislavCoinVestingv1", (accounts) => {
    it("Should give 1000 tokens for vesting to a beneficiary", async function () {
        const mislavCoinVestingInstance = await MislavCoinVestingv1.new();
        await mislavCoinVestingInstance.addBeneficiary(accounts[1], 1000);
        const mislavCoinSupplyInstance = await MislavCoinSupply.at(await mislavCoinVestingInstance.getTokenAddress());
        assert.equal(await mislavCoinSupplyInstance.allowance(await mislavCoinVestingInstance.getAddress(), accounts[1]), 1000); // accounts[0] is the default sender
    });

    it("Should throw an exception that I tried to release the tokens too early"); // TODO: write this
});
