local todos = require 'todos'

local message = nil

function clear_terminal()
    print("\x1b[2J\x1b[1;1H")
end

function add_task_option()
    io.write("Task: ")
    local task_text = io.read("*line")
    todos.add(task_text)
    message = 'Task added'
end

function print_tasks_table(tasks) 
    print("\n\n# Task")
    if (todos.isempty()) then
        print "Empty"
        return
    end
    for id, task in pairs(tasks) do
        print(id .. " " .. task.text)
    end
end 

function list_tasks_option()
    print_tasks_table(todos.all())
    io.write("\nPress any key to continue...")
    io.read()
end

function delete_tasks_option()
    tasks = todos.all()
    if (todos.isempty()) then
        message = 'Tasks not found'
        return
    end
    print_tasks_table(todos.all())
    io.write('\nTask id: ')
    local task_id = tonumber(io.read("*line"))
    if (todos.exists(task_id) == false) then
        message = 'Task not found'
        return
    end
    todos.delete(task_id)
    message = 'Task deleted'
end

function export_tasks_option()
    if (todos.isempty()) then
        return
    end
    local current_time = os.time()
    local filename = os.date('%d_%m_%Y_%H_%M_%S', current_time) .. '.todos'
    local file = io.open(filename, 'w')
    local title = 'TASKS ' .. os.date('%d/%m/%Y %H:%M:%S', current_time) .. '\n'
    file:write(title)
    for id, task in pairs(todos.all()) do
        file:write(id .. ' - ' .. task.text .. '\n')
    end
    file:close()
end

operations = {
    {label = "Add task", handler = add_task_option},
    {label = "List tasks", handler = list_tasks_option},
    {label = "Delete tasks", handler = delete_tasks_option},
    {label = "Export to file", handler = export_tasks_option}
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
    local option = tonumber(io.read("*line"))
    local operation = operations[option]
    if (operation == nil) then
        message = 'Invalid option'
    else
        operation.handler()
    end
end