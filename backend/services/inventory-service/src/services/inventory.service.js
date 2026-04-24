import { query } from '../config/db.js';
import { redis } from '../config/redis.js';
import { BadRequestError, NotFoundError } from '@trustmeds/common';

export const inventoryService = {
  async getMedicineById(id) {
    const { rows } = await query('SELECT * FROM medicines WHERE id = $1', [id]);
    if (rows.length === 0) throw new NotFoundError('Medicine not found');
    return rows[0];
  },

  async updateStock(medicineId, quantityChange) {
    // Distributed Lock using Redis
    const lockKey = `lock:inventory:${medicineId}`;
    const lockValue = Date.now() + 5000;
    const acquired = await redis.set(lockKey, lockValue, 'PX', 5000, 'NX');

    if (!acquired) {
      throw new Error('Could not acquire lock, please try again');
    }

    try {
      const { rows } = await query(
        `UPDATE medicines 
         SET stock = stock + $1 
         WHERE id = $2 AND stock + $1 >= 0 
         RETURNING *`,
        [quantityChange, medicineId]
      );

      if (rows.length === 0) {
        throw new BadRequestError('Insufficient stock or invalid medicine ID');
      }

      return rows[0];
    } finally {
      await redis.del(lockKey);
    }
  },

  async lockStock(medicineId, quantity) {
    // Temp lock for order processing
    const currentStock = await redis.get(`stock:${medicineId}`);
    if (currentStock && parseInt(currentStock) < quantity) {
      throw new BadRequestError('Insufficient stock');
    }
    // Implementation of temporary reservation will go here
  }
};
