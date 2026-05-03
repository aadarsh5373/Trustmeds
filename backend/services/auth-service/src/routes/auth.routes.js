import { Router } from 'express';
import { loginWithFirebase, searchSocieties, updateProfile } from '../controllers/auth.controller.js';

const router = Router();

// Firebase Token Login
router.post('/login', loginWithFirebase);

// Profile Updates
router.put('/:userId/profile', updateProfile);

// Societies
router.get('/societies/search', searchSocieties);

export default router;
