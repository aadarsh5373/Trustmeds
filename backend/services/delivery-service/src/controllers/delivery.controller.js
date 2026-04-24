import { deliveryService } from '../services/delivery.service.js';

export const updateLocation = async (req, res, next) => {
  try {
    const { partnerId, latitude, longitude } = req.body;
    await deliveryService.updateLocation(partnerId, latitude, longitude);
    res.json({ success: true, message: 'Location updated' });
  } catch (error) {
    next(error);
  }
};

export const getPartnerLocation = async (req, res, next) => {
  try {
    const { partnerId } = req.params;
    const location = await deliveryService.getPartnerLocation(partnerId);
    res.json({ success: true, location });
  } catch (error) {
    next(error);
  }
};

export const assignOrder = async (req, res, next) => {
  try {
    const { orderId, partnerId } = req.body;
    const assignment = await deliveryService.assignOrder(orderId, partnerId);
    res.json({ success: true, assignment });
  } catch (error) {
    next(error);
  }
};
