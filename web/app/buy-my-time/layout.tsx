import { generateMetadata } from '@/utils/generateMetadata';

export const metadata = generateMetadata({
  title: 'Buy My Time',
  description: "Buy an NFT and redeem for a slot on captn's calendar",
  images: 'themes.png',
  pathname: 'buy-my-time',
});

export default async function Layout({ children }: { children: React.ReactNode }) {
  return children;
}
