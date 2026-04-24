import { Router } from 'express';
import * as deliveryController from '../controllers/delivery.controller.js';

const router = Router();

router.post('/location', deliveryController.updateLocation);
router.get('/location/:partnerId', deliveryController.getPartnerLocation);
router.post('/assign', deliveryController.assignOrder);

export default router;
