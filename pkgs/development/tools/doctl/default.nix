{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "doctl";
  version = "1.53.0";

  vendorSha256 = null;

  doCheck = false;

  subPackages = [ "cmd/doctl" ];

  buildFlagsArray = let t = "github.com/digitalocean/doctl"; in ''
    -ldflags=
    -X ${t}.Major=${lib.versions.major version}
    -X ${t}.Minor=${lib.versions.minor version}
    -X ${t}.Patch=${lib.versions.patch version}
    -X ${t}.Label=release
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    export HOME=$(mktemp -d) # attempts to write to /homeless-shelter
    for shell in bash fish zsh; do
      $out/bin/doctl completion $shell > doctl.$shell
      installShellCompletion doctl.$shell
    done
  '';

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "doctl";
    rev = "v${version}";
    sha256 = "1zw6gdmy1jlwi7rrbdxg7pkiq54ha0h1gmzphn3mflfk7lmgyikm";
  };

  meta = with lib; {
    description = "A command line tool for DigitalOcean services";
    homepage = "https://github.com/digitalocean/doctl";
    license = licenses.asl20;
    maintainers = [ maintainers.siddharthist ];
  };
}
