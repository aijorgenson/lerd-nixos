{ lib, buildGoModule, buildNpmPackage, fetchFromGitHub }:

let
  version = "1.26.2";
  src = fetchFromGitHub {
    owner = "geodro"; repo = "lerd"; rev = "v${version}";
    hash = lib.fakeHash;
  };
  ui = buildNpmPackage {
    pname = "lerd-ui"; inherit version src;
    sourceRoot = "${src.name}/internal/ui/web";
    npmDepsHash = lib.fakeHash;
    installPhase = "runHook preInstall; cp -r dist $out; runHook postInstall";
  };
in
buildGoModule {
  pname = "lerd"; inherit version src;
  vendorHash = lib.fakeHash;
  subPackages = [ "cmd/lerd" ];
  tags = [ "nogui" ];
  env.CGO_ENABLED = 0;
  ldflags = [
    "-s" "-w"
    "-X github.com/geodro/lerd/internal/version.Version=${version}"
    "-X github.com/geodro/lerd/internal/version.Commit=v${version}"
    "-X github.com/geodro/lerd/internal/version.Date=1970-01-01T00:00:00Z"
  ];
  preBuild = "cp -r ${ui} internal/ui/web/dist";
  meta = {
    description = "Herd-like local PHP development for Linux and macOS";
    homepage = "https://lerd.sh";
    license = lib.licenses.mit;
    mainProgram = "lerd";
    platforms = lib.platforms.unix;
  };
}
