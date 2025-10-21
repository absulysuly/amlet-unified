import { TopNavBar } from '../components/TopNavBar';

const highlights = [
  {
    title: 'Active Campaigns',
    metric: '36',
    change: '+4.2% vs last week'
  },
  {
    title: 'Targeted Voters',
    metric: '1.2M',
    change: '+18k new segment'
  },
  {
    title: 'Field Organizers',
    metric: '412',
    change: 'Stable'
  }
];

const activity = [
  {
    time: '08:24',
    title: 'Basra rally engagement',
    description: 'Sentiment improved after media training session.'
  },
  {
    time: '09:10',
    title: 'Mosul volunteer onboarding',
    description: '45 new volunteers completed orientation.'
  },
  {
    time: '10:05',
    title: 'TikTok creative campaign',
    description: 'Ad set optimized for youth turnout messaging.'
  }
];

export default function HomePage() {
  return (
    <main className="flex min-h-screen flex-col bg-slate-950">
      <TopNavBar onSearch={console.log} />
      <section className="mx-auto w-full max-w-6xl flex-1 space-y-8 px-6 pb-12 pt-10">
        <header className="max-w-3xl space-y-3">
          <p className="text-sm uppercase tracking-[0.35em] text-primary-200/60">Election Command Center</p>
          <h2 className="text-4xl font-semibold text-white">Campaign performance overview</h2>
          <p className="text-slate-400">
            Monitor ground operations, engagement analytics, and sentiment across all Iraqi governorates with live insights.
          </p>
        </header>

        <div className="grid gap-5 md:grid-cols-3">
          {highlights.map(card => (
            <article
              key={card.title}
              className="rounded-3xl border border-slate-800/60 bg-gradient-to-br from-slate-900/80 via-slate-900/60 to-slate-900/80 p-6 shadow-xl shadow-black/20"
            >
              <p className="text-sm font-medium text-primary-200/70">{card.title}</p>
              <p className="mt-4 text-4xl font-semibold text-white">{card.metric}</p>
              <p className="mt-2 text-xs uppercase tracking-widest text-emerald-300/80">{card.change}</p>
            </article>
          ))}
        </div>

        <div className="grid gap-6 lg:grid-cols-5">
          <section className="space-y-4 rounded-3xl border border-slate-800/70 bg-slate-900/40 p-6 lg:col-span-3">
            <header className="flex items-center justify-between">
              <h3 className="text-lg font-semibold text-white">Live activity</h3>
              <span className="rounded-full bg-emerald-500/10 px-3 py-1 text-xs font-semibold uppercase tracking-wider text-emerald-300">
                Synced
              </span>
            </header>
            <ul className="space-y-5">
              {activity.map(item => (
                <li key={item.title} className="rounded-2xl border border-slate-800/70 bg-slate-900/40 p-4">
                  <p className="text-xs uppercase tracking-widest text-slate-500">{item.time}</p>
                  <p className="mt-2 text-base font-semibold text-white">{item.title}</p>
                  <p className="text-sm text-slate-400">{item.description}</p>
                </li>
              ))}
            </ul>
          </section>

          <section className="space-y-4 rounded-3xl border border-slate-800/70 bg-slate-900/40 p-6 lg:col-span-2">
            <header>
              <h3 className="text-lg font-semibold text-white">Strategic focus</h3>
              <p className="text-sm text-slate-400">Key levers driving turnout through election week.</p>
            </header>
            <ol className="space-y-4 text-sm text-slate-300">
              <li className="rounded-2xl border border-primary-500/30 bg-primary-500/10 p-4">
                Strengthen Basra youth engagement through micro-influencers and campus events.
              </li>
              <li className="rounded-2xl border border-primary-500/20 bg-primary-500/5 p-4">
                Expand Mosul field network with daily volunteer stand-ups and localized messaging.
              </li>
              <li className="rounded-2xl border border-primary-500/10 bg-primary-500/5 p-4">
                Maintain Baghdad digital saturation with high-frequency video storytelling.
              </li>
            </ol>
          </section>
        </div>
      </section>
    </main>
  );
}
