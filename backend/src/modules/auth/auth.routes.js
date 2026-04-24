import { Router } from 'express';
import { authController } from './auth.controller.js';
import { validate } from '../../common/middleware/validate.js';
import { authRateLimiter } from '../../common/middleware/rate-limit.js';
import { requestOtpSchema, verifyOtpSchema } from './auth.validation.js';

const router = Router();

router.post('/request-otp', authRateLimiter, validate(requestOtpSchema), authController.requestOtp);
router.post('/verify-otp', authRateLimiter, validate(verifyOtpSchema), authController.verifyOtp);

export default router;
