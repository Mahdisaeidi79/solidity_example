import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { utils } from 'ethers';
import { ethers } from 'hardhat';
import { deployContract } from './helper';

describe('transfer', () => {
    let transfer: any;
    const contractValue = utils.parseEther("10");
    const transferValue = utils.parseEther("1");
    let owner: SignerWithAddress;
    let addr1: SignerWithAddress;

    beforeEach(async () => {
        // deploy contract
        transfer = await deployContract('Transfer', { value: contractValue });
        [owner, addr1] = await ethers.getSigners();
    });

    it('is transfer execute', async () => {
        await transfer.transferFrom(owner.address, addr1.address, transferValue);
        const balance = await transfer.balanceOf(addr1.address);
        expect(balance).to.eq(transferValue);
        expect(await transfer.balanceOf(owner.address)).to.eq(contractValue.sub(transferValue));
    })
})