create extension if not exists "uuid-ossp";

create type user_role as enum ('admin', 'pharmacist', 'delivery_partner', 'customer');
create type order_status as enum ('pending', 'verified', 'packed', 'out_for_delivery', 'delivered', 'cancelled');
create type payment_method as enum ('upi', 'cod');
create type payment_status as enum ('pending', 'paid', 'failed', 'refunded', 'cod_due', 'cod_collected');
create type prescription_status as enum ('pending', 'approved', 'rejected');

create table users (
  id uuid primary key default uuid_generate_v4(),
  mobile varchar(10) unique not null,
  role user_role not null default 'customer',
  full_name varchar(150),
  email varchar(150),
  wallet_balance numeric(12,2) not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table user_addresses (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references users(id) on delete cascade,
  label varchar(50) not null,
  line1 varchar(255) not null,
  line2 varchar(255),
  landmark varchar(255),
  city varchar(100) not null,
  state varchar(100) not null,
  pincode varchar(6) not null,
  latitude numeric(10,7),
  longitude numeric(10,7),
  is_default boolean not null default false,
  created_at timestamptz not null default now()
);

create table medicines (
  id uuid primary key default uuid_generate_v4(),
  name varchar(200) not null,
  salt varchar(200) not null,
  brand varchar(150) not null,
  price numeric(12,2) not null,
  stock integer not null default 0,
  expiry_date date not null,
  batch_no varchar(100) not null,
  supplier_name varchar(150),
  search_vector tsvector generated always as (
    to_tsvector('simple', coalesce(name, '') || ' ' || coalesce(salt, ''))
  ) stored,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index idx_medicines_search on medicines using gin(search_vector);
create index idx_medicines_salt on medicines(salt);
create index idx_medicines_expiry on medicines(expiry_date);

create table prescriptions (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references users(id) on delete cascade,
  s3_key varchar(255) not null,
  file_url text not null,
  file_type varchar(20) not null,
  status prescription_status not null default 'pending',
  reviewed_by uuid references users(id),
  rejection_reason text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

create table orders (
  id uuid primary key default uuid_generate_v4(),
  order_number varchar(40) unique not null,
  user_id uuid not null references users(id),
  address_id uuid references user_addresses(id),
  prescription_id uuid references prescriptions(id),
  delivery_partner_id uuid references users(id),
  total_amount numeric(12,2) not null,
  status order_status not null default 'pending',
  created_at timestamptz not null default now(),
  verified_at timestamptz,
  packed_at timestamptz,
  out_for_delivery_at timestamptz,
  delivered_at timestamptz
);

create table order_items (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references orders(id) on delete cascade,
  medicine_id uuid references medicines(id),
  medicine_name varchar(200) not null,
  quantity integer not null,
  unit_price numeric(12,2) not null,
  total_price numeric(12,2) not null
);

create table payments (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references orders(id) on delete cascade,
  amount numeric(12,2) not null,
  method payment_method not null,
  status payment_status not null default 'pending',
  transaction_reference varchar(120),
  refund_reference varchar(120),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table delivery_locations (
  id uuid primary key default uuid_generate_v4(),
  order_id uuid not null references orders(id) on delete cascade,
  delivery_partner_id uuid not null references users(id),
  latitude numeric(10,7) not null,
  longitude numeric(10,7) not null,
  captured_at timestamptz not null default now()
);

create table suppliers (
  id uuid primary key default uuid_generate_v4(),
  name varchar(150) not null,
  contact_name varchar(150),
  contact_phone varchar(15),
  gst_number varchar(50),
  created_at timestamptz not null default now()
);

create table audit_logs (
  id uuid primary key default uuid_generate_v4(),
  actor_id uuid references users(id),
  actor_role user_role,
  action varchar(100) not null,
  entity_type varchar(100) not null,
  entity_id uuid,
  metadata jsonb,
  created_at timestamptz not null default now()
);
