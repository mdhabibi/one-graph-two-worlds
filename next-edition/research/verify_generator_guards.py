"""Reproduce generator guard regressions using private synthetic reports, no engine."""
import argparse,copy,hashlib,json,os,subprocess,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parent

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,default=ROOT/'generator-reproduction');args=parser.parse_args()
    work=args.out.resolve()
    if work.exists():raise RuntimeError('Refusing to overwrite '+str(work))
    work.mkdir(parents=True)
    report=json.loads((ROOT/'equivalence/results/paired-run.json').read_text())
    def case(d,key):return next(r for r in d['results'] if r['case']==key)
    variants={}
    d=copy.deepcopy(report);case(d,'C06-missing-title')['verified_query_aligned']=False
    case(d,'C13-aligned-membership-control')['verified_query_aligned']=False;case(d,'C13-aligned-membership-control')['result_equal']=False
    variants['reported-three-change-reproducer']=(d,'Unexpected boundary disagreement set')
    d=copy.deepcopy(report);case(d,'C06-missing-title')['verified_query_aligned']=False
    variants['malformed-case-alignment-changed']=(d,'Unexpected A/B/C classification')
    d=copy.deepcopy(report);case(d,'C07-untyped-learner')['verified_fixture_integrity']=True
    variants['malformed-case-integrity-changed']=(d,'Unexpected A/B/C classification')
    d=copy.deepcopy(report);case(d,'C08-non-Course-prerequisite')['shacl_conforms']=True
    variants['malformed-case-shacl-changed']=(d,'Unexpected A/B/C classification')
    d=copy.deepcopy(report);case(d,'C11-missing-id')['rdf_rows']=[['other','Unexpected']];case(d,'C11-missing-id')['cypher_rows']=[['other','Unexpected']]
    variants['malformed-case-empty-answer-changed']=(d,'Expected empty-result agreement')
    d=copy.deepcopy(report);case(d,'B03-asymmetric-inference')['result_equal']=True
    variants['expected-disagreement-erased']=(d,'Unexpected boundary disagreement set')
    d=copy.deepcopy(report);case(d,'C13-aligned-membership-control')['case']='C12-all-multiple-prerequisites-completed'
    variants['duplicate-case-id']=(d,'Duplicate case identifiers')
    checks={};env=dict(os.environ);env.pop('PYTHONPATH',None)
    for name,(data,reason) in variants.items():
        source=work/(name+'.json');source.write_text(json.dumps(data));dest=work/name
        result=subprocess.run([sys.executable,'-S',str(ROOT/'equivalence/generate_results.py'),'--report',str(source),'--out',str(dest)],capture_output=True,text=True,env=env)
        if not result.returncode or reason not in result.stderr:raise RuntimeError((name,result.stderr))
        if (dest/'RESULTS.md').exists() or (dest/'observations.csv').exists():raise RuntimeError('Failed guard wrote summaries')
        checks[name]='rejected before summary write'
    valid=work/'valid'
    subprocess.run([sys.executable,'-S',str(ROOT/'equivalence/generate_results.py'),'--out',str(valid)],check=True,capture_output=True,text=True,env=env)
    checks['unchanged-retained-report']='accepted using standard library only'
    text=(valid/'RESULTS.md').read_text()
    if 'six deliberately' in text or '../build_pdf.py' in text:raise RuntimeError('Stale prose or paths')
    for item in ['equivalence/results/tooling-checks.json','equivalence/results/document-check.json','verify_tools.py','check_document.py','generator-guard-checks.json']:
        if item not in text:raise RuntimeError('Incomplete evidence inventory: '+item)
    checks['evidence-inventory']='complete with package-root-relative paths'
    data={'scope':'Generator-only synthetic input regressions; no new graph-engine execution.','checks':checks,'generator_sha256':hashlib.sha256((ROOT/'equivalence/generate_results.py').read_bytes()).hexdigest(),'driver_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    (work/'generator-guard-checks.json').write_text(json.dumps(data,indent=2)+'\n');print('Generator regressions passed:',len(checks),'checks.')
if __name__=='__main__':main()
