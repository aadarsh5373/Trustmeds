import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { errorHandler } from '@trustmeds/common';
import deliveryRoutes from './routes/delivery.routes.js';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(express.json());

  app.get('/health', (req, res) => {
    res.json({ service: 'delivery-service', status: 'healthy' });
  });

  app.use('/api/v1/delivery', deliveryRoutes);
  
  app.use(errorHandler);

  return app;
};
