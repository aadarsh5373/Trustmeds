import { query } from '../config/db.js';

export const analyticsService = {
  async trackRevenue(amount, orderId) {
    await query(
      'INSERT INTO revenue_history (order_id, amount, processed_at) VALUES ($1, $2, NOW())',
      [orderId, amount]
    );
  },

  async trackDeliveryPerformance(partnerId, responseTimeSeconds) {
    await query(
      'INSERT INTO delivery_performance (partner_id, response_time, measured_at) VALUES ($1, $2, NOW())',
      [partnerId, responseTimeSeconds]
    );
  },

  async getDashboardSummary() {
    const revenue = await query('SELECT SUM(amount) as total_revenue FROM revenue_history');
    const orderCount = await query('SELECT COUNT(*) as total_orders FROM revenue_history');
    const avgDeliveryTime = await query('SELECT AVG(response_time) as avg_time FROM delivery_performance');

    return {
      totalRevenue: revenue.rows[0].total_revenue || 0,
      totalOrders: orderCount.rows[0].total_orders || 0,
      avgDeliveryTime: avgDeliveryTime.rows[0].avg_time || 0
    };
  }
};
