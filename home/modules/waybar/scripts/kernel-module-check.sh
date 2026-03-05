# Compares the running kernel with the latest upstream

current_kernel=$(uname -r)
latest_kernel=$(nix eval --raw nixpkgs\#linuxPackages_latest.kernel.version)

if [[ "$current_kernel" == "$latest_kernel" ]]; then
  exit 0
else
  echo "{\"text\": \" Kernel: $current_kernel\", \"tooltip\": \"Latest available: $latest_kernel\", \"class\": \"warning\"}"
  exit 0
fi
