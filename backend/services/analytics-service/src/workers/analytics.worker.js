import { Worker } from 'bullmq';
import { env } from '../config/env.js';
import { analyticsService } from '../services/analytics.service.js';
import { logger } from '@trustmeds/common';

export const startAnalyticsWorker = () => {
  const worker = new Worker('analytics-tasks', async (job) => {
    const { type, payload } = job.data;
    logger.info(`Processing analytics job: ${type}`);

    switch (type) {
      case 'ORDER_COMPLETED':
        await analyticsService.trackRevenue(payload.amount, payload.orderId);
        break;
      
      case 'DELIVERY_FINISHED':
        await analyticsService.trackDeliveryPerformance(payload.partnerId, payload.duration);
        break;

      default:
        logger.warn(`Unknown analytics job type: ${type}`);
    }
  }, {
    connection: {
      url: env.redis.url
    }
  });

  worker.on('completed', (job) => {
    logger.info(`Analytics job ${job.id} completed successfully`);
  });

  worker.on('failed', (job, err) => {
    logger.error(`Analytics job ${job.id} failed with error: ${err.message}`);
  });

  return worker;
};
