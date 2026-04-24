import { query } from '../config/db.js';
import { NotFoundError } from '@trustmeds/common';

export const nurseService = {
  async getNurseAvailability(nurseId, date) {
    const { rows } = await query(
      'SELECT slot_time, is_available FROM nurse_availability WHERE nurse_id = $1 AND slot_date = $2',
      [nurseId, date]
    );
    return rows;
  },

  async scheduleVisit(userId, nurseId, slotDate, slotTime, serviceType) {
    const { rows } = await query(
      `INSERT INTO nurse_visits (user_id, nurse_id, slot_date, slot_time, service_type, status) 
       VALUES ($1, $2, $3, $4, $5, 'scheduled') 
       RETURNING *`,
      [userId, nurseId, slotDate, slotTime, serviceType]
    );

    // Mark slot as unavailable
    await query(
      'UPDATE nurse_availability SET is_available = false WHERE nurse_id = $1 AND slot_date = $2 AND slot_time = $3',
      [nurseId, slotDate, slotTime]
    );

    return rows[0];
  },

  async updateVisitStatus(visitId, status) {
    const { rows } = await query(
      'UPDATE nurse_visits SET status = $1, updated_at = NOW() WHERE id = $2 RETURNING *',
      [status, visitId]
    );
    if (rows.length === 0) throw new NotFoundError('Visit not found');
    return rows[0];
  }
};
