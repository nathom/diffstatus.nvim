local M = {}

--- Filename to 3 item table containing removed and added lines
M.index = {}
local stdout_lines = {}

-- local function stprint(t)
--     local s = {}
--     for k, v in pairs(t) do
--         if type(v) == "table" then
--             v = stprint(v)
--         end
--         table.insert(s, k .. " = " .. v)
--     end
--     return "{\n" .. table.concat(s, ",\n    ") .. "\n}"
-- end
--
-- local function tprint(t)
--     print(stprint(t))
-- end

local function dirname(fn)
    return fn:match("(.+)%/")
end

local function parse_output()
    for _, line in ipairs(stdout_lines) do
        local added, removed, file = line:match("(%d+)%s+(%d+)%s+(%S+)")
        if added ~= nil and removed ~= nil and file ~= nil then
            M.index[file] = { tonumber(added), tonumber(removed) }
        end
    end
end

local function on_event(job_id, data, event)
    if event == "stdout" then
        for _, d in ipairs(data) do
            table.insert(stdout_lines, d)
        end
    elseif event == "exit" then
        if data == 0 then
            parse_output()
        end
        -- ignore error
    end
end

local function update_index()
    local abs_path = vim.api.nvim_buf_get_name(0)
    command = { "git", "diff", "--numstat" }
    command_str = table.concat(command, " ")
    vim.fn.jobstart(command_str, {
        on_stdout = on_event,
        on_stderr = on_event,
        on_exit = on_event,
        stdout_buffered = false,
        stderr_buffered = false,
    })
end

function M.update()
    update_index()
end

return M
