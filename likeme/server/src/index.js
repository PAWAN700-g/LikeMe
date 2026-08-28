import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import multer from 'multer';
import path from 'node:path';
import { mkdir } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { PrismaClient } from '@prisma/client';

const app = express();
const prisma = new PrismaClient();
const port = Number(process.env.PORT || 3000);
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const uploadDirectory = path.join(root, 'uploads', 'reels');
await mkdir(uploadDirectory, { recursive: true });

const storage = multer.diskStorage({
  destination: (_, __, callback) => callback(null, uploadDirectory),
  filename: (_, file, callback) => callback(null, `${Date.now()}-${Math.random().toString(36).slice(2)}${path.extname(file.originalname)}`),
});
const upload = multer({
  storage,
  limits: { fileSize: 100 * 1024 * 1024 },
  fileFilter: (_, file, callback) => callback(null, file.mimetype.startsWith('video/')),
});

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(root, 'uploads')));

const currentUserId = (request) => request.header('x-user-id');
const publicBaseUrl = (request) => process.env.PUBLIC_BASE_URL || `${request.protocol}://${request.get('host')}`;

function serializeReel(reel, viewerId) {
  return {
    id: reel.id,
    videoUrl: reel.videoUrl,
    caption: reel.caption,
    createdAt: reel.createdAt,
    modelName: reel.author.name,
    handle: `@${reel.author.username}`,
    likes: reel._count.likes,
    likedByViewer: viewerId ? reel.likes.some((like) => like.userId === viewerId) : false,
  };
}

// Health check
app.get('/health', (_, response) => response.json({ ok: true }));

// --- Auth Endpoints ---

app.post('/api/auth/register', async (request, response, next) => {
  try {
    const { email, password, name, username, role, city, about } = request.body;
    if (!email || !password || !name || !username) {
      return response.status(400).json({ error: 'Email, password, name, and username are required.' });
    }
    const userRole = role === 'client' ? 'client' : 'model';

    // Check existing
    const existing = await prisma.user.findFirst({
      where: { OR: [{ email }, { username }] },
    });
    if (existing) {
      return response.status(400).json({ error: 'User with this email or username already exists.' });
    }

    const user = await prisma.user.create({
      data: {
        email,
        username,
        passwordHash: password, // simplified for dev demo
        role: userRole,
        name,
        city: city || 'Mumbai',
        about: about || '',
        avatarUrl: `https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600`,
        ...(userRole === 'model'
          ? {
              modelProfile: {
                create: {
                  experienceYears: 1,
                  categories: 'Fashion, Commercial',
                  aiScore: {
                    create: {
                      overall: 90,
                      portfolio: 88,
                      consistency: 92,
                      engagement: 90,
                      professional: 90,
                    },
                  },
                },
              },
            }
          : {
              clientProfile: {
                create: {
                  companyName: name,
                },
              },
            }),
      },
    });

    response.status(201).json({
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      role: user.role,
      city: user.city,
      avatarUrl: user.avatarUrl,
    });
  } catch (error) {
    next(error);
  }
});

app.post('/api/auth/login', async (request, response, next) => {
  try {
    const { email, password } = request.body;
    if (!email || !password) {
      return response.status(400).json({ error: 'Email and password are required.' });
    }

    const user = await prisma.user.findFirst({
      where: {
        OR: [{ email }, { username: email }],
      },
    });

    if (!user || user.passwordHash !== password) {
      return response.status(401).json({ error: 'Invalid email or password.' });
    }

    response.json({
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      role: user.role,
      city: user.city,
      avatarUrl: user.avatarUrl,
    });
  } catch (error) {
    next(error);
  }
});

app.get('/api/auth/me', async (request, response, next) => {
  try {
    const userId = currentUserId(request);
    if (!userId) return response.status(401).json({ error: 'Missing x-user-id header.' });

    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { modelProfile: true, clientProfile: true },
    });

    if (!user) return response.status(404).json({ error: 'User not found.' });

    response.json({
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      role: user.role,
      city: user.city,
      about: user.about,
      avatarUrl: user.avatarUrl,
    });
  } catch (error) {
    next(error);
  }
});

// --- Reels Endpoints ---

app.get('/api/reels', async (request, response, next) => {
  try {
    const viewerId = currentUserId(request);
    const reels = await prisma.reel.findMany({
      orderBy: { createdAt: 'desc' },
      take: 50,
      include: {
        author: { select: { name: true, username: true } },
        likes: viewerId ? { where: { userId: viewerId }, select: { userId: true } } : false,
        _count: { select: { likes: true } },
      },
    });
    response.json(reels.map((reel) => serializeReel(reel, viewerId)));
  } catch (error) { next(error); }
});

app.post('/api/reels', upload.single('video'), async (request, response, next) => {
  try {
    const authorId = currentUserId(request);
    if (!authorId) return response.status(401).json({ error: 'Missing x-user-id.' });
    if (!request.file) return response.status(400).json({ error: 'A video file is required.' });
    const caption = String(request.body.caption || '').trim();
    const reel = await prisma.reel.create({
      data: { authorId, caption, videoUrl: `${publicBaseUrl(request)}/uploads/reels/${request.file.filename}` },
      include: { author: { select: { name: true, username: true } }, likes: { where: { userId: authorId }, select: { userId: true } }, _count: { select: { likes: true } } },
    });
    response.status(201).json(serializeReel(reel, authorId));
  } catch (error) { next(error); }
});

app.post('/api/reels/:reelId/like', async (request, response, next) => {
  try {
    const userId = currentUserId(request);
    if (!userId) return response.status(401).json({ error: 'Missing x-user-id.' });
    const key = { reelId_userId: { reelId: request.params.reelId, userId } };
    const existing = await prisma.reelLike.findUnique({ where: key });
    if (existing) await prisma.reelLike.delete({ where: key });
    else await prisma.reelLike.create({ data: { reelId: request.params.reelId, userId } });
    const likes = await prisma.reelLike.count({ where: { reelId: request.params.reelId } });
    response.json({ liked: !existing, likes });
  } catch (error) { next(error); }
});

// --- Discover Models Endpoints ---

app.get('/api/models', async (request, response, next) => {
  try {
    const models = await prisma.user.findMany({
      where: { role: 'model' },
      include: {
        modelProfile: {
          include: { aiScore: true },
        },
      },
    });

    const serialized = models.map((m) => ({
      id: m.id,
      name: m.name,
      username: `@${m.username}`,
      category: m.modelProfile?.categories ? m.modelProfile.categories.split(',')[0].trim() : 'Fashion',
      location: m.city || 'Mumbai',
      rating: 4.9,
      aiScore: m.modelProfile?.aiScore?.overall || 90,
      followers: '125K',
      experience: `${m.modelProfile?.experienceYears || 2} years`,
      imageUrl: m.avatarUrl || 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=600',
    }));

    response.json(serialized);
  } catch (error) {
    next(error);
  }
});

// --- Jobs Endpoints ---

app.get('/api/jobs', async (request, response, next) => {
  try {
    const jobs = await prisma.job.findMany({
      orderBy: { createdAt: 'desc' },
      include: {
        client: { select: { name: true, username: true } },
        _count: { select: { applications: true } },
      },
    });

    const serialized = jobs.map((job) => ({
      id: job.id,
      title: job.title,
      company: job.client.name,
      category: job.category,
      location: job.location,
      budget: job.budget,
      date: job.date ? new Date(job.date).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }) : 'TBD',
      duration: `${job.durationHours} Hours`,
      applicants: job._count.applications,
      verified: true,
      status: job.status === 'open' ? 'Open' : 'Completed',
    }));

    response.json(serialized);
  } catch (error) {
    next(error);
  }
});

app.post('/api/jobs', async (request, response, next) => {
  try {
    const clientId = currentUserId(request);
    if (!clientId) return response.status(401).json({ error: 'Missing x-user-id header.' });

    const { title, description, category, location, date, durationHours, budget, requirements } = request.body;
    if (!title || !category || !budget) {
      return response.status(400).json({ error: 'Title, category, and budget are required.' });
    }

    const job = await prisma.job.create({
      data: {
        clientId,
        title,
        description: description || title,
        category,
        location: location || 'Mumbai',
        date: date ? new Date(date) : new Date(),
        durationHours: Number(durationHours) || 5,
        budget: Number(budget),
        requirements: requirements || '',
      },
      include: {
        client: { select: { name: true } },
        _count: { select: { applications: true } },
      },
    });

    response.status(201).json({
      id: job.id,
      title: job.title,
      company: job.client.name,
      category: job.category,
      location: job.location,
      budget: job.budget,
      date: new Date(job.date).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }),
      duration: `${job.durationHours} Hours`,
      applicants: 0,
      verified: true,
      status: 'Open',
    });
  } catch (error) {
    next(error);
  }
});

app.post('/api/jobs/:jobId/apply', async (request, response, next) => {
  try {
    const modelId = currentUserId(request);
    if (!modelId) return response.status(401).json({ error: 'Missing x-user-id header.' });

    const { jobId } = request.params;
    const { introduction, expectedFee } = request.body;

    const application = await prisma.application.create({
      data: {
        jobId,
        modelId,
        introduction: introduction || 'Interested in this project.',
        expectedFee: expectedFee ? Number(expectedFee) : null,
      },
    });

    response.status(201).json({ ok: true, id: application.id });
  } catch (error) {
    next(error);
  }
});

app.get('/api/applications/my', async (request, response, next) => {
  try {
    const modelId = currentUserId(request);
    if (!modelId) return response.status(401).json({ error: 'Missing x-user-id header.' });

    const applications = await prisma.application.findMany({
      where: { modelId },
      include: {
        job: {
          include: { client: { select: { name: true } } },
        },
      },
    });

    response.json(applications);
  } catch (error) {
    next(error);
  }
});

// Error handler
app.use((error, _, response, __) => {
  console.error(error);
  response.status(error.code === 'P2003' ? 400 : 500).json({ error: error.message || 'Unable to complete the request.' });
});

app.listen(port, '0.0.0.0', () => console.log(`LikeMe server listening on http://0.0.0.0:${port}`));
