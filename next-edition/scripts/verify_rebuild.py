"""Check content-comparison rejection controls and byte-different serialization."""
import argparse,copy,hashlib,json,subprocess,sys,tempfile
from pathlib import Path
import fitz
from check_rebuild import snapshot
ROOT=Path(__file__).resolve().parent.parent

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,required=True)
    out=parser.parse_args().out.resolve()
    if out.exists():raise RuntimeError('Refusing to overwrite '+str(out))
    out.mkdir(parents=True);baseline=snapshot(ROOT);checks={}
    with tempfile.TemporaryDirectory() as temp:
        base=Path(temp)
        for key in ['page_text_sha256','page_map','outline','metadata']:
            bad=copy.deepcopy(baseline)
            if key=='metadata':bad[key]['title']='WRONG TITLE'
            elif key=='page_text_sha256':bad[key][0]='0'*64
            elif key=='page_map':bad[key][0][1]=999
            else:bad[key][0][2]=999
            previous=base/(key+'.json');previous.write_text(json.dumps(bad));dest=base/(key+'-comparison.json')
            run=subprocess.run([sys.executable,str(ROOT/'scripts/check_rebuild.py'),'compare','--baseline',str(previous),'--out',str(dest)],text=True,capture_output=True)
            if run.returncode==0 or 'Rebuilt document content differs' not in run.stderr or dest.exists():raise RuntimeError((key,run.stdout,run.stderr))
            checks[key]='rejected; no pass report'
        alternate=base/'alternate';(alternate/'dist').mkdir(parents=True)
        with fitz.open(ROOT/'dist/knowledge-graphs-tutorial.pdf') as pdf:
            pdf.save(alternate/'dist/knowledge-graphs-tutorial.pdf',deflate=True,garbage=4)
        (alternate/'dist/page-map.json').write_bytes((ROOT/'dist/page-map.json').read_bytes())
        previous=base/'baseline.json';previous.write_text(json.dumps(baseline));dest=base/'serialization-comparison.json'
        run=subprocess.run([sys.executable,str(ROOT/'scripts/check_rebuild.py'),'compare','--root',str(alternate),'--baseline',str(previous),'--out',str(dest)],text=True,capture_output=True)
        if run.returncode:raise RuntimeError(run.stderr)
        if json.loads(dest.read_text())['byte_equal']:raise RuntimeError('Serialization control did not change bytes')
        checks['different-serialization-same-content']='accepted; different bytes preserve checked content/navigation'
    data={'scope':'Temporary snapshot mutations and rewritten PDF. Does not diagnose the external rebuild difference.','checks':checks,
          'inputs':{name:hashlib.sha256((ROOT/name).read_bytes()).hexdigest() for name in ['scripts/check_rebuild.py','scripts/verify_rebuild.py','dist/knowledge-graphs-tutorial.pdf','dist/page-map.json']}}
    (out/'rebuild-controls.json').write_text(json.dumps(data,indent=2)+'\n');print('Rebuild comparison controls passed:',len(checks))
if __name__=='__main__':main()
