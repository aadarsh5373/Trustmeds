import { Router } from 'express';
import authRoutes from '../modules/auth/auth.routes.js';
import userRoutes from '../modules/users/user.routes.js';
import productRoutes from '../modules/products/product.routes.js';
import orderRoutes from '../modules/orders/order.routes.js';
import pharmacistRoutes from '../modules/pharmacist/pharmacist.routes.js';
import paymentRoutes from '../modules/payments/payment.routes.js';
import deliveryRoutes from '../modules/delivery/delivery.routes.js';
import adminRoutes from '../modules/admin/admin.routes.js';

const router = Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/products', productRoutes);
router.use('/orders', orderRoutes);
router.use('/pharmacist', pharmacistRoutes);
router.use('/payments', paymentRoutes);
router.use('/delivery', deliveryRoutes);
router.use('/admin', adminRoutes);

export default router;
