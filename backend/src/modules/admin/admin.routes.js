import { Router } from 'express';
import { authenticate, authorize } from '../../common/middleware/auth.js';

const router = Router();

router.use(authenticate, authorize('admin'));

router.get('/dashboard', (req, res) =>
  res.json({
    success: true,
    data: {
      ordersToday: 0,
      ordersThisWeek: 0,
      delivered: 0,
      pending: 0,
      revenue: 0,
      averageOrderValue: 0
    }
  })
);
router.get('/analytics/delivery', (req, res) =>
  res.json({ success: true, data: [] })
);
router.get('/analytics/payments', (req, res) =>
  res.json({ success: true, data: [] })
);
router.get('/suppliers', (req, res) =>
  res.json({ success: true, data: [] })
);

export default router;
