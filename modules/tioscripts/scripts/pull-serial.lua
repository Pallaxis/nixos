function shell_ready()
  tio.expect("~]# ")
end

-- Function to check if a process is running
local function is_process_running(pid)
  local handle = io.popen("ps -p " .. pid) -- For Unix/Linux
  local result = handle:read("*a")
  handle:close()
  return result:match(pid) ~= nil
end

tio.write("\n")

if not tio.expect("~]# ", 100) then
  tio.write("\n")
  tio.expect("login: ")
  tio.write("root\n")
  shell_ready()
end

-- Grabs serial
tio.write("oclea_info\n")
serial = ""
while true do
  local current_line = tio.readline()
  serial = current_line:match('"serial%-number"%s*:%s*"(.-)"')
  if serial then
    break
  end
end

local file, err = io.open("/home/henry/semix-serials.txt", "a+")

file:write(serial .. "\n")
file:seek("set", 0)

local linecount = 0

for _ in file:lines() do
  linecount = linecount + 1
end
print(linecount .. " current lines\n")
file:close()
