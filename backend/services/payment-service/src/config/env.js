import dotenv from 'dotenv';
dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 3005),
  database: {
    url: process.env.DATABASE_URL || 'postgresql://localhost:5432/trustmeds_payment',
  },
  orderServiceUrl: process.env.ORDER_SERVICE_URL || 'http://localhost:3002',
};
