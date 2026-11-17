"""Isolated identity/evidence exercise; no extraction model or database."""
import copy
import hashlib
import json
from pathlib import Path
ROOT = Path(__file__).resolve().parent

def require(condition, detail):
    if not condition:
        raise ValueError(detail)

def resolve(mention, documents, registry):
    doc = documents[mention['document']]
    require(doc['version'] == mention['version'], 'Source version mismatch')
    start, end = mention['span']
    require(type(start) is int and type(end) is int and 0 <= start < end <= len(doc['text']), 'Invalid mention span')
    require(doc['text'][start:end] == mention['surface'], 'Mention span does not match source text')
    title = doc['aliases'].get(mention['surface'], mention['surface'])
    provider, edition = mention.get('provider'), mention.get('edition')
    matches = [item['id'] for item in registry if provider is not None and edition is not None
               and (item['title'], item['provider'], item['edition']) == (title, provider, edition)]
    # No fuzzy merge: retain the local mention unless exactly one registry identity matches.
    return {'mention': mention['id'], 'entity': matches[0] if len(matches) == 1 else None,
            'identity_status': 'linked' if len(matches) == 1 else 'unresolved',
            'evidence': {'document': mention['document'], 'version': mention['version'],
                         'page': mention['page'], 'span': [start, end]},
            'claim_review': 'unreviewed'}

def main():
    file = ROOT / 'fixture.json'; f = json.loads(file.read_text())
    docs, registry = f['documents'], f['registry']
    result = [resolve(m, docs, registry) for m in f['mentions']]
    checks = []
    require([r['entity'] for r in result] == ['course-a-2026', 'course-a-2026', 'course-b-2027'], 'Alias or edition identity differs')
    checks.append('explicit local alias links; same title with different provider/edition stays separate')
    require(result[0]['evidence'] != result[1]['evidence'], 'Original mention locators were lost')
    checks.append('both mention locators survive linking to one entity')
    missing = dict(f['mentions'][2]); missing.pop('edition')
    require(resolve(missing, docs, registry)['identity_status'] == 'unresolved', 'Missing edition forced a merge')
    checks.append('missing edition leaves the local mention unresolved')
    duplicate = registry + [dict(registry[0], id='ambiguous-alternate')]
    require(resolve(f['mentions'][0], docs, duplicate)['identity_status'] == 'unresolved', 'Ambiguous registry forced a merge')
    checks.append('ambiguous registry leaves identity unresolved')
    # Repeated mentions of one document are not independently corroborating sources.
    require(len(result[:2]) == 2 and len({(x['evidence']['document'], x['evidence']['version']) for x in result[:2]}) == 1, 'Source grouping differs')
    checks.append('two mention records retain one document/version origin')
    require(all(x['claim_review'] == 'unreviewed' for x in result), 'Identity linking promoted claim truth')
    checks.append('identity linking does not change claim review status')
    for field, value in [('version', 'v2'), ('span', [1, 12])]:
        wrong = copy.deepcopy(f['mentions'][0]); wrong[field] = value
        try:
            resolve(wrong, docs, registry)
        except ValueError:
            checks.append('wrong ' + field + ' rejected')
        else:
            raise RuntimeError('Invalid evidence locator accepted')
    print(json.dumps({'status': 'pass', 'checks': checks, 'linked_mentions': result,
                      'inputs': {p.name: hashlib.sha256(p.read_bytes()).hexdigest() for p in [file, Path(__file__)]},
                      'scope': 'Synthetic deterministic identity lookup and evidence retention. No extraction, statistical entity resolution, independent-corroboration measurement or truth validation.'}, indent=2))
if __name__ == '__main__':
    main()
