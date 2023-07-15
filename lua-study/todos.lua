local todos = {}
local todos_list = {}
local current_id = 1

function todos.add(task_text)
    todo = {id=current_id,text=task_text}
    todos_list[todo.id] = todo
    current_id = current_id + 1
    return todo
end

function todos.all()
    return todos_list
end

function todos.exists(task_id) 
    return todos_list[task_id] ~= nil
end

function todos.size()
    count = 0
    for key in pairs(todos_list) do
        count = count + 1
    end
    return count
end

function todos.isempty()
    return todos.size() == 0
end

function todos.delete(task_id)
    todos_list[task_id] = nil
end

return todos
