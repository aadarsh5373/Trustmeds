import { inventoryService } from '../services/inventory.service.js';
import { searchService } from '../services/search.service.js';

export const searchMedicines = async (req, res, next) => {
  try {
    const { q } = req.query;
    const results = await searchService.searchMedicines(q);
    res.json({ success: true, results });
  } catch (error) {
    next(error);
  }
};

export const getMedicine = async (req, res, next) => {
  try {
    const { id } = req.params;
    const medicine = await inventoryService.getMedicineById(id);
    res.json({ success: true, medicine });
  } catch (error) {
    next(error);
  }
};

export const updateStock = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { quantityChange } = req.body;
    const medicine = await inventoryService.updateStock(id, quantityChange);
    
    // Sync with ES after update
    await searchService.indexMedicine(medicine);
    
    res.json({ success: true, medicine });
  } catch (error) {
    next(error);
  }
};

export const validateStock = async (req, res, next) => {
  try {
    const { items } = req.body;
    for (const item of items) {
      const medicine = await inventoryService.getMedicineById(item.id);
      if (medicine.stock < item.quantity) {
        return res.json({ success: false, message: `Insufficient stock for ${medicine.name}` });
      }
    }
    res.json({ success: true });
  } catch (error) {
    next(error);
  }
};
