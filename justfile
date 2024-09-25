cache:
  -rm output
  mkdir -p $HOME/.cache/prefix && ln -sf $HOME/.cache/prefix "$PWD/output"

build target: cache
  rattler-build build -r {{target}}/"recipe.yaml" \
  {{ if path_exists(join(target, "variant_config.yaml")) == 'true' { "--variant-config " + join(target, "variant_config.yaml") } else { "" } }} \
  --no-include-recipe \
  --experimental \
  -vvvv \
  # --no-build-id

build-all: cache
  rattler-build build --recipe-dir . --no-include-recipe
