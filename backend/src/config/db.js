import pg from 'pg';
import { env } from './env.js';

const { Pool } = pg;

export const db = new Pool({
  connectionString: env.databaseUrl,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000
});

export const query = (text, params = []) => db.query(text, params);
