{
  buildNpmPackage,
  importNpmLock,
  optionsJSON,
}:
buildNpmPackage {
  name = "mnw-docs";
  src = ./.;

  npmDeps = importNpmLock {
    npmRoot = ./.;
  };

  inherit (importNpmLock) npmConfigHook;
  env.MNW_OPTIONS_JSON = optionsJSON;

  # VitePress hangs if you don't pipe the output into a file
  buildPhase = ''
    runHook preBuild

      local exit_status=0
      npm run build > build.log 2>&1 || {
          exit_status=$?
          :
      }
      cat build.log
      return $exit_status

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mv .vitepress/dist $out

    runHook postInstall
  '';
}
