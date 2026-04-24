import dotenv from 'dotenv';
dotenv.config();

export const env = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: Number(process.env.PORT || 3001),
  jwt: {
    secret: process.env.JWT_SECRET || 'super-secret-key',
    expiresIn: process.env.JWT_EXPIRES_IN || '24h',
  },
  database: {
    url: process.env.DATABASE_URL || 'postgresql://localhost:5432/trustmeds_auth',
  },
};
