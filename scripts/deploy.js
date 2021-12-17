/*
    Taken from https://hardhat.org/tutorial/deploying-to-a-live-network.html
*/

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const MislavCoinv3 = await ethers.getContractFactory("MislavCoinv3");
  const mislavCoinv3Instance = await MislavCoinv3.deploy("MislavCoinv3", "MCv3");
  const MislavCoinSupply = await ethers.getContractFactory("MislavCoinSupply");
  const mislavCoinSupplyInstance = await MislavCoinSupply.deploy();

  console.log("MislavCoinv3 address:", mislavCoinv3Instance.address);
  console.log("MislavCoinSupply address:", mislavCoinSupplyInstance.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
