import { baseSepolia } from 'viem/chains';
import BuyMyTimeABI from './BuyMyTimeABI';
import { useBuyMyTimeContract } from './useBuyMyTimeContract';

describe('useBuyMyTimeContract', () => {
  it('should return correct contract data', () => {
    const contract = useBuyMyTimeContract();
    expect(contract).toEqual({
      abi: BuyMyTimeABI,
      address: '0x1feE3dd0Dd2B9Ca3B9dc81c1eC6d46661809dae3',
      status: 'ready',
      supportedChains: [baseSepolia],
    });
  });
});
