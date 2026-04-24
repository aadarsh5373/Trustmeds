import { Worker } from 'bullmq';
import { env } from '../config/env.js';
import { notificationService } from '../services/notification.service.js';
import { logger } from '@trustmeds/common';

export const startNotificationWorker = () => {
  const worker = new Worker('notifications', async (job) => {
    const { type, payload } = job.data;
    logger.info(`Processing notification job: ${type}`);

    switch (type) {
      case 'ORDER_CONFIRMED':
        await notificationService.sendPushNotification(payload.token, 'Order Confirmed', `Your order ${payload.orderNumber} is confirmed.`);
        await notificationService.sendSMS(payload.mobile, `Your TrustMeds order ${payload.orderNumber} is confirmed.`);
        break;
      
      case 'DELIVERY_ASSIGNED':
        await notificationService.sendPushNotification(payload.token, 'Delivery Partner Assigned', `Your delivery partner is on the way.`);
        break;

      default:
        logger.warn(`Unknown notification type: ${type}`);
    }
  }, {
    connection: {
      url: env.redis.url
    }
  });

  worker.on('completed', (job) => {
    logger.info(`Job ${job.id} completed successfully`);
  });

  worker.on('failed', (job, err) => {
    logger.error(`Job ${job.id} failed with error: ${err.message}`);
  });

  return worker;
};
