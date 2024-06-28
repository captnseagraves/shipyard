import { baseSepolia } from 'viem/chains';
import { generateContractHook } from '@/hooks/contracts';
import BuyMyTimeABI from './BuyMyTimeABI';

/**
 * Returns contract data for the BuyMyTime contract.
 */
export const useBuyMyTimeContract = generateContractHook({
  abi: BuyMyTimeABI,
  [baseSepolia.id]: {
    chain: baseSepolia,
    address: '0xcE0EBD0282e247553eb8fDdeE3281b5EC09ddD16',
  },

  // ... more chains for this contract go here
});
