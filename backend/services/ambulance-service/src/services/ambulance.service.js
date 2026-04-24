import { query } from '../config/db.js';
import { redis } from '../config/redis.js';
import { NotFoundError } from '@trustmeds/common';

export const ambulanceService = {
  async registerRequest(userId, latitude, longitude, type) {
    const { rows } = await query(
      `INSERT INTO ambulance_requests (user_id, latitude, longitude, type, status) 
       VALUES ($1, $2, $3, $4, 'searching') 
       RETURNING *`,
      [userId, latitude, longitude, type]
    );

    const request = rows[0];

    // Trigger matching logic (finding nearest available vehicle)
    // This could be an event added to a queue
    return request;
  },

  async updateVehicleLocation(vehicleId, latitude, longitude) {
    const key = `ambulance:location:${vehicleId}`;
    await redis.set(key, JSON.stringify({ latitude, longitude, updatedAt: Date.now() }));
    
    await query(
      'INSERT INTO ambulance_locations (vehicle_id, latitude, longitude) VALUES ($1, $2, $3)',
      [vehicleId, latitude, longitude]
    );
  },

  async assignVehicle(requestId, vehicleId) {
    const { rows } = await query(
      `UPDATE ambulance_requests 
       SET vehicle_id = $1, status = 'assigned', assigned_at = NOW() 
       WHERE id = $2 
       RETURNING *`,
      [vehicleId, requestId]
    );

    if (rows.length === 0) throw new NotFoundError('Request not found');
    return rows[0];
  }
};
