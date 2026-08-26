import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

await prisma.user.upsert({
  where: { id: 'demo-model-ananya' },
  update: {},
  create: {
    id: 'demo-model-ananya',
    email: 'ananya@example.test',
    username: 'ananya',
    passwordHash: 'development-only',
    role: 'model',
    name: 'Ananya Sharma',
  },
});

await prisma.$disconnect();
