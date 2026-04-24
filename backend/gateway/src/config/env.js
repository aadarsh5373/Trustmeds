import dotenv from 'dotenv';
dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 8000),
  authServiceUrl: process.env.AUTH_SERVICE_URL || 'http://localhost:3001',
  orderServiceUrl: process.env.ORDER_SERVICE_URL || 'http://localhost:3002',
  inventoryServiceUrl: process.env.INVENTORY_SERVICE_URL || 'http://localhost:3003',
  deliveryServiceUrl: process.env.DELIVERY_SERVICE_URL || 'http://localhost:3004',
  paymentServiceUrl: process.env.PAYMENT_SERVICE_URL || 'http://localhost:3005',
  ambulanceServiceUrl: process.env.AMBULANCE_SERVICE_URL || 'http://localhost:3006',
  nurseServiceUrl: process.env.NURSE_SERVICE_URL || 'http://localhost:3007',
  notificationServiceUrl: process.env.NOTIFICATION_SERVICE_URL || 'http://localhost:3008',
  analyticsServiceUrl: process.env.ANALYTICS_SERVICE_URL || 'http://localhost:3009',
};
