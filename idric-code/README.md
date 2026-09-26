# All Idriç code

This directory exists so supervision of an Idriç language change has one place
to see the current source migration surface.

The canonical machine-readable inventory lives in
`isomorphisms/ai-ci/idric/source-inventory-v1.tsv`. This file is the
human-facing Cockswain projection.

## Must follow Idriç changes

### isomorphisms/ai-ci

- [`benchmarks/iridium-2014/IdricBench.idric`](https://github.com/isomorphisms/ai-ci/blob/main/benchmarks/iridium-2014/IdricBench.idric)
- [`tests/fixtures/coupled-bad-partial/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-bad-partial/coupled-substitution.idric)
- [`tests/fixtures/coupled-bad-precheck/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-bad-precheck/coupled-substitution.idric)
- [`tests/fixtures/coupled-bad-signature/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-bad-signature/coupled-substitution.idric)
- [`tests/fixtures/coupled-good/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-good/coupled-substitution.idric)

### isomorphismes/pauli

- [`raytracer/RayTracer.idric`](https://github.com/isomorphismes/pauli/blob/main/raytracer/RayTracer.idric)
- [`raytracer/RayTracerTypes.idric`](https://github.com/isomorphismes/pauli/blob/main/raytracer/RayTracerTypes.idric)

### isomorphismes/Conway

- [`wallpapers/ConwayWallpaper.idric`](https://github.com/isomorphismes/Conway/blob/main/wallpapers/ConwayWallpaper.idric)

### isomorphismes/hopf_fibration

- [`src/GenerateHeader.idric`](https://github.com/isomorphismes/hopf_fibration/blob/master/src/GenerateHeader.idric)
- [`src/GenerateSource.idric`](https://github.com/isomorphismes/hopf_fibration/blob/master/src/GenerateSource.idric)
- [`src/Hopf.idric`](https://github.com/isomorphismes/hopf_fibration/blob/master/src/Hopf.idric)

### isomorphismes/theta

- [`src/BrowserMain.idric`](https://github.com/isomorphismes/theta/blob/main/src/BrowserMain.idric)
- [`src/Main.idric`](https://github.com/isomorphismes/theta/blob/main/src/Main.idric)
- [`src/Theta/Interaction.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Interaction.idric)
- [`src/Theta/Math.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Math.idric)
- [`src/Theta/Model.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Model.idric)
- [`src/Theta/Surface.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Surface.idric)
- [`src/Theta/Touch.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Touch.idric)

### isomorphismes/ortho

- [`src/Generate.idric`](https://github.com/isomorphismes/ortho/blob/main/src/Generate.idric)
- [`src/Orthant.idric`](https://github.com/isomorphismes/ortho/blob/main/src/Orthant.idric)

### isomorphismes/L

- [`shader/LWegert.idric`](https://github.com/isomorphismes/L/blob/main/shader/LWegert.idric)

### isomorphismes/coxeter

- [`pseudocode/Dynkin.idric`](https://github.com/isomorphismes/coxeter/blob/main/pseudocode/Dynkin.idric)

## Review, but do not mechanically migrate

These are historical PR-9 source snapshots in ai-ci:

- [`_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/ib/AiciCatfoodFixture.idric`](https://github.com/isomorphisms/ai-ci/blob/main/_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/ib/AiciCatfoodFixture.idric)
- [`_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/idric/Main.idric`](https://github.com/isomorphisms/ai-ci/blob/main/_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/idric/Main.idric)

## Supervision rule

When an Idriç language change is under review, do not treat the work as complete
until every `Must follow` file has either been migrated and revalidated or has
a durable explicit blocker. Negative fixtures must preserve the failure they
are designed to test rather than becoming accidentally invalid for a different
reason.

ai-ci now rediscovers `*.idric` files mechanically across the configured
`isomorphisms` and `isomorphismes` repositories and compares them with its
canonical inventory once per day and on relevant ai-ci changes. Inventory drift
is a failure, so Cockswain should treat an ai-ci drift report as an unresolved
Idriç migration-surface obligation rather than trusting this projection.
