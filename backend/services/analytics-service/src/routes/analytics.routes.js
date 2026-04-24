import { Router } from 'express';
import * as analyticsController from '../controllers/analytics.controller.js';

const router = Router();

router.get('/dashboard-summary', analyticsController.getDashboardSummary);

export default router;
