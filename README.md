# lerd-nixos

Unofficial NixOS flake for Lerd ( https://lerd.sh/ )

## Try it without installing

```sh
nix run github:aijorgenson/lerd-nixos -- --help
```

## Add it to your flake

Add this repo as an input, then pull the package into your configuration. The
flake exposes a package (`packages.<system>.lerd`, also the `default`) and an
overlay (`overlays.default`).

### 1. Add the input

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    lerd = {
      url = "github:aijorgenson/lerd-nixos";
      # Build lerd against your own nixpkgs instead of the one it pins,
      # so you don't download a second copy of nixpkgs:
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, lerd, ... }: {
    # ... your outputs (see below) ...
  };
}
```

### 2a. Use the package directly

In a NixOS `configuration.nix` (or any module), reference the package by system:

```nix
{ pkgs, ... }:
{
  environment.systemPackages = [
    lerd.packages.${pkgs.system}.default
  ];
}
```

To make `lerd` available to your `outputs`, pass it through `specialArgs`:

```nix
nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit lerd; };
  modules = [ ./configuration.nix ];
};
```

### 2b. Or use the overlay

Applying the overlay adds `pkgs.lerd`, so it behaves like any other package:

```nix
{ pkgs, lerd, ... }:
{
  nixpkgs.overlays = [ lerd.overlays.default ];

  environment.systemPackages = [ pkgs.lerd ];
}
```

### Home Manager

Same idea — reference the package by system:

```nix
home.packages = [ lerd.packages.${pkgs.system}.default ];
```

## Supported systems

`x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`.
