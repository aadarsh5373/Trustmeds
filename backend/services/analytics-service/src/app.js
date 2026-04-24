import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { errorHandler } from '@trustmeds/common';
import analyticsRoutes from './routes/analytics.routes.js';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(express.json());

  app.get('/health', (req, res) => {
    res.json({ service: 'analytics-service', status: 'healthy' });
  });

  app.use('/api/v1/analytics', analyticsRoutes);
  
  app.use(errorHandler);

  return app;
};
