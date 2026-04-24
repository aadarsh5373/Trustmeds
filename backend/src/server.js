import http from 'http';
import { Server } from 'socket.io';

import { createApp } from './app.js';
import { env } from './config/env.js';
import { registerSocketServer } from './common/socket/index.js';

const app = createApp();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: env.clientUrl,
    credentials: true
  }
});

registerSocketServer(io);

server.listen(env.port, () => {
  console.log(`TrustMeds backend listening on port ${env.port}`);
});
