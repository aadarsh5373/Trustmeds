import { Router } from 'express';
import { authenticate } from '../../common/middleware/auth.js';

const router = Router();

router.get('/me', authenticate, (req, res) =>
  res.json({ success: true, data: { userId: req.user.sub, role: req.user.role } })
);
router.get('/addresses', authenticate, (req, res) =>
  res.json({ success: true, data: [], message: 'List user addresses' })
);
router.post('/prescriptions/upload-url', authenticate, (req, res) =>
  res.status(201).json({ success: true, data: { uploadUrl: 'signed-s3-url' } })
);
router.get('/orders', authenticate, (req, res) =>
  res.json({ success: true, data: [], message: 'User order history' })
);

export default router;
