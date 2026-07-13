local function shell_ready()
  tio.expect("~]# ")
end

tio.write("\n")

while true do
  if not tio.expect("~]# ", 100) then
    tio.write("\n")
    tio.expect("login: ")
    tio.write("root\n")
    shell_ready()
  end
  tio.write("clear\n")

  tio.write("hydra_provision -i 0 -s 0x0101 0x010f -s 0x0401 0x0f00 -s 0x0402 0x0870 -s 0x0403 0x001e -s 0x0103 0x0101\n")

  tio.expect("login: ")
end
