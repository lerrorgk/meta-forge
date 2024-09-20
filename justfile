auth:
  rattler-build auth login repo.prefix.dev --token $PREFIX_TOKEN

cache:
  -rm output
  mkdir -p $HOME/.cache/prefix && ln -sf $HOME/.cache/prefix $PWD/output

build target:
  rattler-build build -r {{target}}/recipe.yaml --no-include-recipe

build-all: cache
  rattler-build build --recipe-dir . --no-include-recipe
