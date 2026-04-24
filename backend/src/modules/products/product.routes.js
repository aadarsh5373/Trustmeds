import { Router } from 'express';
import { authenticate, authorize } from '../../common/middleware/auth.js';

const router = Router();

router.get('/', (req, res) =>
  res.json({ success: true, data: [], message: 'Paginated medicine list' })
);
router.get('/search', (req, res) =>
  res.json({ success: true, data: [], query: req.query.q || '' })
);
router.get('/:id/substitutes', (req, res) =>
  res.json({ success: true, data: [], message: 'Same salt substitutes' })
);
router.post('/', authenticate, authorize('admin', 'pharmacist'), (req, res) =>
  res.status(201).json({ success: true, message: 'Medicine created' })
);
router.patch('/:id', authenticate, authorize('admin', 'pharmacist'), (req, res) =>
  res.json({ success: true, message: 'Medicine updated' })
);
router.delete('/:id', authenticate, authorize('admin'), (req, res) =>
  res.status(204).send()
);

export default router;
