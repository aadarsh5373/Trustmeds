import admin from 'firebase-admin';
import { env } from './env.js';
import { logger } from '@trustmeds/common';

export const initializeFirebase = () => {
  if (!env.firebase.serviceAccount) {
    logger.warn('Firebase service account not found, push notifications will be disabled');
    return null;
  }

  return admin.initializeApp({
    credential: admin.credential.cert(env.firebase.serviceAccount),
  });
};
