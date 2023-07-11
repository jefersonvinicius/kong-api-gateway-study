local todos = {}
local current_id = 1

function todos.add(task_text)
    todo = {id=current_id,text=task_text}
    table.insert(todos, todo)
    current_id = current_id + 1
    return todo
end

function todos.all()
    return todos
end

return todos
