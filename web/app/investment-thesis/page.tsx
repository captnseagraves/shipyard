'use client';
import { useAccount } from 'wagmi';
import Footer from '@/components/layout/footer/Footer';
import Header from '@/components/layout/header/Header';

/**
 * Use the page component to wrap the components
 * that you want to render on the page.
 */
export default function InvestmentThesis() {
  const account = useAccount();

  return (
    <>
      <Header />
      <main className="container mx-auto flex flex-col px-8 py-16">
        <div>
          <br />
          <h2 className="text-xl">Current Investment Thesis</h2>
          <br />
          <p className="text-md">Stack as much ETH and BTC as possible.</p>
        </div>
      </main>
      <Footer />
    </>
  );
}
