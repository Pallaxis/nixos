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

  tio.write("hydra_provision -i 0 -e\n")
  tio.expect("~]# ")
end
