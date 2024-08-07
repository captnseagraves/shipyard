import { useMemo } from 'react';
import { useReadContract } from 'wagmi';
import { markStep } from '@/utils/analytics';
import { useBuyMyTimeContract } from '../_contracts/useBuyMyTimeContract';
import type { TimeSlotMemo } from '../_components/types';

/**
 * Hooks is abstracting away the logic of calling a read-only function on a contract.
 * offers a refetch function to refetch the data.
 * @returns The memos and a function to refetch them.
 */
function useOnchainTimeSlotMemos() {
  const contract = useBuyMyTimeContract();

  markStep('useReadContract.refetchMemos');
  const contractReadResult = useReadContract({
    address: contract.status === 'ready' ? contract.address : undefined,
    abi: contract.abi,
    functionName: 'getMemos',
    args: [BigInt(0), BigInt(25)], // TODO : Implement Paging
  });
  markStep('useReadContract.refetchMemos');

  return useMemo(
    () => ({
      memos:
        contractReadResult.status === 'success' ? (contractReadResult.data as TimeSlotMemo[]) : [],
      refetchMemos: contractReadResult.refetch,
    }),
    [contractReadResult],
  );
}

export default useOnchainTimeSlotMemos;
