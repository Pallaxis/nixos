# Compares the running kernel with the latest upstream

current_kernel=$(uname -r)
latest_kernel=$(nix eval --raw nixpkgs\#linuxPackages_latest.kernel.version)
oldest_kernel_version=$(printf "%s\n%s" "$current_kernel" "$latest_kernel" | sort -V | head -n1)

if [[ "$current_kernel" != "$latest_kernel" ]] && [[ "$current_kernel" == "$oldest_kernel_version" ]]; then
  echo "{\"text\": \" Kernel: $current_kernel\", \"tooltip\": \"Latest available: $latest_kernel\", \"class\": \"warning\"}"
  exit 0
else
  exit 0
fi
