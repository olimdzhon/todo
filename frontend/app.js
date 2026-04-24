const API_URL = "/api";
let currentFilter = "all";
let todos = [];

// Load todos on page load
document.addEventListener("DOMContentLoaded", () => {
  loadTodos();
});

async function loadTodos() {
  try {
    const response = await fetch(`${API_URL}/todos`);
    if (!response.ok) throw new Error("Failed to fetch todos");
    todos = await response.json();
    renderTodos();
  } catch (error) {
    console.error("Error loading todos:", error);
    showError("Не удалось загрузить задачи. Проверьте подключение к API.");
  }
}

async function addTodo() {
  const titleInput = document.getElementById("todoTitle");
  const descriptionInput = document.getElementById("todoDescription");

  const title = titleInput.value.trim();
  const description = descriptionInput.value.trim();

  if (!title) {
    alert("Введите название задачи");
    return;
  }

  try {
    const response = await fetch(`${API_URL}/todos`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title,
        description: description || null,
        completed: false,
      }),
    });

    if (!response.ok) throw new Error("Failed to create todo");

    const newTodo = await response.json();
    todos.unshift(newTodo);

    titleInput.value = "";
    descriptionInput.value = "";

    renderTodos();
  } catch (error) {
    console.error("Error adding todo:", error);
    showError("Не удалось добавить задачу");
  }
}

async function toggleTodo(id) {
  const todo = todos.find((t) => t.id === id);
  if (!todo) return;

  try {
    const response = await fetch(`${API_URL}/todos/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        completed: !todo.completed,
      }),
    });

    if (!response.ok) throw new Error("Failed to update todo");

    const updatedTodo = await response.json();
    const index = todos.findIndex((t) => t.id === id);
    todos[index] = updatedTodo;

    renderTodos();
  } catch (error) {
    console.error("Error toggling todo:", error);
    showError("Не удалось обновить задачу");
  }
}

async function deleteTodo(id) {
  if (!confirm("Вы уверены, что хотите удалить эту задачу?")) return;

  try {
    const response = await fetch(`${API_URL}/todos/${id}`, {
      method: "DELETE",
    });

    if (!response.ok) throw new Error("Failed to delete todo");

    todos = todos.filter((t) => t.id !== id);
    renderTodos();
  } catch (error) {
    console.error("Error deleting todo:", error);
    showError("Не удалось удалить задачу");
  }
}

async function editTodo(id) {
  const todo = todos.find((t) => t.id === id);
  if (!todo) return;

  const newTitle = prompt("Новое название:", todo.title);
  if (!newTitle || newTitle === todo.title) return;

  try {
    const response = await fetch(`${API_URL}/todos/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        title: newTitle,
      }),
    });

    if (!response.ok) throw new Error("Failed to update todo");

    const updatedTodo = await response.json();
    const index = todos.findIndex((t) => t.id === id);
    todos[index] = updatedTodo;

    renderTodos();
  } catch (error) {
    console.error("Error editing todo:", error);
    showError("Не удалось изменить задачу");
  }
}

function filterTodos(filter) {
  currentFilter = filter;

  document.querySelectorAll(".filter-btn").forEach((btn) => {
    btn.classList.remove("active");
  });
  event.target.classList.add("active");

  renderTodos();
}

function renderTodos() {
  const todoList = document.getElementById("todoList");

  let filteredTodos = todos;
  if (currentFilter === "active") {
    filteredTodos = todos.filter((t) => !t.completed);
  } else if (currentFilter === "completed") {
    filteredTodos = todos.filter((t) => t.completed);
  }

  if (filteredTodos.length === 0) {
    todoList.innerHTML = `
            <div class="empty-state">
                <h2>Нет задач</h2>
                <p>Добавьте новую задачу, чтобы начать</p>
            </div>
        `;
    return;
  }

  todoList.innerHTML = filteredTodos
    .map(
      (todo) => `
        <div class="todo-item ${todo.completed ? "completed" : ""}">
            <input
                type="checkbox"
                class="todo-checkbox"
                ${todo.completed ? "checked" : ""}
                onchange="toggleTodo(${todo.id})"
            />
            <div class="todo-content">
                <h3>${escapeHtml(todo.title)}</h3>
                ${todo.description ? `<p>${escapeHtml(todo.description)}</p>` : ""}
            </div>
            <div class="todo-actions">
                <button class="btn-edit" onclick="editTodo(${todo.id})">Изменить</button>
                <button class="btn-delete" onclick="deleteTodo(${todo.id})">Удалить</button>
            </div>
        </div>
    `,
    )
    .join("");
}

function escapeHtml(text) {
  const div = document.createElement("div");
  div.textContent = text;
  return div.innerHTML;
}

function showError(message) {
  alert(message);
}

// Allow adding todo with Enter key
document.addEventListener("DOMContentLoaded", () => {
  const titleInput = document.getElementById("todoTitle");
  const descriptionInput = document.getElementById("todoDescription");

  [titleInput, descriptionInput].forEach((input) => {
    input.addEventListener("keypress", (e) => {
      if (e.key === "Enter") {
        addTodo();
      }
    });
  });
});
