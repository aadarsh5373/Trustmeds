import { Router } from 'express';
import * as ambulanceController from '../controllers/ambulance.controller.js';

const router = Router();

router.post('/request', ambulanceController.requestAmbulance);
router.post('/location', ambulanceController.updateLocation);
router.post('/assign', ambulanceController.assignVehicle);

export default router;
