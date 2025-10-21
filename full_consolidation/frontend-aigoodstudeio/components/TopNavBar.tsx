'use client';

import { useEffect, useMemo, useState } from 'react';

const navLinks = [
  { label: 'Overview', href: '#' },
  { label: 'Campaigns', href: '#' },
  { label: 'Candidates', href: '#' },
  { label: 'Insights', href: '#' },
  { label: 'Settings', href: '#' }
];

export type TopNavBarProps = {
  onSearch?: (term: string) => void;
};

export function TopNavBar({ onSearch }: TopNavBarProps) {
  const [searchTerm, setSearchTerm] = useState('');
  const [isScrolled, setIsScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 4);
    };

    handleScroll();
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const navClasses = useMemo(
    () =>
      `sticky top-0 z-50 border-b border-slate-800/60 transition-all duration-300 ${
        isScrolled ? 'backdrop-blur bg-slate-950/80 shadow-lg' : 'bg-slate-950/90'
      }`,
    [isScrolled]
  );

  return (
    <header className={navClasses}>
      <div className="mx-auto flex w-full max-w-6xl items-center justify-between gap-4 px-6 py-4">
        <div className="flex items-center gap-3">
          <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-primary-500 to-primary-900 font-semibold shadow-lg">
            HU
          </span>
          <div>
            <p className="text-sm font-medium uppercase tracking-widest text-primary-200/80">Hamlet Unified</p>
            <h1 className="text-lg font-semibold text-white">Campaign Intelligence</h1>
          </div>
        </div>

        <nav className="hidden items-center gap-1 rounded-full border border-slate-800/70 bg-slate-900/60 p-1 text-sm md:flex">
          {navLinks.map(link => (
            <a
              key={link.label}
              href={link.href}
              className="rounded-full px-4 py-1.5 text-slate-300 transition-colors hover:bg-primary-500/20 hover:text-white"
            >
              {link.label}
            </a>
          ))}
        </nav>

        <div className="flex items-center gap-3">
          <label className="hidden items-center gap-2 rounded-full border border-slate-800/70 bg-slate-900/60 px-4 py-2 text-sm text-slate-300 focus-within:border-primary-500 focus-within:text-white md:flex">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              strokeWidth={1.5}
              stroke="currentColor"
              className="h-4 w-4"
            >
              <path strokeLinecap="round" strokeLinejoin="round" d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 105.25 5.25a7.5 7.5 0 0011.4 11.4z" />
            </svg>
            <input
              type="search"
              placeholder="Search candidates"
              className="w-44 bg-transparent text-sm text-white placeholder:text-slate-500 focus:outline-none"
              value={searchTerm}
              onChange={event => {
                const value = event.target.value;
                setSearchTerm(value);
                onSearch?.(value);
              }}
            />
          </label>

          <button
            type="button"
            className="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-primary-500 to-primary-700 text-sm font-semibold text-white shadow-lg shadow-primary-950/50 transition-transform hover:scale-105"
            aria-label="Toggle notifications"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              className="h-5 w-5"
            >
              <path d="M12 2a6 6 0 00-6 6v3.586l-.707.707A1 1 0 006 14h12a1 1 0 00.707-1.707L18 11.586V8a6 6 0 00-6-6z" />
              <path d="M9 17a3 3 0 006 0H9z" />
            </svg>
          </button>
        </div>
      </div>
    </header>
  );
}
