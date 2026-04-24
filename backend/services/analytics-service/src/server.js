import { createApp } from './app.js';
import { env } from './config/env.js';
import { logger } from '@trustmeds/common';
import { startAnalyticsWorker } from './workers/analytics.worker.js';

const app = createApp();

// Start the event worker
startAnalyticsWorker();

app.listen(env.port, () => {
  logger.info(`Analytics Service listening on port ${env.port}`);
});
