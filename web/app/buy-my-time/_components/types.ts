import type { Address } from 'viem';

export type TimeSlotMemo = {
  numTimeSlots: bigint;
  message: string;
  time: bigint;
  userAddress?: string;
};
