{
  description = "Le Flocon.";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:Naxdy/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

      spicetify-nix = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
    };
  };

outputs = { self,
           nixpkgs,
           spicetify-nix,
           zen-browser,
           ...
           } 
    @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
            ./configuration.nix
            spicetify-nix.nixosModules.default            
        ];
    };
};
}