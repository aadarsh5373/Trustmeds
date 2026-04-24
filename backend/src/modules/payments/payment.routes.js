import { Router } from 'express';
import { authenticate } from '../../common/middleware/auth.js';

const router = Router();

router.post('/initiate', authenticate, (req, res) =>
  res.status(201).json({ success: true, data: { paymentId: 'pay_mock_001' } })
);
router.patch('/:paymentId/refund', authenticate, (req, res) =>
  res.json({ success: true, message: 'Refund initiated' })
);
router.get('/transactions', authenticate, (req, res) =>
  res.json({ success: true, data: [], message: 'Transaction logs' })
);

export default router;
