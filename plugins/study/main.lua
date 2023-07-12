local todos = require 'todos'

local message = nil

function clear_terminal()
    print("\x1b[2J\x1b[1;1H")
end

function add_task_option()
    io.write("Task: ")
    task_text = io.read("*line")
    todos.add(task_text)
    message = 'Task added'
end

function print_tasks_table(tasks) 
    print("\n\n# Task")
    if (#tasks == 0) then
        print "Empty"
        return
    end
    for index, task in ipairs(tasks) do
        print(task.id .. " " .. task.text)
    end
end 

function list_tasks_option()
    print_tasks_table(todos.all())
    io.write("\nPress any key to continue...")
    io.read()
end

function delete_tasks_option()
    tasks = todos.all()
    if (#tasks == 0) then
        message = 'Tasks not found'
        return
    end
    print_tasks_table(todos.all())
    io.write('\nTask id: ')
    task_id = tonumber(io.read("*line"))
    if (todos.exists(task_id) == false) then
        message = 'Task not found'
        return
    end
    todos.delete(task_id)
    message = 'Task deleted'
end

operations = {
    {label = "Add task", handler = add_task_option},
    {label = "List tasks", handler = list_tasks_option},
    {label = "Delete tasks", handler = delete_tasks_option}
}


while (true) do
    clear_terminal()
    print("TODOLISTAPP")
    if (message ~= nil) then
        print("\n>> " .. message .. " <<\n")
        message = nil
    end
    for index, operation in ipairs(operations) do
        print("[" .. index .. "] " .. operation.label)
    end
    io.write(": ")
    option = tonumber(io.read("*line"))
    operation = operations[option]
    if (operation == nil) then
        message = 'Invalid option'
    else
        operation.handler()
    end
end