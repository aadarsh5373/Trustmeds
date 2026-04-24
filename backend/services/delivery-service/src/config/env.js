import dotenv from 'dotenv';
dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 3004),
  database: {
    url: process.env.DATABASE_URL || 'postgresql://localhost:5432/trustmeds_delivery',
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
};
