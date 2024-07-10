'use client';
import { useAccount } from 'wagmi';
import Footer from '@/components/layout/footer/Footer';
import Header from '@/components/layout/header/Header';

/**
 * Use the page component to wrap the components
 * that you want to render on the page.
 */
export default function MyWhy() {
  const account = useAccount();

  return (
    <>
      <Header />
      <main className="container mx-auto flex flex-col px-8 py-16">
        <div>
          <br />
          <h2 className="text-xl">My Why In Crypto</h2>
          <br />
          <p className="text-md">
            Reading the Ethereum whitepaper in early May of 2017 was a revelation. I saw that my
            values of social justice, sustainability, and an equitable global future could be
            earnestly worked toward and fostered with this new technology. Blockchains matter
            because they offer the ability to program our values directly into our systems of money,
            ownership, and governance. This technology empowers individuals and communities with
            financial access and tooling previously withheld, reclaiming power from hegemonic actors
            and redistributing it to the people.
            <br />
            <br />
            Blockchains are not just technological innovations; they are revolutionary coordination
            tools. They enable immutable systems of governance, ownership, and finance that
            transcend any particular geography or jurisdiction, and that can remain free from the
            manipulation and abuses suffered by human-based systems. These decentralized frameworks
            present an alternative to the dominant geopolitical structures, creating a third major
            global economic and political bloc that stands independently from the US-led West and
            the Chinese-led East. In this new bloc, we are given the opportunity to opt out of
            traditional power structures.
            <br />
            <br />
            They enable systems where individuals have true ownership and control over their digital
            assets, data, and identity. They enable an ownership economy. Instead of a world where a
            handful of corporations monopolize control and profit from users, data, and other walled
            gardens, value is directly returned to the creators and participants, aligning
            incentives and fostering a more equitable distribution of wealth, ownership, and
            opportunity. This shift is about empowering individuals to have agency and stake in the
            systems they participate in.
            <br />
            <br />
            Crypto represents an opportunity and a lifeboat amidst the tumult of existing systems,
            pressuring incumbent powers to adapt and improve. They have the potential to include
            billions of people in economic and political activities from which they were previously
            excluded; giving them a voice, lifting them out of poverty, and enhancing their health
            and well-being.
            <br />
            <br />I believe that these technologies can create a fairer, more inclusive world. They
            provide a means to challenge and change the status quo, fostering a global environment
            where power is decentralized, and opportunities are democratized. This is not just about
            technology; it is about creating a future where everyone has the chance to thrive, a
            future where ownership and control are returned to the people, ensuring that the
            benefits of a just future are shared by all.
          </p>
        </div>
      </main>
      <Footer />
    </>
  );
}
