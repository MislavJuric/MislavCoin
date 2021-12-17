const MislavCoinv3 = artifacts.require("MislavCoinv3");

// Traditional Truffle test
contract("MislavCoinv3", (accounts) => {
    it("Should return the name of the contract", async function () {
        const mislavCoinv3Instance = await MislavCoinv3.new("MislavCoin", "MC");
        assert.equal(await mislavCoinv3Instance.name(), "MislavCoin");
    });

    // TODO: More tests here?

    /*
    it("Should return the account balance", async function () {
        const mislavCoinv3Instance = await MislavCoinv3.new("MislavCoin", "MC");
        mislavCoinv3Instance._mint(accounts[0], 1000); // can't call _mint because it's an internal function
        mislavCoinv3Instance.transfer(accounts[1], 1000);
        assert.equal(await mislavCoinv3Instance.balanceOf(accounts[1]), 1000);
    });
    */
});
