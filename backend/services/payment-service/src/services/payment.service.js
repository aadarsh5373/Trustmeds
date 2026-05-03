import Razorpay from 'razorpay';
import { query } from '../config/db.js';
import { BadRequestError, NotFoundError } from '@trustmeds/common';

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID || 'rzp_test_mock_id',
  key_secret: process.env.RAZORPAY_KEY_SECRET || 'mock_secret',
});

export const paymentService = {
  async initiatePayment(orderId, amount, method) {
    try {
      // 1. Create Razorpay Order
      const options = {
        amount: Math.round(amount * 100), // amount in the smallest currency unit
        currency: 'INR',
        receipt: `order_rcptid_${orderId}`,
      };

      const rzpOrder = await razorpay.orders.create(options);

      // 2. Save payment record in our DB
      const { rows } = await query(
        `INSERT INTO payments (order_id, amount, status, razorpay_order_id, method) 
         VALUES ($1, $2, $3, $4, $5) 
         RETURNING *`,
        [orderId, amount, 'PENDING', rzpOrder.id, method]
      );

      return {
        ...rows[0],
        razorpayOrderId: rzpOrder.id,
        razorpayKeyId: razorpay.key_id
      };
    } catch (error) {
      throw new BadRequestError('Payment initiation failed: ' + error.message);
    }
  },

  async updatePaymentStatus(paymentId, status, transactionRef) {
    const { rows } = await query(
      `UPDATE payments 
       SET status = $1, transaction_ref = $2, updated_at = CURRENT_TIMESTAMP 
       WHERE id = $3 
       RETURNING *`,
      [status, transactionRef, paymentId]
    );

    if (rows.length === 0) throw new NotFoundError('Payment not found');
    return rows[0];
  }
};
