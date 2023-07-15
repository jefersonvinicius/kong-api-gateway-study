-- Copyright (C) Kong Inc.
local access = require "kong.plugins.basic-auth.access"
local kong_meta = require "kong.meta"

local FileLoggerHandler = {
    VERSION = '1.0.0',
    PRIORITY = 1100,
}


function FileLoggerHandler:access(conf)
    print('HEEEY')
    print(conf)
    access.execute(conf)
end

return FileLoggerHandler