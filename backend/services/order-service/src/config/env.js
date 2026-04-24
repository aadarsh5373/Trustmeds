import dotenv from 'dotenv';
dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 3002),
  database: {
    url: process.env.DATABASE_URL || 'postgresql://localhost:5432/trustmeds_order',
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379',
  },
  inventoryServiceUrl: process.env.INVENTORY_SERVICE_URL || 'http://localhost:3003',
  paymentServiceUrl: process.env.PAYMENT_SERVICE_URL || 'http://localhost:3005',
};
