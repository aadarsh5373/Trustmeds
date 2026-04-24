import { analyticsService } from '../services/analytics.service.js';

export const getDashboardSummary = async (req, res, next) => {
  try {
    const summary = await analyticsService.getDashboardSummary();
    res.json({ success: true, summary });
  } catch (error) {
    next(error);
  }
};
