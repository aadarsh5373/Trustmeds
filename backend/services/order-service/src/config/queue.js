import { Queue } from 'bullmq';
import { env } from './env.js';

const connection = {
  url: env.redis.url,
};

export const orderQueue = new Queue('order-tasks', { connection });
export const notificationQueue = new Queue('notifications', { connection });
export const inventoryQueue = new Queue('inventory-tasks', { connection });
