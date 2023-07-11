local todos = require 'todos'

function add_task_option()
    io.write("Task: ")
    task_text = io.read("*line")
    todos.add(task_text)
end

function list_tasks_option()
    print("# Task")
    for index, task in ipairs(todos.all()) do
        print(task.id .. " " .. task.text)
    end
end

operations = {
    ["1"]=add_task_option,
    ["2"]=list_tasks_option
}

while (true) do
    print("[1] Add task")
    print("[2] List tasks")
    io.write(": ")
    option = io.read("*line")
    operation = operations[option] 
    if (operation == nil) then
        print("Invalid option")
    else
        operation()
    end
end