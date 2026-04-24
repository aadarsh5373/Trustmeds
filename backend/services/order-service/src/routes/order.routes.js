import { Router } from 'express';
import * as orderController from '../controllers/order.controller.js';

const router = Router();

// Middleware to mock auth user for now - will be replaced by Gateway auth soon
const mockAuth = (req, res, next) => {
  req.user = { id: '00000000-0000-0000-0000-000000000000' }; 
  next();
};

router.post('/', mockAuth, orderController.createOrder);
router.get('/:id', orderController.getOrder);
router.patch('/:id/status', orderController.updateStatus);

export default router;
