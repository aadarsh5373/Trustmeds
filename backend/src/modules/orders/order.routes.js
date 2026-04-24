import { Router } from 'express';
import { authenticate, authorize } from '../../common/middleware/auth.js';

const router = Router();

router.post('/', authenticate, authorize('customer'), (req, res) =>
  res.status(201).json({ success: true, message: 'Order created' })
);
router.get('/:id', authenticate, (req, res) =>
  res.json({ success: true, data: { id: req.params.id } })
);
router.patch('/:id/status', authenticate, authorize('admin', 'pharmacist', 'delivery_partner'), (req, res) =>
  res.json({ success: true, message: 'Order status updated' })
);
router.patch('/:id/assign-delivery', authenticate, authorize('admin', 'pharmacist'), (req, res) =>
  res.json({ success: true, message: 'Delivery partner assigned' })
);

export default router;
