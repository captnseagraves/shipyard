import { clsx } from 'clsx';
import useOnchainCoffeeMemos from '../_hooks/useOnchainTimeMemos';
import FormBuyMyTime from './FormBuyMyTime';
import FormRedeemMyTime from './FormRedeemMyTime';
import Memos from './Memos';

export default function BuyMyTimeContractDemo() {
  const { memos, refetchMemos } = useOnchainCoffeeMemos();

  return (
    <div
      className={clsx([
        'grid grid-cols-1 items-stretch justify-start',
        'md:grid-cols-2CoffeeMd md:gap-9 lg:grid-cols-2CoffeeLg',
      ])}
    >
      <section
        className={clsx([
          'rounded-lg border border-solid border-boat-color-palette-line',
          'bg-boat-color-palette-backgroundalternate p-10',
        ])}
      >
        <div className="mb-10">
          <h3 className="text-lg font-semibold">How To Buy My Time</h3>
          <ul className="list-disc pl-5">
            <li>Purchase a time NFT from the non-fungible bonding curve</li>
            <li>Redeem the NFT for a link to my calendly</li>
          </ul>
        </div>
        <div
          className={clsx([
            'mt-10 rounded-lg border border-solid border-boat-color-palette-line',
            'bg-boat-color-palette-backgroundalternate p-10 md:mt-0',
          ])}
        >
          <FormBuyMyTime refetchMemos={refetchMemos} />
        </div>
      </section>        
      <aside>
        <h2 className="mb-5 w-fit text-2xl font-semibold text-white">Previous purchases</h2>

        {memos?.length > 0 && <Memos memos={memos} />}
      </aside>
      <section
        className={clsx([
          'rounded-lg border border-solid border-boat-color-palette-line',
          'bg-boat-color-palette-backgroundalternate p-10',
        ])}
      >
        <FormRedeemMyTime />
      </section>
    </div>
  );
}
