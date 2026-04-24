import { Router } from 'express';
import * as paymentController from '../controllers/payment.controller.js';

const router = Router();

router.post('/initiate', paymentController.initiatePayment);
router.patch('/:paymentId/verify', paymentController.verifyPayment);

export default router;
