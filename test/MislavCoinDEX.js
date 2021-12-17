const MislavCoinDEX = artifacts.require("MislavCoinDEX");
const MislavCoinSupply = artifacts.require("MislavCoinSupply");

// Traditional Truffle test
contract("MislavCoinDEX", (accounts) => {
    it("Should buy 1000 tokens", async function () {
          const mislavCoinDEXInstance = await MislavCoinDEX.new();
          await mislavCoinDEXInstance.buy({value: 1000});
          const mislavCoinSupplyInstance = await MislavCoinSupply.at(await mislavCoinDEXInstance.getTokenAddress());
          assert.equal(await mislavCoinSupplyInstance.balanceOf(accounts[0]), 1000); // accounts[0] is the default sender
    });

    it("Should sell 500 tokens after buying 1000 of them", async function () {
          const mislavCoinDEXInstance = await MislavCoinDEX.new();
          await mislavCoinDEXInstance.buy({value: 1000});
          const mislavCoinSupplyInstance = await MislavCoinSupply.at(await mislavCoinDEXInstance.getTokenAddress());
          await mislavCoinSupplyInstance.approve(await mislavCoinDEXInstance.getAddress(), 1000);
          await mislavCoinDEXInstance.sell(500);
          assert.equal(await mislavCoinSupplyInstance.balanceOf(accounts[0]), 500); // accounts[0] is the default sender
    });
});
