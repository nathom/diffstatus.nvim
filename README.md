# diffstatus.nvim

A lightweight lua plugin that gives you the number of lines
added/removed in a file using git.

## Usage

```lua

-- mapping from filename to a 2 item table containing lines
-- added and removed

local index = require('diffstatus').index

for filename, status in pairs(index) do

    print(filename .. ': ' .. status[1] .. ' lines added,
' .. status[2] .. 'lines removed')

end

```

