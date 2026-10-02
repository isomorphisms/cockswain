# All Idriç code

This directory exists so supervision of an Idriç language change has one place
to see the current source migration surface.

The canonical machine-readable inventory lives in
`isomorphisms/ai-ci/idric/source-inventory-v1.tsv`. This file is the
human-facing Cockswain projection of that inventory. The current projection has
**101** source files that must follow language changes and
**2** historical files that are review-only.

## Must follow Idriç changes

### isomorphismes/Conway

- [`wallpapers/ConwayWallpaper.idric`](https://github.com/isomorphismes/Conway/blob/main/wallpapers/ConwayWallpaper.idric) — program

### isomorphismes/L

- [`shader/LWegert.idric`](https://github.com/isomorphismes/L/blob/main/shader/LWegert.idric) — program

### isomorphismes/coxeter

- [`pseudocode/Dynkin.idric`](https://github.com/isomorphismes/coxeter/blob/main/pseudocode/Dynkin.idric) — program

### isomorphismes/hopf_fibration

- [`src/GenerateHeader.idric`](https://github.com/isomorphismes/hopf_fibration/blob/master/src/GenerateHeader.idric) — program
- [`src/GenerateSource.idric`](https://github.com/isomorphismes/hopf_fibration/blob/master/src/GenerateSource.idric) — program
- [`src/Hopf.idric`](https://github.com/isomorphismes/hopf_fibration/blob/master/src/Hopf.idric) — program

### isomorphismes/knot-complement

- [`refactor/idric/Recenter.idric`](https://github.com/isomorphismes/knot-complement/blob/main/refactor/idric/Recenter.idric) — program

### isomorphismes/ortho

- [`src/Generate.idric`](https://github.com/isomorphismes/ortho/blob/main/src/Generate.idric) — program
- [`src/Orthant.idric`](https://github.com/isomorphismes/ortho/blob/main/src/Orthant.idric) — program

### isomorphismes/pauli

- [`raytracer/RayTracer.idric`](https://github.com/isomorphismes/pauli/blob/main/raytracer/RayTracer.idric) — program
- [`raytracer/RayTracerTypes.idric`](https://github.com/isomorphismes/pauli/blob/main/raytracer/RayTracerTypes.idric) — program

### isomorphismes/theta

- [`src/BrowserMain.idric`](https://github.com/isomorphismes/theta/blob/main/src/BrowserMain.idric) — program
- [`src/Main.idric`](https://github.com/isomorphismes/theta/blob/main/src/Main.idric) — program
- [`src/Theta/Interaction.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Interaction.idric) — program
- [`src/Theta/Math.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Math.idric) — program
- [`src/Theta/Model.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Model.idric) — program
- [`src/Theta/Surface.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Surface.idric) — program
- [`src/Theta/Touch.idric`](https://github.com/isomorphismes/theta/blob/main/src/Theta/Touch.idric) — program

### isomorphisms/Idric

- [`_/examples/compiler-one-step/PrintX.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/compiler-one-step/PrintX.idric) — example
- [`_/examples/unified-higher-mathematics/Circle96.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/Circle96.idric) — example
- [`_/examples/unified-higher-mathematics/Circle96Tests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/Circle96Tests.idric) — example
- [`_/examples/unified-higher-mathematics/CompactUnitDirectionStorage.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/CompactUnitDirectionStorage.idric) — example
- [`_/examples/unified-higher-mathematics/CompactUnitDirectionStorageTests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/CompactUnitDirectionStorageTests.idric) — example
- [`_/examples/unified-higher-mathematics/ComplexPairAgreement.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ComplexPairAgreement.idric) — example
- [`_/examples/unified-higher-mathematics/ComplexPairAgreementTests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ComplexPairAgreementTests.idric) — example
- [`_/examples/unified-higher-mathematics/ComplexProjective.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ComplexProjective.idric) — example
- [`_/examples/unified-higher-mathematics/ComplexProjectiveTests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/ComplexProjectiveTests.idric) — example
- [`_/examples/unified-higher-mathematics/EuclideanGeometry.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/EuclideanGeometry.idric) — example
- [`_/examples/unified-higher-mathematics/FormTests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/FormTests.idric) — example
- [`_/examples/unified-higher-mathematics/MathematicalSpaces.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/MathematicalSpaces.idric) — example
- [`_/examples/unified-higher-mathematics/NamedFacts.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/NamedFacts.idric) — example
- [`_/examples/unified-higher-mathematics/PairArithmetic.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/PairArithmetic.idric) — example
- [`_/examples/unified-higher-mathematics/PairArithmeticTests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/PairArithmeticTests.idric) — example
- [`_/examples/unified-higher-mathematics/PresheafRestriction.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/PresheafRestriction.idric) — example
- [`_/examples/unified-higher-mathematics/QuadraticForms.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/QuadraticForms.idric) — example
- [`_/examples/unified-higher-mathematics/QuaternionPairAgreement.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/QuaternionPairAgreement.idric) — example
- [`_/examples/unified-higher-mathematics/QuaternionPairAgreementTests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/QuaternionPairAgreementTests.idric) — example
- [`_/examples/unified-higher-mathematics/Tests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/Tests.idric) — example
- [`_/examples/unified-higher-mathematics/TopologyFacts.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/unified-higher-mathematics/TopologyFacts.idric) — example
- [`_/examples/units-time-intervals/Tests.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/units-time-intervals/Tests.idric) — example
- [`_/examples/units-time-intervals/UnitsTimeIntervals.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/examples/units-time-intervals/UnitsTimeIntervals.idric) — example
- [`_/koans/01-values-types-and-holes/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/01-values-types-and-holes/exercise/Main.idric) — koan
- [`_/koans/01-values-types-and-holes/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/01-values-types-and-holes/solution/Main.idric) — koan
- [`_/koans/02-functions-with-unicode-arrows/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/02-functions-with-unicode-arrows/exercise/Main.idric) — koan
- [`_/koans/02-functions-with-unicode-arrows/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/02-functions-with-unicode-arrows/solution/Main.idric) — koan
- [`_/koans/03-lists-and-length-indexed-lists/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/03-lists-and-length-indexed-lists/exercise/Main.idric) — koan
- [`_/koans/03-lists-and-length-indexed-lists/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/03-lists-and-length-indexed-lists/solution/Main.idric) — koan
- [`_/koans/04-equality-proofs/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/04-equality-proofs/exercise/Main.idric) — koan
- [`_/koans/04-equality-proofs/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/04-equality-proofs/solution/Main.idric) — koan
- [`_/koans/05-totality-and-coverage/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/05-totality-and-coverage/exercise/Main.idric) — koan
- [`_/koans/05-totality-and-coverage/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/05-totality-and-coverage/solution/Main.idric) — koan
- [`_/koans/06-implicit-dependent-results/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/06-implicit-dependent-results/exercise/Main.idric) — koan
- [`_/koans/06-implicit-dependent-results/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/06-implicit-dependent-results/solution/Main.idric) — koan
- [`_/koans/07-erased-arguments/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/07-erased-arguments/exercise/Main.idric) — koan
- [`_/koans/07-erased-arguments/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/07-erased-arguments/solution/Main.idric) — koan
- [`_/koans/08-linear-arguments/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/08-linear-arguments/exercise/Main.idric) — koan
- [`_/koans/08-linear-arguments/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/08-linear-arguments/solution/Main.idric) — koan
- [`_/koans/09-storage-neutral-choices/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/09-storage-neutral-choices/exercise/Main.idric) — koan
- [`_/koans/09-storage-neutral-choices/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/09-storage-neutral-choices/solution/Main.idric) — koan
- [`_/koans/10-exhaustive-choice-patterns/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/10-exhaustive-choice-patterns/exercise/Main.idric) — koan
- [`_/koans/10-exhaustive-choice-patterns/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/10-exhaustive-choice-patterns/solution/Main.idric) — koan
- [`_/koans/11-source-boundaries/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/11-source-boundaries/exercise/Main.idric) — koan
- [`_/koans/11-source-boundaries/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/11-source-boundaries/solution/Main.idric) — koan
- [`_/koans/12-wegert-model/exercise/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/12-wegert-model/exercise/Main.idric) — koan
- [`_/koans/12-wegert-model/solution/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/koans/12-wegert-model/solution/Main.idric) — koan
- [`_/tests/base/system_environment_value/InvalidNames.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/base/system_environment_value/InvalidNames.idric) — negative-fixture
- [`_/tests/base/system_environment_value/Test.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/base/system_environment_value/Test.idric) — test-fixture
- [`_/tests/idris2/basic/edric002/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/idris2/basic/edric002/Main.idric) — test-fixture
- [`_/tests/idris2/basic/edric002/WegertSource.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/idris2/basic/edric002/WegertSource.idric) — test-fixture
- [`_/tests/idris2/basic/edric003/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/idris2/basic/edric003/Main.idric) — test-fixture
- [`_/tests/idris2/basic/edric003/WegertTouch.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/idris2/basic/edric003/WegertTouch.idric) — test-fixture
- [`_/tests/idris2/basic/edric005/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/idris2/basic/edric005/Main.idric) — test-fixture
- [`_/tests/idris2/basic/edric010/Main.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/_/tests/idris2/basic/edric010/Main.idric) — test-fixture
- [`XbrlCanary.idric`](https://github.com/isomorphisms/Idric/blob/Idri%C3%A7/XbrlCanary.idric) — canary

### isomorphisms/ai-ci

- [`benchmarks/iridium-2014/IdricBench.idric`](https://github.com/isomorphisms/ai-ci/blob/main/benchmarks/iridium-2014/IdricBench.idric) — benchmark
- [`tests/fixtures/coupled-bad-partial/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-bad-partial/coupled-substitution.idric) — negative-fixture
- [`tests/fixtures/coupled-bad-precheck/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-bad-precheck/coupled-substitution.idric) — negative-fixture
- [`tests/fixtures/coupled-bad-signature/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-bad-signature/coupled-substitution.idric) — negative-fixture
- [`tests/fixtures/coupled-good/coupled-substitution.idric`](https://github.com/isomorphisms/ai-ci/blob/main/tests/fixtures/coupled-good/coupled-substitution.idric) — positive-fixture

### isomorphisms/android-NDK

- [`dex/idric/examples/DexArithmetic.idric`](https://github.com/isomorphisms/android-NDK/blob/main/dex/idric/examples/DexArithmetic.idric) — target-example
- [`dex/idric/examples/DexText.idric`](https://github.com/isomorphisms/android-NDK/blob/main/dex/idric/examples/DexText.idric) — target-example
- [`dex/idric/tests/source/InvalidDexInt.idric`](https://github.com/isomorphisms/android-NDK/blob/main/dex/idric/tests/source/InvalidDexInt.idric) — negative-fixture

### isomorphisms/ib

- [`examples/autogenerated/protected-long-view-task/protected-long-view-task.idric`](https://github.com/isomorphisms/ib/blob/main/examples/autogenerated/protected-long-view-task/protected-long-view-task.idric) — generated-example
- [`src/ArxivPrepaint.idric`](https://github.com/isomorphisms/ib/blob/main/src/ArxivPrepaint.idric) — program
- [`src/HostileIngestionReceipt.idric`](https://github.com/isomorphisms/ib/blob/main/src/HostileIngestionReceipt.idric) — program
- [`src/IB/DisplayRepair.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/DisplayRepair.idric) — program
- [`src/IB/History.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/History.idric) — program
- [`src/IB/Index.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/Index.idric) — program
- [`src/IB/Information.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/Information.idric) — program
- [`src/IB/Inspect.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/Inspect.idric) — program
- [`src/IB/LongViewTask.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/LongViewTask.idric) — program
- [`src/IB/Occurrence.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/Occurrence.idric) — program
- [`src/IB/Prefetch.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/Prefetch.idric) — program
- [`src/IB/RecoveredInformation.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/RecoveredInformation.idric) — program
- [`src/IB/ScientificMedia.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/ScientificMedia.idric) — program
- [`src/IB/Storage.idric`](https://github.com/isomorphisms/ib/blob/main/src/IB/Storage.idric) — program
- [`src/InformationSmoke.idric`](https://github.com/isomorphisms/ib/blob/main/src/InformationSmoke.idric) — program
- [`src/OccurrenceSmoke.idric`](https://github.com/isomorphisms/ib/blob/main/src/OccurrenceSmoke.idric) — program
- [`src/PDFCaptionAssociate.idric`](https://github.com/isomorphisms/ib/blob/main/src/PDFCaptionAssociate.idric) — program
- [`src/Smoke.idric`](https://github.com/isomorphisms/ib/blob/main/src/Smoke.idric) — program
- [`src/Workbench.idric`](https://github.com/isomorphisms/ib/blob/main/src/Workbench.idric) — program

## Review, but do not mechanically migrate

### isomorphisms/ai-ci

- [`_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/ib/AiciCatfoodFixture.idric`](https://github.com/isomorphisms/ai-ci/blob/main/_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/ib/AiciCatfoodFixture.idric) — historical-snapshot
- [`_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/idric/Main.idric`](https://github.com/isomorphisms/ai-ci/blob/main/_/pr-9-catfood-bare-cloud-acceptance/code/catfood/fixtures/idric/Main.idric) — historical-snapshot

## Supervision rule

When an Idriç language change is under review, do not treat the work as complete
until every `Must follow` file has either been migrated and revalidated or has
a durable explicit blocker. Negative fixtures must preserve the failure they
are designed to test rather than becoming accidentally invalid for a different
reason.

The canonical ai-ci inventory rediscovers `*.idric` files mechanically across
the configured `isomorphisms` and `isomorphismes` repositories and compares
them with its recorded inventory once per day and on relevant ai-ci changes.
Inventory drift is a failure, so Cockswain should treat an ai-ci drift report as
an unresolved Idriç migration-surface obligation rather than trusting this
projection.
