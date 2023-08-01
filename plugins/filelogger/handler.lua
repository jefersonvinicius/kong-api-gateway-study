local access = require "kong.plugins.basic-auth.access"
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

function FileLoggerHandler:access(conf)
    print("------> access <------")
    print(dump(conf))
    access.execute(conf)
end

return FileLoggerHandler