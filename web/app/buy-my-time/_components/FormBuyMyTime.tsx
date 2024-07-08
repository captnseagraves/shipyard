import { useCallback } from 'react';
import clsx from 'clsx';
import { parseEther } from 'viem';
import Button from '@/components/Button/Button';
import { useBuyMyTimeContract } from '../_contracts/useBuyMyTimeContract';
import useFields from '../_hooks/useFields';
import useOnchainTimeMemos from '../_hooks/useOnchainTimeMemos';
import ContractAlert from './ContractAlert';
import InputText from './InputText';
import Label from './Label';
import TextArea from './TextArea';
import TransactionSteps from './TransactionSteps';
import useSmartContractForms from './useSmartContractForms';

const GAS_COST = 0.05;
const TIME_COUNT = [1, 2, 3, 4];

const initFields = {
  name: '',
  twitterHandle: '',
  message: '',
  numTimeSlots: 1,
};

type Fields = {
  name: string;
  twitterHandle: string;
  numTimeSlots: number;
  message: string;
};

type FormBuyMyTimeProps = {
  refetchMemos: ReturnType<typeof useOnchainTimeMemos>['refetchMemos'];
};

function FormBuyCoffee({ refetchMemos }: FormBuyMyTimeProps) {
  const contract = useBuyMyTimeContract();

  const { fields, setField, resetFields } = useFields<Fields>(initFields);

  const reset = useCallback(async () => {
    resetFields();
    await refetchMemos();
  }, [refetchMemos, resetFields]);

  const { disabled, transactionState, resetContractForms, onSubmitTransaction } =
    useSmartContractForms({
      gasFee: parseEther(String(GAS_COST * fields.numTimeSlots)),
      contract,
      name: 'buyTime',
      arguments: [fields.numTimeSlots, fields.message],
      enableSubmit: fields.name !== '' && fields.message !== '',
      reset,
    });

  if (transactionState !== null) {
    return (
      <TransactionSteps
        transactionStep={transactionState}
        numTimeSlots={fields.numTimeSlots}
        resetContractForms={resetContractForms}
        gasCost={GAS_COST}
      />
    );
  }

  return (
    <>
      <h2 className="mb-5 w-full text-center text-2xl font-semibold text-white lg:text-left">
        Buy My Time
      </h2>
      <form onSubmit={onSubmitTransaction} className="w-full">
        <div className="my-4 items-center lg:flex lg:gap-4">
          <div className="text-center text-4xl lg:text-left">🕒</div>
          <div className="mb-4 mt-2 text-center font-sans text-xl lg:my-0 lg:text-left">X</div>
          <div className="mx-auto flex max-w-[300px] gap-3 lg:max-w-max">
            {TIME_COUNT.map((count) => (
              <button
                key={`num-coffee-btn-${count}`}
                type="button"
                className={clsx(
                  `${
                    fields.numTimeSlots === count
                      ? 'bg-gradient-2'
                      : 'border border-boat-color-orange'
                  } block h-[40px] w-full rounded lg:w-[40px]`,
                )}
                // eslint-disable-next-line react-perf/jsx-no-new-function-as-prop
                onClick={() => setField('numTimeSlots', count)}
              >
                {count}
              </button>
            ))}
          </div>
        </div>

        <div>
          <div className="mb-5">
            <Label htmlFor="name">Name</Label>
            <InputText
              id="name"
              placeholder="Name"
              // eslint-disable-next-line react-perf/jsx-no-new-function-as-prop
              onChange={(evt) => setField('name', evt.target.value)}
              disabled={disabled}
              required
            />
          </div>

          <div className="mb-5">
            <Label htmlFor="twitterHandle">Twitter handle (Optional)</Label>
            <InputText
              id="twitterHandle"
              placeholder="@"
              // eslint-disable-next-line react-perf/jsx-no-new-function-as-prop
              onChange={(evt) => {
                setField('twitterHandle', evt.target.value);
              }}
              disabled={disabled}
            />
          </div>

          <div className="mb-5">
            <Label htmlFor="message">Message</Label>
            <TextArea
              id="message"
              placeholder="Say something"
              // eslint-disable-next-line react-perf/jsx-no-new-function-as-prop
              onChange={(evt) => setField('message', evt.target.value)}
              disabled={disabled}
              required
            />
          </div>

          <ContractAlert contract={contract} amount={GAS_COST} />

          <Button
            buttonContent={
              <>
                Buy {fields.numTimeSlots} time slot{fields.numTimeSlots > 1 ? 's' : null} for{' '}
                {String(GAS_COST * fields.numTimeSlots)} ETH
              </>
            }
            type="submit"
            disabled={disabled}
          />
        </div>
      </form>
    </>
  );
}

export default FormBuyCoffee;
