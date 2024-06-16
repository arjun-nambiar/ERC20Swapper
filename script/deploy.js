require("@nomicfoundation/hardhat-ethers");
async function main() {

  const owner = "0x962422fF5a465bFBba8C8D164927B1dDfbec727c";
  const wethAddress = "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9";
  const routerAddres = "0x86dcd3293C53Cf8EFd7303B57beb2a3F671dDE98"


  const ERC20Swapper = await ethers.deployContract("ERC20Swapper", [
    routerAddres,
    wethAddress
  ]);
  await ERC20Swapper.waitForDeployment();

  console.log(`ERC20Swapper deployed to ${ERC20Swapper.target}`);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
