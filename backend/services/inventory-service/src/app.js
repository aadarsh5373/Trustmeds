import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { errorHandler } from '@trustmeds/common';
import inventoryRoutes from './routes/inventory.routes.js';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(express.json());

  app.get('/health', (req, res) => {
    res.json({ service: 'inventory-service', status: 'healthy' });
  });

  app.use('/api/v1/inventory', inventoryRoutes);
  
  app.use(errorHandler);

  return app;
};
