import { baseSepolia } from 'viem/chains';
import BuyMyTimeABI from './BuyMyTimeABI';
import { useBuyMyTimeContract } from './useBuyMyTimeContract';

describe('useBuyMyTimeContract', () => {
  it('should return correct contract data', () => {
    const contract = useBuyMyTimeContract();
    expect(contract).toEqual({
      abi: BuyMyTimeABI,
      address: '0xcE0EBD0282e247553eb8fDdeE3281b5EC09ddD16',
      status: 'ready',
      supportedChains: [baseSepolia],
    });
  });
});
