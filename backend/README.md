# TrustMeds Backend

Production-ready backend scaffold for a hyperlocal e-pharmacy app optimized for:
- Flutter customer app
- Flutter delivery partner app
- Admin/pharmacist panels

## Stack
- Node.js + Express
- PostgreSQL
- Redis + BullMQ
- JWT auth
- Socket.IO
- AWS S3 uploads

## Folder Structure
```text
backend/
  db/
    schema.sql
  src/
    app.js
    server.js
    config/
      db.js
      env.js
      redis.js
      s3.js
    common/
      middleware/
      queue/
      socket/
      utils/
    modules/
      auth/
      users/
      products/
      orders/
      pharmacist/
      payments/
      delivery/
      admin/
    routes/
      index.js
```

## Core APIs
- `POST /api/v1/auth/request-otp`
- `POST /api/v1/auth/verify-otp`
- `GET /api/v1/users/me`
- `GET /api/v1/users/addresses`
- `POST /api/v1/users/prescriptions/upload-url`
- `GET /api/v1/products`
- `GET /api/v1/products/search?q=paracetamol`
- `GET /api/v1/products/:id/substitutes`
- `POST /api/v1/orders`
- `PATCH /api/v1/orders/:id/status`
- `PATCH /api/v1/orders/:id/assign-delivery`
- `GET /api/v1/pharmacist/orders/incoming`
- `PATCH /api/v1/pharmacist/orders/:id/prescription`
- `GET /api/v1/delivery/orders/assigned`
- `POST /api/v1/delivery/location`
- `GET /api/v1/admin/dashboard`

## Real-Time Events
- `order:new`
- `order:assigned`
- `order:status`
- `delivery:location`

## Scale Notes
- Use PostgreSQL search indexes on medicine `name` and `salt`
- Cache search results and popular catalog queries in Redis
- Push notifications and analytics fan-out through BullMQ workers
- Paginate all list endpoints
- Emit live order and delivery events with Socket.IO rooms
