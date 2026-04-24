import dotenv from 'dotenv';
dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 3008),
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
  firebase: {
    serviceAccount: process.env.FIREBASE_SERVICE_ACCOUNT ? JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT) : null,
  },
};
