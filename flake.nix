{
  description = "Skrips";

  edition = 201909;

  outputs = { self }:
    let
      pname = "skrips";
      version = self.shortRev;

    in {
      core.ol = { stdenv, sd, mksh }@args:
        stdenv.mkDerivation rec {
          inherit pname version;

          src = self;

          nativeBuildInputs = [ mksh.ol ];

          buildPhase = let
            sd = args.sd + "/bin/sd";
            mksheBang = "#!" + mksh.ol + "/bin/mksh";

            in ''
              ${sd} --string-mode '#!/bin/mksh' '${mksheBang}' src/*
              chmod 755 src/*
            '';

          installPhase = ''
            mkdir --parents $out/bin/
            for file in src/*
            do
              mv "$file" $out/bin/$${file%.mksh}
            done
          '';

        };
  };
}
