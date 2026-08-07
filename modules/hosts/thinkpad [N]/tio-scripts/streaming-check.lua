-- Script expects that it is running before device has been booted
function shell_ready()
  tio.expect("~]# ")
end

tio.write("\n")

while true do
  --   -- Puts SoM into EVK2 mode for this boot only SoM only for others
  --   while true do
  --     tio.write("t")
  --     if tio.readline():find("5. Continue booting") then
  --       print("PASSED")
  --       tio.write("2\n")
  --       tio.msleep("200")
  --       tio.write("4\n")
  --       tio.msleep("200")
  --       tio.write("5\n")
  --       break
  --     end
  --   end

  -- while not tio.expect("~]# ", 1000) do
  --   if tio.expect("login: ", 1000) then
  --     tio.write("root\n")
  --     if not tio.expect("~]# ", 5000) then
  --       print("Root login failed or shell did not appear")
  --     end
  --   else
  --     tio.write("\n")
  --     print("else statement")
  --   end
  -- end

  while true do
    local line, partial = tio.readline(1000)
    local data = line or partial

    if data then
      print("RX: " .. data)

      if data:match("~%]#") then
        print("Shell ready")
        break
      elseif data:match("login:") then
        print("Logging in")
        tio.write("root\n")
        tio.expect("~]#")
        break
      end
    else
      -- no line received, wake device
      print("No new line")
      tio.write("\n")
    end
  end

  -- Grabs serial
  tio.write("oclea_info\n")
  local serial, version
  while true do
    local current_line = tio.readline()

    local current_serial = current_line:match('"serial%-number"%s*:%s*"(.-)"')
    if current_serial then
      serial = current_serial
    end

    local found_ver = current_line:match('"oclea%-version"%s*:%s*"([^"]+)"')
    if found_ver then
      version = found_ver
    end

    if serial and version then
      break
    end
  end

  -- Grabs IP addr
  tio.write("ip a show eth0\n")
  ip = ""
  while true do
    local current_line = tio.readline()
    ip = current_line:match("%f[%a]inet%f[%A]%s+(%d+%.%d+%.%d+%.%d+)")
    if ip then
      break
    end
  end

  -- Provision sensor, modprobe driver

  -- IMX327
  tio.write("hydra_provision -i 0 -s 0x0101 0x0103 -s 0x0401 0x0780 -s 0x0402 0x0438 -s 0x0403 0x001e -s 0x0103 0x0101\n")

  -- IMX415
  -- tio.write("hydra_provision -i 0 -s 0x0101 0x0106 -s 0x0401 0x0f00 -s 0x0402 0x0870 -s 0x0403 0x001e -s 0x0103 0x0101 -s 0x0102 0x0037\n")

  -- tio.expect("~]# ")

  tio.write("hydra\n")
  tio.expect("~]# ")

  -- clears history, fine to do here because we don't use poweroff or restart
  tio.write("rm ~/.bash_history\n")
  tio.expect("~]# ")

  -- Start and pick up stream with ffplay storing pid for later
  tio.write("oclea_gstreamer_interactive_example -r\n")
  tio.expect(">>>")
  local command = "sh -c 'setsid ffplay -fflags nobuffer -flags low_delay -probesize 32 -analyzeduration 1 rtsp://" .. ip .. ":8554/test >/dev/null 2>&1 & echo $!'"
  print(command)
  local fh = io.popen(command, "r")
  local pid = tonumber(fh:read("*l"))
  fh:close()

  tio.msleep("8000")
  print(serial .. " " .. version)
  os.execute("kill -TERM -" .. pid)
  tio.write("exit\n")
  tio.expect("~]# ")

  -- remove provision

  tio.write("hydra_provision -i 0 -e\n")
  tio.expect("~]# ")
end
