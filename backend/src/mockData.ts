import { GOVERNORATES, UserRole } from 'shared-schema/types';
import type { User, Post, Event, Debate, Article } from './types';
import type { Candidate, DashboardStats, GovernorateParticipation, GovernorateData, Party } from './types';

export const users: User[] = [
    {
        id: 'user-1',
        name: 'Ali Al-Sadr',
        avatarUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        role: UserRole.Candidate,
        verified: true,
        party: 'Progress & Justice Alliance',
        governorate: 'Baghdad',
        bio: 'Dedicated to building a prosperous and united Iraq for all. Focusing on economic reform and youth empowerment.',
    },
    {
        id: 'user-2',
        name: 'Fatima Al-Jubouri',
        avatarUrl: 'https://randomuser.me/api/portraits/women/2.jpg',
        role: UserRole.Candidate,
        verified: true,
        party: 'National Future Party',
        governorate: 'Basra',
        bio: 'Advocating for environmental protection and modernizing our infrastructure. A voice for the people of Basra.',
    },
    {
        id: 'user-3',
        name: 'Ahmed Khalid',
        avatarUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
        role: UserRole.Voter,
        verified: false,
        party: 'Independent',
        governorate: 'Erbil',
    },
    {
        id: 'user-4',
        name: 'Layla Hassan',
        avatarUrl: 'https://randomuser.me/api/portraits/women/4.jpg',
        role: UserRole.Voter,
        verified: false,
        party: 'Independent',
        governorate: 'Baghdad',
    },
];

export const posts: Post[] = [
    {
        id: 'post-1',
        author: users[0],
        timestamp: '2h ago',
        content: 'Met with small business owners in Al-Mansour today. Their resilience is inspiring! We must cut red tape to help them thrive and create jobs for our youth. #Baghdad #Economy #IraqVotes',
        mediaUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800',
        likes: 1200,
        comments: 256,
        shares: 88,
        isSponsored: true,
        type: 'Post',
        governorates: ['Baghdad'],
    },
    {
        id: 'post-2',
        author: users[1],
        timestamp: '5h ago',
        content: 'Our beautiful Shatt al-Arab deserves better. We launched a new cleanup initiative today. Protecting our environment is protecting our future. 💚 #Basra #Environment #CleanWater',
        mediaUrl: 'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800',
        likes: 2300,
        comments: 412,
        shares: 150,
        isSponsored: false,
        type: 'Post',
        governorates: ['Basra'],
    },
    {
        id: 'reel-1',
        author: users[0],
        timestamp: '1d ago',
        content: 'Quick update from the campaign trail! So much energy from the people of Baghdad!',
        mediaUrl: 'https://images.unsplash.com/photo-1599518559222-1b6a71ac337d?w=400',
        likes: 5400,
        comments: 800,
        shares: 320,
        isSponsored: false,
        type: 'Reel',
        governorates: ['Baghdad'],
    },
    {
        id: 'reel-2',
        author: users[1],
        timestamp: '2d ago',
        content: 'A day in Basra. #BasraBeauty',
        mediaUrl: 'https://images.unsplash.com/photo-1617540441926-75385281a8b5?w=400',
        likes: 8100,
        comments: 1100,
        shares: 450,
        isSponsored: true,
        type: 'Reel',
        governorates: ['Basra'],
    },
];

export const events: Event[] = [
    {
        id: 'event-1',
        title: 'Town Hall with Ali Al-Sadr',
        date: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(),
        location: 'Baghdad International Community Center, Baghdad',
        organizer: users[0],
        governorate: 'Baghdad',
    },
    {
        id: 'event-2',
        title: 'Future of Basra Youth Forum',
        date: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(),
        location: 'Basra Grand Hall, Basra',
        organizer: users[1],
        governorate: 'Basra',
    },
];

export const debates: Debate[] = [
    {
        id: 'debate-1',
        title: 'The National Economic Debate',
        topic: "Strategies for diversifying Iraq's economy beyond oil.",
        scheduledTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(),
        isLive: false,
        participants: [users[0], users[1]],
    },
    {
        id: 'debate-2',
        title: 'Live: Healthcare Reform',
        topic: 'Discussing the future of public healthcare and hospital infrastructure.',
        scheduledTime: new Date().toISOString(),
        isLive: true,
        participants: [users[0], users[1]],
    },
];

export const articles: Article[] = [
    {
        id: 'article-1',
        source: 'Iraq Economic Review',
        timestamp: 'August 15, 2024',
        title: 'Analyzing the Feasibility of Tech Hubs in Major Iraqi Cities',
        authorName: 'Dr. Samira Abbas',
        contentSnippet: "A deep dive into the potential for technology and innovation to become a cornerstone of Iraq's new economy...",
        url: '#',
        governorates: ['Baghdad', 'Basra'],
    },
    {
        id: 'article-2',
        source: 'Tigris Policy Journal',
        timestamp: 'August 12, 2024',
        title: 'Water Management in the Southern Governorates: A Critical Path Forward',
        authorName: 'Hassan F. Al-Maliki',
        contentSnippet: 'With rising salinity and dwindling resources, effective water management is no longer a choice but a necessity...',
        url: '#',
        governorates: ['Basra', 'Dhi Qar'],
    },
];

export const dashboardStats: DashboardStats = {
    totalRegisteredVoters: 25123456,
    expectedTurnoutPercentage: 65,
    turnoutChangeLastWeek: 2,
    approvedCandidatesCount: 8500,
    verifiedViolationsCount: 1245,
    newViolationsChangeLastWeek: -5,
    greenCampaignImpact: {
        treesSaved: 12,
        paperPostersSaved: 245,
        co2EmissionsReducedKg: 50,
    },
    candidateDistribution: {
        men: { count: 6120, percentage: 72 },
        women: { count: 2380, percentage: 28 },
    },
};

export const slugify = (name: string) =>
    name
        .toLowerCase()
        .normalize('NFKD')
        .replace(/[^a-z0-9\s-]/g, '')
        .trim()
        .replace(/\s+/g, '-');

export const governorateParticipation: GovernorateParticipation[] = GOVERNORATES.map((name, index) => ({
    governorateId: slugify(name) || `gov-${index}`,
    governorateName: name,
    estimatedTurnout: Math.floor(Math.random() * (75 - 45 + 1)) + 45,
}));

const sampleCandidates: Candidate[] = [
    { id: 1, name: 'أحمد علي', party: 'تحالف النصر', imageUrl: 'https://picsum.photos/200/200?random=1', verified: true, governorate: 'Baghdad' },
    { id: 2, name: 'فاطمة حسن', party: 'دولة القانون', imageUrl: 'https://picsum.photos/200/200?random=2', verified: true, governorate: 'Basra' },
    { id: 3, name: 'علي كريم', party: 'التيار الصدري', imageUrl: 'https://picsum.photos/200/200?random=3', verified: false, governorate: 'Baghdad' },
    { id: 4, name: 'مريم جاسم', party: 'الحزب الديمقراطي الكردستاني', imageUrl: 'https://picsum.photos/200/200?random=4', verified: true, governorate: 'Erbil' },
];

export const governorateData = new Map<string, GovernorateData>(
    GOVERNORATES.map(name => {
        const slug = slugify(name);
        return [
            slug,
            {
                governorate: name,
                candidates: sampleCandidates.filter(candidate => candidate.governorate === name || candidate.governorate === 'Baghdad'),
                news: [
                    { id: 1, title: `أخبار ${name}`, summary: 'تطورات انتخابية محلية.', date: '2025-09-15' },
                    { id: 2, title: `استعدادات ${name}`, summary: 'تحضيرات المفوضية للمحافظة.', date: '2025-09-14' },
                ],
                localStats: {
                    registeredVoters: Math.floor(Math.random() * 5_000_000),
                    pollingStations: Math.floor(Math.random() * 1_500),
                },
            },
        ];
    })
);

export const partyData: Record<string, { party: Party; candidates: Candidate[] }> = {
    'tahaleef-al-nasr': {
        party: {
            id: 'tahaleef-al-nasr',
            name: 'تحالف النصر',
            logoUrl: 'https://via.placeholder.com/150/007a3d/FFFFFF?text=Logo',
            leader: 'حيدر العبادي',
            founded: 2018,
            description: 'تحالف سياسي يركز على الأمن، ومحاربة الفساد، وتحسين الخدمات العامة.',
        },
        candidates: sampleCandidates,
    },
};
