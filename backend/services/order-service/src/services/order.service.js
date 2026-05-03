import axios from 'axios';
import { query } from '../config/db.js';
import { BadRequestError, NotFoundError } from '@trustmeds/common';

const INVENTORY_SERVICE_URL = process.env.INVENTORY_SERVICE_URL || 'http://localhost:3003';

export const orderService = {
  async createOrder(userId, items, addressId, totalAmount) {
    // 1. Validate Stock
    try {
      const stockResponse = await axios.post(`${INVENTORY_SERVICE_URL}/api/v1/inventory/validate-stock`, {
        items: items.map(i => ({ id: i.id, quantity: i.quantity }))
      });
      
      if (!stockResponse.data.success) {
        throw new BadRequestError(stockResponse.data.message);
      }
    } catch (error) {
      throw new BadRequestError('Inventory check failed: ' + error.message);
    }

    // 2. Create Order in DB
    const { rows } = await query(
      `INSERT INTO orders (user_id, address_id, total_amount, status) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
      [userId, addressId, totalAmount, 'PENDING_PAYMENT']
    );

    const order = rows[0];

    // 3. Create Order Items
    for (const item of items) {
      await query(
        `INSERT INTO order_items (order_id, medicine_id, quantity, price) 
         VALUES ($1, $2, $3, $4)`,
        [order.id, item.id, item.quantity, item.price]
      );
    }

    return order;
  },

  async getOrderById(id) {
    const { rows } = await query('SELECT * FROM orders WHERE id = $1', [id]);
    if (rows.length === 0) throw new NotFoundError('Order not found');
    
    const itemsRes = await query('SELECT * FROM order_items WHERE order_id = $1', [id]);
    return { ...rows[0], items: itemsRes.rows };
  },

  async updateStatus(id, status) {
    const { rows } = await query(
      'UPDATE orders SET status = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *',
      [status, id]
    );
    if (rows.length === 0) throw new NotFoundError('Order not found');
    return rows[0];
  }
};
