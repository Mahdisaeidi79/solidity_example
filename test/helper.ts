import { ethers } from 'hardhat';

// deploy contract function
async function deployContract(contractName: string, txData:object,...callData: any): Promise<any> {
  const factory = await ethers.getContractFactory(contractName);
  const contract = await factory.deploy(txData,...callData);
  await contract.deployed();
  return contract;
}

export { deployContract };