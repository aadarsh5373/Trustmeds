import { orderService } from '../services/order.service.js';

export const createOrder = async (req, res, next) => {
  try {
    const { addressId, items } = req.body;
    const userId = req.user.id; // From auth middleware
    const order = await orderService.createOrder(userId, addressId, items);
    res.status(201).json({ success: true, order });
  } catch (error) {
    next(error);
  }
};

export const getOrder = async (req, res, next) => {
  try {
    const { id } = req.params;
    const order = await orderService.getOrderById(id);
    res.json({ success: true, order });
  } catch (error) {
    next(error);
  }
};

export const updateStatus = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const order = await orderService.updateOrderStatus(id, status);
    res.json({ success: true, order });
  } catch (error) {
    next(error);
  }
};
