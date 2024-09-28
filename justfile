build_output := env_var('HOME') / ".cache" / "prefix"

cache:
  -rm output
  mkdir -p {{ build_output }} && ln -sf {{ build_output }} "$PWD/output"

build target: cache
  - just clean {{ target }}
  rattler-build build -r {{target}}/"recipe.yaml" \
  {{ if path_exists(join(target, "variant_config.yaml")) == 'true' { "--variant-config " + join(target, "variant_config.yaml") } else { "" } }} \
  --no-include-recipe \
  --no-build-id --keep-build \
  --experimental \

clean name:
  -rm -rf ../output/bld/rattler-build_{{name}}/
  -rm -rf ../output/**/{{name}}-*

build-all: cache
  rattler-build build --recipe-dir . --no-include-recipe

dev env_name="dev":
  pixi project export conda-explicit-spec . -vvvv
  micromamba create -n {{env_name}} --file default_linux-64_conda_spec.txt

channel:
  python -m http.server 8000 -d output

lock:
  -rm pixi.toml pixi.lock
  pixi init --import environment.yml
  pixi project export conda-explicit-spec . -vvvv

test-venv package:
  micromamba info --json | jq -r '.["package cache"][]' | xargs -I {} find {} -name "{{ package }}*" | xargs -I {} rm -rf {}
  micromamba create -c {{ build_output }} -n temp {{ package }} --yes
