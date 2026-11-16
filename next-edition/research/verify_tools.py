"""Reproduce fresh-path, dependency, metadata and document-margin controls.
Synthetic reports and damaged PDFs are private tooling probes, not experiment results.
"""
from pathlib import Path
import argparse,hashlib,json,os,subprocess,sys,time
import fitz
root=Path(__file__).resolve().parent;e=root/'equivalence'
parser=argparse.ArgumentParser(description='Reproduce tooling controls in a fresh workspace, without altering retained evidence.')
parser.add_argument('--out',type=Path,default=root/'tooling-reproduction')
args=parser.parse_args();work=args.out.resolve()
if work.exists():raise RuntimeError('Refusing to overwrite existing tooling workspace: '+str(work))
work.mkdir(parents=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def run(args,ok=True,plain=False):
 env=dict(os.environ)
 if plain:env.pop('PYTHONPATH',None)
 start=time.monotonic();r=subprocess.run([sys.executable]+(['-S'] if plain else [])+[str(x) for x in args],text=True,capture_output=True,env=env)
 if ok and r.returncode:raise RuntimeError(r.stderr)
 return r,time.monotonic()-start
checks={}
protected=[e/'derived/RESULTS.md',e/'derived/observations.csv',e/'results/revision-checks.json',root/'Research-Companion-Equivalence.pdf',e/'results/document-check.json']
before={str(p):sha(p) for p in protected}
for tool in [e/'generate_results.py',e/'verify_revision.py',root/'build_pdf.py',root/'check_document.py']:
 r,elapsed=run([tool],ok=False)
 if r.returncode==0 or 'Refusing to overwrite' not in r.stderr:raise RuntimeError((tool,r.stdout,r.stderr))
 checks[tool.name+'_existing_output_refused']={'passed':True,'seconds':round(elapsed,3)}
 if tool.name=='verify_revision.py' and elapsed>10:raise RuntimeError('Supplementary refusal appears to run expensive work first')
if before!={str(p):sha(p) for p in protected}:raise RuntimeError('Retained outputs changed')
checks['retained_outputs_unchanged']=True
r,_=run([e/'generate_results.py','--out',work/'standard-library-summary'],plain=True)
for name in ['RESULTS.md','observations.csv']:
 if (work/'standard-library-summary'/name).read_bytes()!=(e/'derived'/name).read_bytes():raise RuntimeError('Derived output mismatch '+name)
checks['standard_library_only_generator_fresh_path_matches']=True
report=json.loads((e/'results/paired-run.json').read_text());report['neo4j']['image_reference']='TEST-ONLY-reference'
parallel=next(x for x in report['results'] if x['case']=='B02-parallel-completions');parallel['rdf_occurrence_count']=9;parallel['cypher_occurrence_count']=12
fixture=work/'synthetic-tooling-report.json';fixture.write_text(json.dumps(report))
run([e/'generate_results.py','--report',fixture,'--out',work/'synthetic-summary'],plain=True)
text=(work/'synthetic-summary/RESULTS.md').read_text()
if 'TEST-ONLY-reference' not in text or 'RDF 9; LPG 12' not in text or 'existing cached image' in text:raise RuntimeError('Generator still hardcodes runtime or counts')
checks['runtime_reference_and_counts_derived_from_input']=True
# Fresh PDF/check outputs; retained files stay untouched.
run([root/'build_pdf.py','--out',work/'pdf'])
run([root/'check_document.py','--pdf',work/'pdf/Research-Companion-Equivalence.pdf','--out',work/'document-check'])
checks['fresh_pdf_and_document_check_paths_pass']=True
pdf=fitz.open(root/'Research-Companion-Equivalence.pdf');pdf[1].insert_text((25,150),'OUTSIDE-MARGIN-TEST',fontsize=8);bad=work/'out-of-margin-test.pdf';pdf.save(bad);pdf.close()
r,_=run([root/'check_document.py','--pdf',bad,'--out',work/'bad-document-check'],ok=False)
if r.returncode==0 or 'OUTSIDE-MARGIN-TEST' not in r.stderr:raise RuntimeError('Margin defect not rejected')
checks['introduced_margin_violation_rejected']=True
# RDF-only paired-verification semantics, including optimized mode.
run([e/'run_experiment.py','--report',work/'rdf-only.json'])
rdf=json.loads((work/'rdf-only.json').read_text())
if not all(x['verified_query_aligned'] is None and x['verified_fixture_integrity'] is None and x['verified_fixture_state_equal'] is None for x in rdf['results']):raise RuntimeError('RDF-only verified fields not null')
checks['rdf_only_verification_fields_null']=True
checks['sources_match_executed_paired_run']=all(sha(e/f)==h for f,h in report['inputs'].items())
if not checks['sources_match_executed_paired_run']:raise RuntimeError('Source mismatch')
result={'scope':'Local tooling regression checks; synthetic metadata and margin probes are not graph-engine results.','checks':checks,'tool_hashes':{str(p.relative_to(root)):sha(p) for p in [e/'generate_results.py',e/'verify_revision.py',root/'build_pdf.py',root/'check_document.py',Path(__file__)]}}
(work/'tooling-checks.json').write_text(json.dumps(result,indent=2)+'\n')
print('Tooling controls passed:',len(checks),'checks; retained evidence unchanged.')
