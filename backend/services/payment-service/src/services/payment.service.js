import { query } from '../config/db.js';
import { BadRequestError, NotFoundError } from '@trustmeds/common';
import axios from 'axios';
import { env } from '../config/env.js';

export const paymentService = {
  async initiatePayment(orderId, amount, method) {
    const { rows } = await query(
      `INSERT INTO payments (order_id, amount, method, status) 
       VALUES ($1, $2, $3, 'pending') 
       RETURNING *`,
      [orderId, amount, method]
    );

    const payment = rows[0];

    if (method === 'upi') {
      // In a real scenario, call UPI provider (Razorpay/Paytm)
      // For now, return a mock transaction ID
      const transactionRef = `TXN-${Date.now()}`;
      await this.updatePaymentStatus(payment.id, 'paid', transactionRef);
      return { ...payment, transactionRef, status: 'paid' };
    }

    return payment;
  },

  async updatePaymentStatus(paymentId, status, transactionRef = null) {
    const { rows } = await query(
      `UPDATE payments 
       SET status = $1, transaction_reference = $2, updated_at = NOW() 
       WHERE id = $3 
       RETURNING *`,
      [status, transactionRef, paymentId]
    );

    if (rows.length === 0) throw new NotFoundError('Payment not found');

    const payment = rows[0];

    // If paid, notify Order Service
    if (status === 'paid') {
      try {
        await axios.patch(`${env.orderServiceUrl}/api/v1/orders/${payment.order_id}/status`, {
          status: 'verified'
        });
      } catch (e) {
        console.error('Failed to notify Order Service of payment', e.message);
      }
    }

    return payment;
  }
};
