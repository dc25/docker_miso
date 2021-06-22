#! /bin/bash 

echo "installing nix build system"

sudo apt-get install -y xz-utils

curl -L https://nixos.org/nix/install | sh
## curl https://nixos.org/releases/nix/nix-2.1.3/install | sh

. ~/.nix-profile/etc/profile.d/nix.sh

nix-env -f "<nixpkgs>" -iA haskellPackages.aeson
nix-env -f "<nixpkgs>" -iA haskellPackages.HTTP
nix-env -f "<nixpkgs>" -iA haskellPackages.ghcid

## per https://hie-nix.cachix.org/
nix-env -f https://cachix.org/api/v1/install -iA cachix 
