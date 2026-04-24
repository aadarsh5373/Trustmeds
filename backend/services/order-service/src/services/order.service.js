import { query } from '../config/db.js';
import { orderQueue, notificationQueue } from '../config/queue.js';
import axios from 'axios';
import { env } from '../config/env.js';
import { BadRequestError, NotFoundError } from '@trustmeds/common';

export const orderService = {
  async createOrder(userId, addressId, items) {
    // 1. Validate stock via Inventory Service
    try {
      const { data } = await axios.post(`${env.inventoryServiceUrl}/api/v1/inventory/validate-stock`, { items });
      if (!data.success) throw new BadRequestError('Items out of stock');
    } catch (e) {
      throw new BadRequestError('Stock validation failed: ' + (e.response?.data?.message || e.message));
    }

    // 2. Create Order in DB (Transaction)
    const orderNumber = `TM-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
    const totalAmount = items.reduce((acc, item) => acc + (item.price * item.quantity), 0);

    const { rows } = await query(
      `INSERT INTO orders (order_number, user_id, address_id, total_amount, status) 
       VALUES ($1, $2, $3, $4, 'pending') 
       RETURNING *`,
      [orderNumber, userId, addressId, totalAmount]
    );

    const order = rows[0];

    // 3. Insert Order Items
    for (const item of items) {
      await query(
        `INSERT INTO order_items (order_id, medicine_id, medicine_name, quantity, unit_price, total_price) 
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [order.id, item.id, item.name, item.quantity, item.price, item.price * item.quantity]
      );
    }

    // 4. Queue background tasks
    await orderQueue.add('process-payment', { orderId: order.id });
    await notificationQueue.add('send-order-confirmation', { orderId: order.id, userId });

    return order;
  },

  async getOrderById(id) {
    const { rows } = await query('SELECT * FROM orders WHERE id = $1', [id]);
    if (rows.length === 0) throw new NotFoundError('Order not found');
    
    const itemsResult = await query('SELECT * FROM order_items WHERE order_id = $1', [id]);
    return { ...rows[0], items: itemsResult.rows };
  },

  async updateOrderStatus(id, status) {
    const { rows } = await query(
      'UPDATE orders SET status = $1, updated_at = NOW() WHERE id = $2 RETURNING *',
      [status, id]
    );
    if (rows.length === 0) throw new NotFoundError('Order not found');
    return rows[0];
  }
};
