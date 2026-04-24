import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { env } from './config/env.js';
import { errorHandler, logger } from '@trustmeds/common';
import rateLimit from 'express-rate-limit';

export const createApp = () => {
  const app = express();

  app.use(helmet());
  app.use(cors());

  // Rate Limiting
  const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: 'Too many requests from this IP, please try again later.',
  });
  app.use('/api/', limiter);

  app.get('/health', (req, res) => {
    res.json({ service: 'api-gateway', status: 'healthy' });
  });

  // Proxy Routes
  app.use('/api/v1/auth', createProxyMiddleware({
    target: env.authServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/auth': '/api/v1/auth' },
    logger: logger
  }));

  app.use('/api/v1/inventory', createProxyMiddleware({
    target: env.inventoryServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/inventory': '/api/v1/inventory' },
    logger: logger
  }));

  app.use('/api/v1/orders', createProxyMiddleware({
    target: env.orderServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/orders': '/api/v1/orders' },
    logger: logger
  }));

  app.use('/api/v1/delivery', createProxyMiddleware({
    target: env.deliveryServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/delivery': '/api/v1/delivery' },
    logger: logger
  }));

  app.use('/api/v1/payments', createProxyMiddleware({
    target: env.paymentServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/payments': '/api/v1/payments' },
    logger: logger
  }));

  app.use('/api/v1/ambulance', createProxyMiddleware({
    target: env.ambulanceServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/ambulance': '/api/v1/ambulance' },
    logger: logger
  }));

  app.use('/api/v1/nurse', createProxyMiddleware({
    target: env.nurseServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/nurse': '/api/v1/nurse' },
    logger: logger
  }));

  app.use('/api/v1/notifications', createProxyMiddleware({
    target: env.notificationServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/notifications': '/api/v1/notifications' },
    logger: logger
  }));

  app.use('/api/v1/analytics', createProxyMiddleware({
    target: env.analyticsServiceUrl,
    changeOrigin: true,
    pathRewrite: { '^/api/v1/analytics': '/api/v1/analytics' },
    logger: logger
  }));
  
  app.use(errorHandler);

  return app;
};
