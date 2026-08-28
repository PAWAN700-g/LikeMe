import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// Seed Demo Models
const modelAnanya = await prisma.user.upsert({
  where: { id: 'demo-model-ananya' },
  update: {},
  create: {
    id: 'demo-model-ananya',
    email: 'ananya@example.test',
    username: 'ananya_sharma',
    passwordHash: 'password123',
    role: 'model',
    name: 'Ananya Sharma',
    city: 'Mumbai',
    about: 'Fashion model based in Mumbai with 4 years of experience.',
    avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600',
    modelProfile: {
      create: {
        heightCm: 175,
        experienceYears: 4,
        categories: 'Fashion, Runway',
        aiScore: {
          create: {
            overall: 94,
            portfolio: 92,
            consistency: 95,
            engagement: 96,
            professional: 93,
          },
        },
      },
    },
  },
});

const modelPriya = await prisma.user.upsert({
  where: { id: 'demo-model-priya' },
  update: {},
  create: {
    id: 'demo-model-priya',
    email: 'priya@example.test',
    username: 'priya_singh',
    passwordHash: 'password123',
    role: 'model',
    name: 'Priya Singh',
    city: 'Delhi',
    about: 'Commercial & Runway Model.',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600',
    modelProfile: {
      create: {
        heightCm: 172,
        experienceYears: 3,
        categories: 'Runway, Commercial',
        aiScore: {
          create: {
            overall: 91,
            portfolio: 89,
            consistency: 92,
            engagement: 91,
            professional: 92,
          },
        },
      },
    },
  },
});

const modelRiya = await prisma.user.upsert({
  where: { id: 'demo-model-riya' },
  update: {},
  create: {
    id: 'demo-model-riya',
    email: 'riya@example.test',
    username: 'riya_mehta',
    passwordHash: 'password123',
    role: 'model',
    name: 'Riya Mehta',
    city: 'Bangalore',
    about: 'Fitness and lifestyle content model.',
    avatarUrl: 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600',
    modelProfile: {
      create: {
        heightCm: 168,
        experienceYears: 2,
        categories: 'Fitness, Commercial',
        aiScore: {
          create: {
            overall: 89,
            portfolio: 87,
            consistency: 90,
            engagement: 88,
            professional: 91,
          },
        },
      },
    },
  },
});

// Seed Demo Client
const clientUrbanVogue = await prisma.user.upsert({
  where: { id: 'demo-client-urbanvogue' },
  update: {},
  create: {
    id: 'demo-client-urbanvogue',
    email: 'contact@urbanvogue.test',
    username: 'urbanvogue',
    passwordHash: 'password123',
    role: 'client',
    name: 'Urban Vogue',
    city: 'Mumbai',
    about: 'Leading fashion brand in India.',
    clientProfile: {
      create: {
        companyName: 'Urban Vogue Studio',
        businessVerified: true,
      },
    },
  },
});

// Seed Sample Reels
await prisma.reel.createMany({
  data: [
    {
      authorId: modelAnanya.id,
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      caption: 'Fashion shoot ✨ Mumbai',
    },
    {
      authorId: modelPriya.id,
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      caption: 'New collection shoot 📸',
    },
  ],
});

// Seed Sample Jobs
await prisma.job.createMany({
  data: [
    {
      clientId: clientUrbanVogue.id,
      title: 'Fashion Brand Photoshoot',
      description: 'Looking for professional fashion models for autumn collection catalog shoot in Mumbai.',
      category: 'Fashion',
      location: 'Mumbai',
      date: new Date('2026-09-15'),
      durationHours: 6,
      budget: 25000,
      status: 'open',
    },
    {
      clientId: clientUrbanVogue.id,
      title: 'Instagram Brand Campaign',
      description: 'Promotional beauty video campaign for social media platforms.',
      category: 'Beauty',
      location: 'Delhi',
      date: new Date('2026-09-22'),
      durationHours: 4,
      budget: 18000,
      status: 'open',
    },
    {
      clientId: clientUrbanVogue.id,
      title: 'Fitness Product Shoot',
      description: 'Activewear apparel photo and video shoot.',
      category: 'Fitness',
      location: 'Bangalore',
      date: new Date('2026-10-05'),
      durationHours: 8,
      budget: 30000,
      status: 'open',
    },
  ],
});

console.log('Database seeded successfully.');
await prisma.$disconnect();
