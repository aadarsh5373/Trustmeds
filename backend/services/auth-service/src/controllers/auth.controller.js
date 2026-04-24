import { authService } from '../services/auth.service.js';

export const requestOtp = async (req, res, next) => {
  try {
    const { mobile } = req.body;
    const otp = await authService.generateOtp(mobile);
    res.json({ success: true, message: 'OTP sent successfully', otp: process.env.NODE_ENV === 'development' ? otp : undefined });
  } catch (error) {
    next(error);
  }
};

export const verifyOtp = async (req, res, next) => {
  try {
    const { mobile, otp } = req.body;
    const result = await authService.verifyOtp(mobile, otp);
    res.json({ success: true, ...result });
  } catch (error) {
    next(error);
  }
};
