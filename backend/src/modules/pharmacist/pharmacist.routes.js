import { Router } from 'express';
import { authenticate, authorize } from '../../common/middleware/auth.js';

const router = Router();

router.use(authenticate, authorize('pharmacist', 'admin'));

router.get('/orders/incoming', (req, res) =>
  res.json({ success: true, data: [], message: 'Incoming pharmacist orders' })
);
router.patch('/orders/:id/prescription', (req, res) =>
  res.json({ success: true, message: 'Prescription reviewed' })
);
router.patch('/orders/:id/packed', (req, res) =>
  res.json({ success: true, message: 'Order marked packed' })
);
router.post('/orders/:id/alternatives', (req, res) =>
  res.status(201).json({ success: true, message: 'Alternatives suggested' })
);

export default router;
