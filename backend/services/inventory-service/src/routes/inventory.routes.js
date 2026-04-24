import { Router } from 'express';
import * as inventoryController from '../controllers/inventory.controller.js';

const router = Router();

router.get('/search', inventoryController.searchMedicines);
router.get('/:id', inventoryController.getMedicine);
router.patch('/:id/stock', inventoryController.updateStock);
router.post('/validate-stock', inventoryController.validateStock);

export default router;
