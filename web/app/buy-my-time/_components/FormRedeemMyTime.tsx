import { useCallback } from 'react';
import { parseEther } from 'viem';
import Button from '@/components/Button/Button';
import { useBuyMyTimeContract } from '../_contracts/useBuyMyTimeContract';
import useFields from '../_hooks/useFields';
import ContractAlert from './ContractAlert';
import TransactionSteps from './TransactionSteps';
import useSmartContractForms from './useSmartContractForms';

const GAS_COST = 0.0001;

const initFields = {
  name: '',
  twitterHandle: '',
  message: '',
  coffeeCount: 1,
};

type Fields = {
  name: string;
  twitterHandle: string;
  coffeeCount: number;
  message: string;
};

function FormBuyCoffee() {
  const contract = useBuyMyTimeContract();

  const { fields, setField, resetFields } = useFields<Fields>(initFields);

  const reset = useCallback(async () => {
    resetFields();
  }, [resetFields]);

  const { disabled, transactionState, resetContractForms, onSubmitTransaction } =
    useSmartContractForms({
      gasFee: parseEther(String(GAS_COST * fields.coffeeCount)),
      contract,
      name: 'buyCoffee',
      arguments: [fields.coffeeCount, fields.name, fields.twitterHandle, fields.message],
      enableSubmit: fields.name !== '' && fields.message !== '',
      reset,
    });

  if (transactionState !== null) {
    return (
      <TransactionSteps
        transactionStep={transactionState}
        coffeeCount={fields.coffeeCount}
        resetContractForms={resetContractForms}
        gasCost={GAS_COST}
      />
    );
  }

  return (
    <>
      <h2 className="mb-5 w-full text-center text-2xl font-semibold text-white lg:text-left">
        Redeem My Time NFT
      </h2>
      <form onSubmit={onSubmitTransaction} className="w-full">
        <ContractAlert contract={contract} amount={GAS_COST} />
        <Button
          buttonContent={<>Redeem Time NFT for {String(GAS_COST.toFixed(4))} ETH</>}
          type="submit"
          disabled={disabled}
        />
      </form>
    </>
  );
}

export default FormBuyCoffee;
