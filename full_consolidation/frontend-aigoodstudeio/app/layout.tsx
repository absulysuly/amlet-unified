import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import type { ReactNode } from 'react';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Hamlet Unified Dashboard',
  description: 'Campaign intelligence hub for Iraqi elections'
};

export default function RootLayout({
  children
}: {
  children: ReactNode;
}) {
  return (
    <html lang="en" className="bg-slate-950">
      <body className={`${inter.className} bg-slate-950 text-slate-50 antialiased`}>
        {children}
      </body>
    </html>
  );
}
