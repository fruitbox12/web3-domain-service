const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("web3");
    await domainContract.deployed();
  
    console.log("Contract deployed to:", domainContract.address);
  
    let txn = await domainContract.register("test",  {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();
    console.log("Minted domain test.web3");
  
    txn = await domainContract.setRecord("test", "Am I a test or a AI??");
    await txn.wait();
    console.log("Set record for test.web3");
  
    const address = await domainContract.getAddress("test");
    console.log("Owner of domain test:", address);
  
    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
  }
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();