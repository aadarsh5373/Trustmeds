import { authService } from './auth.service.js';

export const authController = {
  requestOtp: async (req, res, next) => {
    try {
      const result = await authService.requestOtp(req.validated.body.mobile);
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  },

  verifyOtp: async (req, res, next) => {
    try {
      const result = await authService.verifyOtp(
        req.validated.body.mobile,
        req.validated.body.otp
      );
      res.status(200).json({ success: true, data: result });
    } catch (error) {
      next(error);
    }
  }
};
