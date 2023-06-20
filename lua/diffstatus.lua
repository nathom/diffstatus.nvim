local M = {}

M.index = {}

function M.update()
    update_index()
end

local function dirname(fn)
    return fn:match("(.+)%/")
end

local function parse_output(data)
    for _, l in ipairs(data) do
        print(l)
    end
end

local function on_event(job_id, data, event)
    if event == "stdout" then
        parse_output(data)
    elseif event == "stderr" then
        error(data)
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

return M
