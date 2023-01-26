#!@shell@

export PATH=@path@

echo "Regenrating nix mix lock file"
@mix2nix@ > nix/mix.nix

echo "Updating appsignal json"
@mix@ deps.get
@mix@ nix.appsignal
