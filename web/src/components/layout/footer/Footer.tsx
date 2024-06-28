'use client';

import {
  GitHubLogoIcon,
  ArrowTopRightIcon,
  LinkedInLogoIcon,
  TwitterLogoIcon,
} from '@radix-ui/react-icons';
import NextLink from 'next/link';
import { NavbarLink } from '@/components/layout/header/Navbar';
import FooterIcon from './FooterIcon';

export default function Footer() {
  return (
    <footer className="flex flex-1 flex-col justify-end">
      <div className="flex flex-col justify-between gap-16 bg-boat-footer-dark-gray py-12">
        <div className="container mx-auto flex w-full flex-col justify-between gap-16 px-8 md:flex-row">
          <div className="flex flex-col justify-between">
            <div className="flex h-8 items-center justify-start gap-4">
              <NextLink href="/" passHref className="relative h-8 w-8" aria-label="Home page">
                <img
                  src="/captn-in-app.jpeg"
                  alt="Home"
                  className="absolute h-8 w-8 rounded-full"
                />
              </NextLink>
              <NextLink
                href="/"
                passHref
                className="font-robotoMono text-center text-xl font-medium text-white no-underline"
              >
                captn's shipyard
              </NextLink>
              <NavbarLink href="https://github.com/coinbase/build-onchain-apps" target="_blank">
                <GitHubLogoIcon
                  width="24"
                  height="24"
                  aria-label="build-onchain-apps Github respository"
                />
              </NavbarLink>
              <NavbarLink href="https://linkedin.com/in/kevinseagraves" target="_blank">
                <LinkedInLogoIcon width="24" height="24" aria-label="captn's linkedin" />
              </NavbarLink>
              <NavbarLink href="https://twitter.com/captnseagraves" target="_blank">
                <TwitterLogoIcon width="24" height="24" aria-label="captn's twitter" />
              </NavbarLink>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
