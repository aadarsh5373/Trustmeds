import jwt from 'jsonwebtoken';
import { redis } from '../config/redis.js';
import { query } from '../config/db.js';
import { env } from '../config/env.js';
import { UnauthorizedError } from '@trustmeds/common';

export const authService = {
  async generateOtp(mobile) {
    const otp = '123456'; // Default bypass for dev
    await redis.set(`otp:${mobile}`, otp, 'EX', 300);
    return otp;
  },

  async verifyOtp(mobile, otp) {
    const savedOtp = await redis.get(`otp:${mobile}`);
    if (!savedOtp || savedOtp !== otp) {
      throw new UnauthorizedError('Invalid or expired OTP');
    }

    const { rows } = await query(
      `INSERT INTO users (mobile) VALUES ($1) 
       ON CONFLICT (mobile) DO UPDATE SET updated_at = NOW() 
       RETURNING id, mobile, role`,
      [mobile]
    );

    const user = rows[0];
    const token = jwt.sign(
      { id: user.id, role: user.role, mobile: user.mobile },
      env.jwt.secret,
      { expiresIn: env.jwt.expiresIn }
    );

    return { user, token };
  }
};
