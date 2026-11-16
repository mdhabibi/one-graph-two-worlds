# Mentions, identities and retained evidence

Isolated Section 5.2 exercise. All entities and source texts are synthetic;
this does not change the original catalog. Requires Python 3.10+, standard
library only. Original code MIT; original text/data CC BY 4.0 (root licenses).

From the package root:

```sh
python extensions/identity-evidence/check_identity.py
```

Read [fixture.json](fixture.json). Predict the identities for ma1, ma2 and mb1.
Expected: ma1 and ma2 link to course-a-2026; mb1 links to course-b-2027.
The document-local alias GB is explicitly supplied, not learned from text.
The lookup requires provider and edition as well as title. Missing or ambiguous
identity evidence leaves the local mention unresolved. The script validates
version and character offsets against the supplied extracted text, and keeps
all original locators after linking. It prints JSON without writing files.

Offsets are zero-based, end-exclusive Python string indices into the given text;
they are not byte offsets or PDF coordinates. Each page value is supplied
metadata, not independently checked against a real PDF in this exercise.
Two mentions of doc-a do not become two independent document sources. Different
document IDs also would not, alone, establish independent corroboration.

Identity lookup leaves claim review unreviewed. No extraction model, fuzzy
resolver, relation mapper, semantic truth assessment or database is executed.
The registry and identifying fields are trusted synthetic inputs: matching them
tests the implemented rule, not their factual correctness. For a real pipeline,
evaluate false merges, missed links and evidence quality with adjudicated cases.
