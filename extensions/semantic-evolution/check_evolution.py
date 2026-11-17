"""Run the isolated semantic-evolution exercise using only the Python standard library."""
import copy
import hashlib
import json
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent

def require(condition, message):
    if not condition:
        raise ValueError(message)

def normalize(source, mapping):
    require(mapping['accepted_meaning'] == 'assessment-score-percent', 'Unsupported mapping meaning')
    require(source['meaning'] == mapping['accepted_meaning'], 'Source meaning does not match mapping')
    learner = source[mapping['identity_field']]
    require(isinstance(learner, str) and bool(learner), 'Missing learner identity')
    require(isinstance(source['course_id'], str) and bool(source['course_id']), 'Missing course identity')
    score = source.get('score')
    require(score is None or (type(score) in (int, float) and 0 <= score <= 100), 'Invalid percent score')
    return {'learner': learner, 'course': source['course_id'], 'score_percent': score}

def decide(record, decision_date, policies):
    day = date.fromisoformat(decision_date)
    matching = []
    for policy in policies:
        start = date.fromisoformat(policy['effective_from'])
        end = date.fromisoformat(policy['effective_until']) if policy['effective_until'] else None
        require(end is None or start < end, 'Invalid policy interval')
        threshold = policy['threshold_percent']
        require(type(threshold) in (int, float) and 0 <= threshold <= 100, 'Invalid threshold')
        if start <= day and (end is None or day < end):
            matching.append(policy)
    require(len(matching) == 1, 'Decision date must select exactly one policy')
    policy = matching[0]
    score = record['score_percent']
    status = 'insufficient-evidence' if score is None else 'pass' if score >= policy['threshold_percent'] else 'fail'
    return {'decision_date': decision_date, 'policy': policy['id'], 'status': status}

def main():
    fixture_path = ROOT / 'fixture.json'
    f = json.loads(fixture_path.read_text())
    src = f['source_snapshots']; maps = f['mappings']; policies = f['policies']
    old = normalize(src['legacy'], maps['m1'])
    new = normalize(src['renamed'], maps['m2'])
    require(old == new, 'Source rename changed normalized facts')
    checks = ['source rename preserves learner, course and score']
    def rejected(name, action):
        try:
            action()
        except (ValueError, KeyError):
            checks.append(name)
        else:
            raise RuntimeError('Control unexpectedly accepted: ' + name)
    rejected('attendance substitution rejected', lambda: normalize(src['attendance'], maps['m2']))
    # A field rename is not compatible when the identity value also changes.
    altered = dict(src['renamed'], student_key='enrollment-17')
    require(normalize(altered, maps['m2']) != old, 'Changed identity was silently equated')
    checks.append('changed identity is observable; meaning requires external review')
    replays = [decide(old, item['decision_date'], policies) for item in f['expected_replays']]
    require(replays == f['expected_replays'], 'Historical policy replay differs')
    checks.append('dated policy replay matches expected outcomes')
    require(old['score_percent'] == 65, 'Decision changed source score')
    checks.append('policy change leaves score fact unchanged')
    for day, threshold in [('2026-10-31', 60), ('2026-11-01', 70)]:
        for score, expected in [(threshold - 1, 'fail'), (threshold, 'pass'), (threshold + 1, 'pass')]:
            require(decide(dict(old, score_percent=score), day, policies)['status'] == expected, 'Threshold boundary error')
    checks.append('six threshold boundary cases match')
    unknown = normalize(dict(src['legacy'], score=None), maps['m1'])
    require(decide(unknown, '2026-11-01', policies)['status'] == 'insufficient-evidence', 'Missing score misclassified')
    checks.append('missing score yields insufficient evidence')
    rejected('uncovered policy date rejected', lambda: decide(old, '2025-12-31', policies))
    overlap = copy.deepcopy(policies); overlap[0]['effective_until'] = None
    rejected('ambiguous overlapping policy date rejected', lambda: decide(old, '2026-11-01', overlap))
    rejected('Boolean score rejected', lambda: normalize(dict(src['legacy'], score=True), maps['m1']))
    print(json.dumps({'status': 'pass', 'checks': checks, 'replays': replays,
                      'inputs': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in [fixture_path, Path(__file__)]},
                      'scope': 'Synthetic mapping and decision-policy exercise. No OWL inference, SHACL or database execution; no proof of business definitions.'}, indent=2))

if __name__ == '__main__':
    main()
