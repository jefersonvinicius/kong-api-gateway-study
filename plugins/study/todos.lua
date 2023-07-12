local todos = {}
local current_id = 1

function todos.add(task_text)
    todo = {id=current_id,text=task_text}
    todos[todo.id] = todo
    current_id = current_id + 1
    return todo
end

function todos.all()
    return todos
end

function todos.exists(task_id) 
    return todos[task_id] ~= nil
end

function todos.delete(task_id)
    table.remove(todos, task_id)
end

return todos
