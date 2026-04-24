import { redis } from '../../config/redis.js';
import { env } from '../../config/env.js';
import { query } from '../../config/db.js';
import { signAccessToken, signRefreshToken } from '../../common/utils/jwt.js';

const normalizeMobile = (mobile) => mobile.trim();

export const authService = {
  async requestOtp(mobile) {
    const normalized = normalizeMobile(mobile);
    const otp = env.otp.bypassCode;

    await redis.set(
      `otp:${normalized}`,
      otp,
      'EX',
      env.otp.expirySeconds
    );

    return {
      mobile: normalized,
      expiresIn: env.otp.expirySeconds,
      otpPreview: env.nodeEnv === 'development' ? otp : undefined
    };
  },

  async verifyOtp(mobile, otp) {
    const normalized = normalizeMobile(mobile);
    const savedOtp = await redis.get(`otp:${normalized}`);

    if (!savedOtp || savedOtp !== otp) {
      throw new Error('Invalid OTP');
    }

    const userResult = await query(
      `
      insert into users (mobile, role)
      values ($1, 'customer')
      on conflict (mobile) do update set updated_at = now()
      returning id, mobile, role
      `,
      [normalized]
    );

    const user = userResult.rows[0];

    return {
      user,
      accessToken: signAccessToken({
        sub: user.id,
        role: user.role,
        mobile: user.mobile
      }),
      refreshToken: signRefreshToken({
        sub: user.id,
        role: user.role
      })
    };
  }
};
