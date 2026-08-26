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

app.get('/health', (_, response) => response.json({ ok: true }));

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

app.use((error, _, response, __) => {
  console.error(error);
  response.status(error.code === 'P2003' ? 400 : 500).json({ error: 'Unable to complete the request.' });
});

app.listen(port, () => console.log(`LikeMe server listening on http://localhost:${port}`));
