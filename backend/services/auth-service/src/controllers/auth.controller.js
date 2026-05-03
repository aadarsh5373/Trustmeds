import { authService } from '../services/auth.service.js';

export const loginWithFirebase = async (req, res, next) => {
  try {
    const { idToken, societyId } = req.body;
    
    if (!idToken) {
      return res.status(400).json({ success: false, message: 'Firebase ID token is required' });
    }

    // 1. Verify token with Firebase
    const decodedToken = await authService.verifyFirebaseToken(idToken);
    
    // 2. Find or create user in our DB
    const user = await authService.findOrCreateUser({
      uid: decodedToken.uid,
      phone_number: decodedToken.phone_number
    }, societyId);
    
    // 3. Generate our own JWT
    const accessToken = authService.generateJWT(user);
    
    res.json({
      success: true,
      user,
      accessToken
    });
  } catch (error) {
    next(error);
  }
};

export const searchSocieties = async (req, res, next) => {
  try {
    const { pincode } = req.query;
    // Mock implementation for now
    const societies = [
      { id: 'soc_1', name: 'Sunshine Apartments', pincode: '400001' },
      { id: 'soc_2', name: 'Green Valley', pincode: '400001' }
    ];
    res.json({ success: true, societies });
  } catch (error) {
    next(error);
  }
};

export const updateProfile = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const { fullName, email, societyId } = req.body;
    const user = await authService.updateProfile(userId, { fullName, email, societyId });
    res.json({ success: true, user });
  } catch (error) {
    next(error);
  }
};
