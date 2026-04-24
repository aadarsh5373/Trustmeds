import { createApp } from './app.js';
import { env } from './config/env.js';
import { logger } from '@trustmeds/common';

const app = createApp();

app.listen(env.port, () => {
  logger.info(`API Gateway listening on port ${env.port}`);
});
