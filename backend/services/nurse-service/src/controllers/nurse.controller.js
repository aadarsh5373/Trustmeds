import { nurseService } from '../services/nurse.service.js';

export const getAvailability = async (req, res, next) => {
  try {
    const { nurseId, date } = req.query;
    const availability = await nurseService.getNurseAvailability(nurseId, date);
    res.json({ success: true, availability });
  } catch (error) {
    next(error);
  }
};

export const scheduleVisit = async (req, res, next) => {
  try {
    const { nurseId, slotDate, slotTime, serviceType } = req.body;
    const userId = req.user ? req.user.id : '00000000-0000-0000-0000-000000000000'; // Mock for now
    const visit = await nurseService.scheduleVisit(userId, nurseId, slotDate, slotTime, serviceType);
    res.status(201).json({ success: true, visit });
  } catch (error) {
    next(error);
  }
};

export const updateVisit = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const visit = await nurseService.updateVisitStatus(id, status);
    res.json({ success: true, visit });
  } catch (error) {
    next(error);
  }
};
