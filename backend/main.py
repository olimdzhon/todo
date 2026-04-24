from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import asyncpg
import os
from contextlib import asynccontextmanager

# Database connection pool
db_pool = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    global db_pool
    db_pool = await asyncpg.create_pool(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "5432")),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "postgres"),
        database=os.getenv("DB_NAME", "todos_db"),
        min_size=1,
        max_size=10
    )
    yield
    await db_pool.close()

app = FastAPI(title="TODO API", lifespan=lifespan)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TodoCreate(BaseModel):
    title: str
    description: Optional[str] = None
    completed: bool = False

class TodoUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    completed: Optional[bool] = None

class Todo(BaseModel):
    id: int
    title: str
    description: Optional[str]
    completed: bool

@app.get("/")
async def root():
    return {"message": "TODO API is running"}

@app.get("/todos", response_model=list[Todo])
async def get_todos():
    async with db_pool.acquire() as conn:
        rows = await conn.fetch("SELECT id, title, description, completed FROM todos ORDER BY id DESC")
        return [dict(row) for row in rows]

@app.post("/todos", response_model=Todo, status_code=201)
async def create_todo(todo: TodoCreate):
    async with db_pool.acquire() as conn:
        row = await conn.fetchrow(
            "INSERT INTO todos (title, description, completed) VALUES ($1, $2, $3) RETURNING id, title, description, completed",
            todo.title, todo.description, todo.completed
        )
        return dict(row)

@app.put("/todos/{todo_id}", response_model=Todo)
async def update_todo(todo_id: int, todo: TodoUpdate):
    async with db_pool.acquire() as conn:
        existing = await conn.fetchrow("SELECT * FROM todos WHERE id = $1", todo_id)
        if not existing:
            raise HTTPException(status_code=404, detail="Todo not found")

        update_data = todo.dict(exclude_unset=True)
        if not update_data:
            return dict(existing)

        set_clause = ", ".join([f"{key} = ${i+2}" for i, key in enumerate(update_data.keys())])
        query = f"UPDATE todos SET {set_clause} WHERE id = $1 RETURNING id, title, description, completed"

        row = await conn.fetchrow(query, todo_id, *update_data.values())
        return dict(row)

@app.delete("/todos/{todo_id}", status_code=204)
async def delete_todo(todo_id: int):
    async with db_pool.acquire() as conn:
        result = await conn.execute("DELETE FROM todos WHERE id = $1", todo_id)
        if result == "DELETE 0":
            raise HTTPException(status_code=404, detail="Todo not found")
        return None
