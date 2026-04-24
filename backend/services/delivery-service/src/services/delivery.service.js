import { query } from '../config/db.js';
import { redis } from '../config/redis.js';
import { NotFoundError } from '@trustmeds/common';

export const deliveryService = {
  async updateLocation(partnerId, latitude, longitude) {
    const key = `partner:location:${partnerId}`;
    await redis.set(key, JSON.stringify({ latitude, longitude, updatedAt: Date.now() }));
    
    // Also store in DB for audit trail
    await query(
      'INSERT INTO delivery_locations (delivery_partner_id, latitude, longitude) VALUES ($1, $2, $3)',
      [partnerId, latitude, longitude]
    );
  },

  async assignOrder(orderId, partnerId) {
    const { rows } = await query(
      'INSERT INTO delivery_assignments (order_id, partner_id, status) VALUES ($1, $2, $3) RETURNING *',
      [orderId, partnerId, 'assigned']
    );
    return rows[0];
  },

  async getPartnerLocation(partnerId) {
    const location = await redis.get(`partner:location:${partnerId}`);
    return location ? JSON.parse(location) : null;
  }
};
