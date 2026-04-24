import { ambulanceService } from '../services/ambulance.service.js';

export const requestAmbulance = async (req, res, next) => {
  try {
    const { latitude, longitude, type } = req.body;
    const userId = req.user ? req.user.id : '00000000-0000-0000-0000-000000000000'; // Mock for now
    const request = await ambulanceService.registerRequest(userId, latitude, longitude, type);
    res.status(201).json({ success: true, request });
  } catch (error) {
    next(error);
  }
};

export const updateLocation = async (req, res, next) => {
  try {
    const { vehicleId, latitude, longitude } = req.body;
    await ambulanceService.updateVehicleLocation(vehicleId, latitude, longitude);
    res.json({ success: true, message: 'Location updated' });
  } catch (error) {
    next(error);
  }
};

export const assignVehicle = async (req, res, next) => {
  try {
    const { requestId, vehicleId } = req.body;
    const request = await ambulanceService.assignVehicle(requestId, vehicleId);
    res.json({ success: true, request });
  } catch (error) {
    next(error);
  }
};
