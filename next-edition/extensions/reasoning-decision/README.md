# Decide whether reasoning earns its cost

Worksheet for Sections 2.8 and 6.3; no new engine or benchmark is supplied.
Original text CC BY 4.0. Keep this separate from the unchanged baseline lab.

1. Write the competency question, intended answers, counterexamples and required
   semantics. Identify which requirements are mandatory.
2. Compare the existing RDFS subclass case in lab/check_rdf.py with the Graduate
   definition and controls in [the DL lab](../../lab/owl_dl/README.md). Follow that
   lab's own dependency and execution instructions. Its retained correctness
   results are not fresh performance measurements.
3. List the actual constructs/tasks required and each candidate's documented
   support. Do not infer semantic equivalence from matching one dataset.
4. Supply representative data sizes, distributions, query mix and update rate.
   Benchmark adequate candidates on the same required answers and environment.
5. Measure query latency (including percentiles), update latency, inference
   rebuild/retraction work, memory/storage and operational effort. Record warm
   versus cold state and what is included in each timing.
6. Record the decision, uncertainties, owner and revisit conditions, e.g. a new
   competency question, a changed import or a workload exceeding the measured range.

| Item | Fill in before choosing |
|---|---|
| Required competency question | |
| Required constructs and task | |
| Semantically adequate candidates | |
| Fixture and environment hashes | |
| Representative workload and updates | |
| Measured query/update/rebuild costs | |
| Maintenance and interoperability value | |
| Decision, owner, uncertainty, revisit trigger | |

No universal numeric threshold is implied. A missing mandatory consequence cannot
be compensated by a better weighted performance score. An application query may
meet a narrower requirement, but narrowing must be an explicit decision.
