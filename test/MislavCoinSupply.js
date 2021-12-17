const MislavCoinSupply = artifacts.require("MislavCoinSupply");

// Traditional Truffle test
contract("MislavCoinSupply", (accounts) => {
    it("Should give 1000 ETH worth of token to the message sender", async function () {
          const mislavCoinSupplyInstance = await MislavCoinSupply.new();
          assert.equal(await mislavCoinSupplyInstance.balanceOf(accounts[0]), 1000 * 1000000000000000000); // accounts[0] is the default sender; TODO: fix this magic number
    });

    it("Should transfer 1000 tokens to another address", async function () {
          const mislavCoinSupplyInstance = await MislavCoinSupply.new();
          await mislavCoinSupplyInstance.transfer(accounts[1], 1000);
          assert.equal(await mislavCoinSupplyInstance.balanceOf(accounts[1]), 1000);
    });

      it("Aprrove 1000 tokens of allowance to another address", async function () {
          const mislavCoinSupplyInstance = await MislavCoinSupply.new();
          await mislavCoinSupplyInstance.approve(accounts[1], 1000);
          assert.equal(await mislavCoinSupplyInstance.allowance(accounts[0], accounts[1]), 1000);
      });

      // TODO: Figure out why the test below doesn't work properly
      /*
      it("Use 1000 tokens of allowance", async function () {
          const mislavCoinSupplyInstance = await MislavCoinSupply.new();
          await mislavCoinSupplyInstance.approve(accounts[1], 1000);
          await mislavCoinSupplyInstance.transferFrom(accounts[1], accounts[2], 1000);
          assert.equal(await mislavCoinSupplyInstance.balanceOf(accounts[2]), 1000);
      });
      */
});
