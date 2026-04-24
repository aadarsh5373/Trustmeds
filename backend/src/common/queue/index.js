import { Queue } from 'bullmq';
import { redis } from '../../config/redis.js';

export const notificationQueue = new Queue('notifications', {
  connection: redis
});

export const analyticsQueue = new Queue('analytics', {
  connection: redis
});
