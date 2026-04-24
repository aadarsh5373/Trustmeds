import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { errorHandler } from '@trustmeds/common';
import orderRoutes from './routes/order.routes.js';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(express.json());

  app.get('/health', (req, res) => {
    res.json({ service: 'order-service', status: 'healthy' });
  });

  app.use('/api/v1/orders', orderRoutes);
  
  app.use(errorHandler);

  return app;
};
