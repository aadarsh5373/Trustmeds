export const registerSocketServer = (io) => {
  io.on('connection', (socket) => {
    socket.on('join:user', (userId) => socket.join(`user:${userId}`));
    socket.on('join:delivery', (partnerId) =>
      socket.join(`delivery:${partnerId}`)
    );
    socket.on('join:pharmacist', () => socket.join('pharmacists'));
    socket.on('delivery:location', (payload) => {
      io.to(`user:${payload.userId}`).emit('delivery:location', payload);
    });
  });
};

export const socketEvents = {
  emitOrderPlaced: (io, order) => io.to('pharmacists').emit('order:new', order),
  emitOrderAssigned: (io, payload) =>
    io.to(`delivery:${payload.partnerId}`).emit('order:assigned', payload),
  emitOrderStatus: (io, payload) =>
    io.to(`user:${payload.userId}`).emit('order:status', payload)
};
