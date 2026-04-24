import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { errorHandler } from '@trustmeds/common';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(express.json());

  app.get('/health', (req, res) => {
    res.json({ service: 'notification-service', status: 'healthy' });
  });

  // Most notifications are triggered via BullMQ, but we can add manual triggers here
  
  app.use(errorHandler);

  return app;
};
