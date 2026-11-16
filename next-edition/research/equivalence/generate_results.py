"""Generate summaries in a fresh output directory, using only the standard library."""
import argparse,csv,hashlib,json
from pathlib import Path
from support import require,fresh_outputs
ROOT=Path(__file__).resolve().parent

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--report',type=Path,default=ROOT/'results/paired-run.json')
    p.add_argument('--out',type=Path,default=ROOT/'derived')
    args=p.parse_args();dest=args.out
    fresh_outputs([dest/'RESULTS.md',dest/'observations.csv'])
    d=json.loads(args.report.read_text());require(d['status']=='pass','A successful paired report is required')
    for name,digest in d['inputs'].items():require(hashlib.sha256((ROOT/name).read_bytes()).hexdigest()==digest,name)
    rs=d['results'];aligned=[r for r in rs if r['verified_query_aligned']];integrity=[r for r in rs if r['verified_fixture_integrity']]
    generated=[r for r in rs if r['case'].startswith('G-')];different=[r for r in rs if not r['result_equal']]
    require(len(rs)==145 and len(generated)==128,'Unexpected suite size')
    require(all(r['result_equal'] for r in aligned),'Aligned query results differ')
    require(len({r['case'] for r in rs})==len(rs),'Duplicate case identifiers')
    require({r['case'] for r in different}=={'B01-multivalued-title','B03-asymmetric-inference'},'Unexpected boundary disagreement set')
    by_id={r['case']:r for r in rs}
    for case in ['C06-missing-title','C07-untyped-learner','C08-non-Course-prerequisite','C11-missing-id']:
        record=by_id[case]
        require(record['verified_query_aligned'] is True and record['verified_fixture_integrity'] is False and record['shacl_conforms'] is False,(case,'Unexpected A/B/C classification'))
        require(record['rdf_rows']==[] and record['cypher_rows']==[],(case,'Expected empty-result agreement'))
    parallel=next(r for r in rs if r['case']=='B02-parallel-completions')
    events=next(r for r in rs if r['case']=='B04-explicit-completion-events')
    runtime=d['neo4j'];versions=d['dependencies']
    lines=['# Observed results','','**Actual paired execution · RDFLib and Neo4j · Working module**','',
       f"The retained run used Python {d['python']}, RDFLib {versions['rdflib']}, pySHACL {versions['pyshacl']}, owlrl {versions['owlrl']}, and Neo4j {runtime['version']['version']} {runtime['version']['edition']}.",'',
       f"The requested image reference was `{runtime['image_reference']}`. The runner resolved it to the immutable image ID retained in the report before launching. These fields do not establish when the image was pulled.",'',
       '## Summary','','| Observation | Actual result |','|---|---|',
       f'| Paired datasets | {len(rs)} |',f'| Query alignment A | {len(aligned)}; all results equal |',
       f'| Fixture integrity B | {len(integrity)} |',f"| SHACL intake C | {sum(r['shacl_conforms'] for r in rs)} |",
       f'| Generated grid | {len(generated)}; all matched the separately expressed set predicate |',
       f"| Equal recommendation sets | {sum(r['result_equal'] for r in rs)} |",f'| Required boundary disagreements | {len(different)} |',
       f"| Parallel completion count | RDF {parallel['rdf_occurrence_count']}; LPG {parallel['cypher_occurrence_count']} |",
       f"| Explicit completion-event count | RDF {events['rdf_event_count']}; LPG {events['cypher_event_count']} |",'',
       'These are constructed datasets, not a statistical success rate. A tests the query-relevant mapping. B combines stricter fixture rules with full projected-state equality. C is validation against the unchanged SHACL shapes. They are different judgments.','',
       '## Curated observations','','| Case | Aligned A | Integrity B | SHACL C | Results |','|---|---|---|---|---|']
    for r in rs:
        if not r['case'].startswith('G-'):
            lines.append('| '+' | '.join([r['case'],'yes' if r['verified_query_aligned'] else 'no','pass' if r['verified_fixture_integrity'] else 'fail','pass' if r['shacl_conforms'] else 'fail','equal' if r['result_equal'] else 'different'])+' |')
    lines+=['','C06, C07, C08 and C11 satisfy query alignment, but fail fixture rules and SHACL intake. Their empty-result agreement is covered by the broadened conditional argument. The earlier stronger sufficient contract excluded them; that exclusion was not a counterexample to it.','',
            '## Inspect the boundary cases','']
    for r in different:
        lines += ['### '+r['case'],'',r['note'],'','RDF: `'+json.dumps(r['rdf_rows'])+'`','','Cypher: `'+json.dumps(r['cypher_rows'])+'`','']
    lines+=['## Supplementary controls','',
       'See equivalence/results/revision-checks.json for separately executed supplementary controls and their exact scope. Simulated engine output is distinct from actual engine execution; this summary does not infer a control count from the paired report.','',
       '## Interpretation and limits','',
       'The two intentional disagreements were observed. Parallel completions preserve this existence-based answer while losing count equivalence; explicit event identities preserve two occurrences in the repair example.','',
       'This is one synthetic catalog, a bounded 128-case grid, one SPARQL implementation, one LPG engine and one authoring environment. It does not establish arbitrary RDF/LPG equivalence, performance, business completeness, GraphRAG answer quality, personal suitability or production readiness. Independent paired reproduction remains open; this is not human peer review.','',
       '## Retained evidence','',
       'All paths below are relative to the extracted package root.','',
       '- `equivalence/results/paired-run.json`: typed answers, states, classifications, runtime identity and input hashes.',
       '- `equivalence/results/paired-run.cypher` and `equivalence/results/paired-run.stdout.txt`: exact script and raw engine output.',
       '- `equivalence/results/revision-checks.json`: supplementary checks and simulations.',
       '- `equivalence/results/tooling-checks.json`: tooling regression outcomes and tool hashes.',
       '- `equivalence/results/generator-guard-checks.json`: generator input-guard regressions.',
       '- `equivalence/results/document-check.json`: PDF/report hashes, margins, text and links.',
       '- `equivalence/derived/RESULTS.md` and `equivalence/derived/observations.csv`: generated summaries.',
       '- `equivalence/run_experiment.py`, `equivalence/source/`, `equivalence/support.py`: experiment inputs.',
       '- `equivalence/generate_results.py`, `equivalence/verify_revision.py`: summary and supplementary-control tools.',
       '- `verify_tools.py`, `verify_generator_guards.py`: tooling and generator regression drivers.',
       '- `build_pdf.py`: PDF builder; `check_document.py`: document-evidence checker.','',
       'The report retains full image ID, digests, architecture and OS. The disposable container exposed no host ports and used no existing database.','']
    (dest/'RESULTS.md').write_text('\n'.join(lines))
    with (dest/'observations.csv').open('w',newline='') as f:
        w=csv.writer(f);w.writerow(['case','query_aligned_A','fixture_integrity_B','shacl_C','fixture_state_equal','result_equal','rdf_rows','cypher_rows','note'])
        for r in rs:w.writerow([r['case'],r['verified_query_aligned'],r['verified_fixture_integrity'],r['shacl_conforms'],r['verified_fixture_state_equal'],r['result_equal'],json.dumps(r['rdf_rows']),json.dumps(r['cypher_rows']),r['note']])
    print('Generated summaries:',dest)
if __name__=='__main__':main()
