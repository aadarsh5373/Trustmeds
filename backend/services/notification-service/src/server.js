import { createApp } from './app.js';
import { env } from './config/env.js';
import { logger } from '@trustmeds/common';
import { initializeFirebase } from './config/firebase.js';
import { startNotificationWorker } from './workers/notification.worker.js';

const app = createApp();

// Initialize external services
initializeFirebase();
startNotificationWorker();

app.listen(env.port, () => {
  logger.info(`Notification Service listening on port ${env.port}`);
});
