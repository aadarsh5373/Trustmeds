import { Router } from 'express';
import { authenticate, authorize } from '../../common/middleware/auth.js';

const router = Router();

router.use(authenticate, authorize('delivery_partner', 'admin'));

router.get('/orders/assigned', (req, res) =>
  res.json({ success: true, data: [], message: 'Assigned delivery orders' })
);
router.patch('/orders/:id/status', (req, res) =>
  res.json({ success: true, message: 'Delivery status updated' })
);
router.patch('/orders/:id/cod-collected', (req, res) =>
  res.json({ success: true, message: 'COD marked collected' })
);
router.post('/location', (req, res) =>
  res.status(202).json({ success: true, message: 'Location accepted' })
);

export default router;
