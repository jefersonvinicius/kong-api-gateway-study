local kong_meta = require "kong.meta"

local FileLoggerHandler = {
    VERSION = '1.0.0',
    PRIORITY = 1100,
}

local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end



function FileLoggerHandler:init_worker() 
    print('------- init_worker -------')
end

function FileLoggerHandler:access(conf)
    print("------ access ------")
    local file, err = io.open('/tmp/logs.txt', 'a')
    if not file then 
        print(err)
        return kong.response.exit(500, { message = 'Filelogger plugin error', details = err })
    end
    local request = kong.request
    local current_time = os.date("!%Y-%m-%dT%H:%M:%S") .. "Z"
    local url = request.get_scheme() .. '://' .. request.get_host() .. request.get_path_with_query()
    local log_line = '[' .. current_time .. '] ' .. kong.request.get_method() .. ': ' .. url .. "\n"
    print('Logging: ' .. log_line)
    file:write(log_line)
    file:close()
end

function FileLoggerHandler:response()
    kong.response.set_header('Logged-By', "FileLogger Plugin :D")
end

return FileLoggerHandler