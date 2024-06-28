import {
  ChevronDownIcon,
  GitHubLogoIcon,
  LinkedInLogoIcon,
  TwitterLogoIcon,
} from '@radix-ui/react-icons';
import * as NavigationMenu from '@radix-ui/react-navigation-menu';
import { clsx } from 'clsx';
import NextLink from 'next/link';
import AccountConnect from './AccountConnect';
import { Experiences } from './Experiences';

export function NavbarLink({
  href,
  children,
  target,
  ariaLabel,
}: {
  href: string;
  children: React.ReactNode;
  target?: string;
  ariaLabel?: string;
}) {
  return (
    <NextLink
      href={href}
      className="font-robotoMono px-0 text-center text-base font-normal text-white no-underline"
      target={target}
      aria-label={ariaLabel}
    >
      {children}
    </NextLink>
  );
}

export function NavbarTitle() {
  return (
    <div className="flex h-8 items-center justify-start gap-4">
      <NextLink href="/" passHref className="relative h-8 w-8" aria-label="Home page">
        <img src="/captn-in-app.jpeg" alt="Home" className="absolute h-8 w-8 rounded-full" />
      </NextLink>
      <NextLink
        href="/"
        passHref
        className="font-robotoMono text-center text-xl font-medium text-white no-underline"
        aria-label="build-onchain-apps Github repository"
      >
        captn's shipyard
      </NextLink>
    </div>
  );
}

function Navbar() {
  return (
    <nav
      className={clsx(
        'flex flex-1 flex-grow items-center justify-between',
        'rounded-[50px] border border-stone-300 bg-white bg-opacity-10 p-4 backdrop-blur-2xl',
      )}
    >
      <div className="flex h-8 grow items-center justify-between gap-4">
        <NavbarTitle />
        <div className="flex items-center justify-start gap-8">
          <ul className="hidden items-center justify-start gap-8 md:flex">
            <li className="flex">
              <NavbarLink href="https://github.com/captnseagraves" target="_blank">
                <GitHubLogoIcon width="24" height="24" aria-label="captn's github" />
              </NavbarLink>
            </li>
            <li className="flex">
              <NavbarLink href="https://linkedin.com/in/kevinseagraves" target="_blank">
                <LinkedInLogoIcon width="24" height="24" aria-label="captn's linkedin" />
              </NavbarLink>
            </li>
            <li className="flex">
              <NavbarLink href="https://twitter.com/captnseagraves" target="_blank">
                <TwitterLogoIcon width="24" height="24" aria-label="captn's twitter" />
              </NavbarLink>
            </li>
            <li className="flex">
              <NavbarLink href="/#get-started">Personal Manifesto</NavbarLink>
            </li>
            <li className="flex">
              <NavbarLink href="/#get-started">Current Investment Thesis</NavbarLink>
            </li>
            <li className="flex">
              <NavbarLink href="/buy-my-time">Buy My Time</NavbarLink>
            </li>
            <li className="flex">
              <NavigationMenu.Root className="relative">
                <NavigationMenu.List className={clsx('flex flex-row space-x-2')}>
                  <NavigationMenu.Item>
                    <NavigationMenu.Trigger className="group flex h-16 items-center justify-start gap-1">
                      <span className="font-robotoMono text-center text-base font-normal text-white">
                        Experiences
                      </span>
                      <ChevronDownIcon
                        className="transform transition duration-200 ease-in-out group-data-[state=open]:rotate-180"
                        width="16"
                        height="16"
                      />
                    </NavigationMenu.Trigger>
                    <NavigationMenu.Content
                      className={clsx(
                        'h-38 inline-flex w-48 flex-col items-start justify-start gap-6',
                        'rounded-lg bg-neutral-900 p-6 shadow backdrop-blur-2xl',
                      )}
                    >
                      <Experiences />
                    </NavigationMenu.Content>
                  </NavigationMenu.Item>
                </NavigationMenu.List>
                <NavigationMenu.Viewport
                  className={clsx(
                    'absolute flex justify-center',
                    'left-[-20%] top-[100%] w-[140%]',
                  )}
                />
              </NavigationMenu.Root>
            </li>
          </ul>
          <AccountConnect />
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
