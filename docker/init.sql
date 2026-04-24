-- Create todos table
CREATE TABLE IF NOT EXISTS todos (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on completed status for faster queries
CREATE INDEX IF NOT EXISTS idx_todos_completed ON todos(completed);

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_todos_updated_at BEFORE UPDATE ON todos
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data
INSERT INTO todos (title, description, completed) VALUES
    ('Настроить PostgreSQL', 'Установить и настроить базу данных', true),
    ('Создать API', 'Разработать REST API с FastAPI', true),
    ('Создать фронтенд', 'Разработать простой UI', false),
    ('Деплой на сервер', 'Развернуть приложение на production', false);
