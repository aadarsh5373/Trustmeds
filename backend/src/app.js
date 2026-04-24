import cors from 'cors';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { env } from './config/env.js';
import routes from './routes/index.js';
import { apiRateLimiter } from './common/middleware/rate-limit.js';
import { errorHandler } from './common/middleware/error-handler.js';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors({ origin: env.clientUrl, credentials: true }));
  app.use(express.json({ limit: '2mb' }));
  app.use(express.urlencoded({ extended: true }));
  app.use(morgan('combined'));
  app.use(apiRateLimiter);

  app.get('/health', (req, res) =>
    res.json({ success: true, message: 'TrustMeds backend healthy' })
  );

  app.use(env.apiPrefix, routes);
  app.use(errorHandler);

  return app;
};
