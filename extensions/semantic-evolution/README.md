# Semantic evolution: which artifact changed?

An isolated extension for Section 5.3. All people, scores and dates are synthetic.
The catalog baseline, original lab files and retained equivalence experiment are
unchanged. Original code uses MIT; original text and data use CC BY 4.0, as in
the package root's license files.

From the package root, using Python 3.10 or newer (no extra packages):

```sh
python extensions/semantic-evolution/check_evolution.py
```

Inspect [fixture.json](fixture.json) before running. Predict whether the two
source snapshots normalize to the same learner/course/score record, whether
attendance can be used as an assessment score, and whether 65 percent passes
before and after 1 November 2026. Compare the printed `replays` with your answer.
The checker reads inputs and prints JSON; it writes no files or database data.

Expected replays:

| Decision date | Selected policy | Result for score 65 |
|---|---|---|
| 2026-10-31 | p60 (at least 60 percent) | pass |
| 2026-11-01 | p70 (at least 70 percent) | fail |

Intervals are start-inclusive and end-exclusive, selected by decision date.
This exercise uses calendar dates, not timestamp/time-zone rules. In a real
system, declare the time basis, relevant zone, exemptions and grandfathering.
Both results are assessment-policy results, not the book's full recommendation
or a finding of personal suitability. Missing score returns insufficient evidence.

The checker also rejects a meaning mismatch, Boolean scores, an uncovered date
and an overlapping effective interval at the selected date. It tests each
threshold below, at and above the boundary. Changing an identifier is observable;
software cannot establish that two source keys mean the same person without
an identity contract and supporting evidence.

Try changing the threshold, mapping identity field or expected replay in a copy.
The checker should expose an incompatible output or incorrect expected answer.
A report of a pass is specific to these scenarios, not a universal migration
validator. The script does not infer OWL facts, run SHACL, migrate a database,
automatically classify business changes or verify ontology compatibility.

For actual historical replay retain source snapshots, mappings, ontology and
validation artifacts, policy versions, evidence and execution configuration.
Here the snapshots and policies are inline JSON for inspection; the fixture is
not an ontology serialization. No automatic term-equivalence claim is made.
