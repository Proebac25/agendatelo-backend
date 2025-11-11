-- =============================================
-- PROYECTO: PWA_SQL_JAVA_RESTART
-- BASE DE DATOS: PostgreSQL (Supabase)
-- AUTOR: PROEBAC25
-- FECHA: 11/11/2025
-- VERSIÓN: V01
-- =============================================

-- Habilitar extensiones
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================
-- TABLA: users (usuarios profesionales y normales)
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('user', 'professional', 'admin')) DEFAULT 'user',
    full_name VARCHAR(100) NOT NULL,
    business_name VARCHAR(150),
    phone VARCHAR(20),
    profile_image VARCHAR(500),
    bio_description TEXT,
    location_city VARCHAR(100),
    website_url VARCHAR(500),
    verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para users
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_city ON users(location_city);

-- =============================================
-- TABLA: business_contacts (múltiples contactos por negocio)
-- =============================================
CREATE TABLE IF NOT EXISTS business_contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    contact_name VARCHAR(100) NOT NULL,
    contact_role VARCHAR(80),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    whatsapp BOOLEAN DEFAULT TRUE,
    is_main BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
);

-- Índices para contactos
CREATE INDEX IF NOT EXISTS idx_contacts_user ON business_contacts(user_id);

-- =============================================
-- TABLA: business_addresses (múltiples direcciones por negocio)
-- =============================================
CREATE TABLE IF NOT EXISTS business_addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(80) NOT NULL,
    street VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100),
    postal_code VARCHAR(10) NOT NULL,
    country VARCHAR(3) DEFAULT 'ES',
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    is_main BOOLEAN DEFAULT FALSE,
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
);

-- Índices para direcciones
CREATE INDEX IF NOT EXISTS idx_addresses_user ON business_addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_addresses_city ON business_addresses(city);
CREATE INDEX IF NOT EXISTS idx_addresses_postal ON business_addresses(postal_code);

-- =============================================
-- TABLA: events (eventos de EstaNoche.es y Agendatelo.es)
-- =============================================
CREATE TABLE IF NOT EXISTS events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_type VARCHAR(50) CHECK (event_type IN ('concert', 'party', 'cultural', 'workshop', 'other')),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE,
    address_id UUID REFERENCES business_addresses(id),
    price DECIMAL(10,2) DEFAULT 0.00,
    capacity INTEGER,
    tickets_sold INTEGER DEFAULT 0,
    is_public BOOLEAN DEFAULT TRUE,
    featured BOOLEAN DEFAULT FALSE,
    image_url VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para eventos
CREATE INDEX IF NOT EXISTS idx_events_creator ON events(creator_id);
CREATE INDEX IF NOT EXISTS idx_events_date ON events(start_date);
CREATE INDEX IF NOT EXISTS idx_events_type ON events(event_type);

-- =============================================
-- TRIGGERS: actualizar updated_at
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todas las tablas
CREATE TRIGGER trigger_update_users
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_update_contacts
    BEFORE UPDATE ON business_contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_update_addresses
    BEFORE UPDATE ON business_addresses
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_update_events
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- =============================================
-- COMENTARIOS FINALES
-- =============================================
COMMENT ON TABLE users IS 'Usuarios del sistema: profesionales, clientes y admins';
COMMENT ON TABLE business_contacts IS 'Múltiples contactos por negocio profesional';
COMMENT ON TABLE business_addresses IS 'Múltiples direcciones por negocio (sucursales, salas, etc.)';
COMMENT ON TABLE events IS 'Eventos publicados en EstaNoche.es y Agendatelo.es';