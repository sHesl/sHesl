{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
    };

    outputs = { self, nixpkgs }: {
        packages."aarch64-darwin".default = let
            pkgs = nixpkgs.legacyPackages."aarch64-darwin";
        in pkgs.buildEnv {
            name = "home-packages";
            paths = with pkgs; [
                awscli2
                git
                go
                google-cloud-sdk
                kind
                k9s
                ko
                kubectl
                mage
                opentofu
                skopeo
                zig
            ];
        };
    };
}
