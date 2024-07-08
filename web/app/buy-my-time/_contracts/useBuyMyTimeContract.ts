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
    address: '0x1feE3dd0Dd2B9Ca3B9dc81c1eC6d46661809dae3',
  },

  // ... more chains for this contract go here
});
