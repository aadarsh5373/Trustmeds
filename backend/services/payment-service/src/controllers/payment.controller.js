import { paymentService } from '../services/payment.service.js';

export const initiatePayment = async (req, res, next) => {
  try {
    const { orderId, amount, method } = req.body;
    const payment = await paymentService.initiatePayment(orderId, amount, method);
    res.json({ success: true, payment });
  } catch (error) {
    next(error);
  }
};

export const verifyPayment = async (req, res, next) => {
  try {
    const { paymentId } = req.params;
    const { status, transactionRef } = req.body;
    const payment = await paymentService.updatePaymentStatus(paymentId, status, transactionRef);
    res.json({ success: true, payment });
  } catch (error) {
    next(error);
  }
};
