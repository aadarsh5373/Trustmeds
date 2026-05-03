import admin from 'firebase-admin';
import jwt from 'jsonwebtoken';
import { query } from '../config/db.js';
import { env } from '../config/env.js';

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  // In production, provide the service account key. 
  // For now, we assume it's set in the environment variables (GOOGLE_APPLICATION_CREDENTIALS)
  // or we initialize with default application credentials.
  admin.initializeApp({
    credential: admin.credential.applicationDefault()
  });
}

class AuthService {
  async verifyFirebaseToken(idToken) {
    try {
      // Development bypass
      if (process.env.NODE_ENV === 'development' && idToken === 'mock_token') {
        return {
          uid: 'dev_user_123',
          phone_number: '+919999999999',
          email: 'dev@trustmeds.com'
        };
      }
      const decodedToken = await admin.auth().verifyIdToken(idToken);
      return decodedToken;
    } catch (error) {
      throw new Error('Invalid or expired Firebase token: ' + error.message);
    }
  }

  async findOrCreateUser(firebaseUser, societyId = null) {
    const { uid: firebase_uid, phone_number } = firebaseUser;
    
    // Check if user exists
    const result = await query('SELECT * FROM users WHERE firebase_uid = $1', [firebase_uid]);
    
    if (result.rows.length > 0) {
      const user = result.rows[0];
      // Update society if provided
      if (societyId && user.society_id !== societyId) {
        const updateResult = await query(
          'UPDATE users SET society_id = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING *',
          [societyId, user.id]
        );
        return updateResult.rows[0];
      }
      return user;
    }
    
    // Create new user
    const insertResult = await query(
      `INSERT INTO users (firebase_uid, phone_number, society_id) 
       VALUES ($1, $2, $3) 
       RETURNING *`,
      [firebase_uid, phone_number, societyId]
    );
    
    return insertResult.rows[0];
  }

  generateJWT(user) {
    const payload = {
      userId: user.id,
      role: user.role
    };
    
    // The secret should be in env.jwt.secret
    return jwt.sign(payload, env.jwt.secret || 'trustmeds_secret_key', {
      expiresIn: env.jwt.expiresIn || '30d'
    });
  }

  // Placeholder for updating user profile if needed
  async updateProfile(userId, profileData) {
    const { fullName, email } = profileData;
    const result = await query(
      `UPDATE users SET name = $1, email = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $3 RETURNING *`,
      [fullName, email, userId]
    );
    return result.rows[0];
  }
}

export const authService = new AuthService();
