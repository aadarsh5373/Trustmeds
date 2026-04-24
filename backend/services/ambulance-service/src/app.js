import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { errorHandler } from '@trustmeds/common';
import ambulanceRoutes from './routes/ambulance.routes.js';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(express.json());

  app.get('/health', (req, res) => {
    res.json({ service: 'ambulance-service', status: 'healthy' });
  });

  app.use('/api/v1/ambulance', ambulanceRoutes);
  
  app.use(errorHandler);

  return app;
};
