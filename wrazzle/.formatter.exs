[
  import_deps: [:ecto, :phoenix, :plug],
  inputs:
    ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"] --
      ["lib/wrazzle_web/core_components.ex", "lib/wrazzle_web/layouts.ex"]
]
