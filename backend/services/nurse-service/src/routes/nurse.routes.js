import { Router } from 'express';
import * as nurseController from '../controllers/nurse.controller.js';

const router = Router();

router.get('/availability', nurseController.getAvailability);
router.post('/schedule', nurseController.scheduleVisit);
router.patch('/visit/:id', nurseController.updateVisit);

export default router;
