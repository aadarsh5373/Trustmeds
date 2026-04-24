import admin from 'firebase-admin';
import { logger } from '@trustmeds/common';

export const notificationService = {
  async sendPushNotification(token, title, body, data = {}) {
    try {
      const message = {
        notification: { title, body },
        data,
        token,
      };

      const response = await admin.messaging().send(message);
      logger.info('Successfully sent push notification:', response);
      return response;
    } catch (error) {
      logger.error('Error sending push notification:', error);
      throw error;
    }
  },

  async sendSMS(mobile, message) {
    // Mock SMS implementation
    logger.info(`Sending SMS to ${mobile}: ${message}`);
    return { success: true };
  },

  async sendWhatsApp(mobile, message) {
    // Mock WhatsApp implementation
    logger.info(`Sending WhatsApp to ${mobile}: ${message}`);
    return { success: true };
  }
};
