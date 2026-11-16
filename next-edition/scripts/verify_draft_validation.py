"""Check that the draft validator rejects deliberately introduced document defects."""
import argparse,hashlib,json,shutil,subprocess,sys,tempfile
from pathlib import Path
import fitz
ROOT=Path(__file__).resolve().parent.parent

def edit_pdf(root,action):
    path=root/'dist/knowledge-graphs-tutorial.pdf';doc=fitz.open(path);action(doc)
    tmp=path.with_suffix('.probe.pdf');doc.save(tmp);doc.close();tmp.replace(path)

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,required=True);out=parser.parse_args().out.resolve()
    if out.exists():raise RuntimeError('Refusing to overwrite '+str(out))
    out.mkdir(parents=True);checks={}
    def margin(root):edit_pdf(root,lambda d:d[9].insert_text((25,200),'MARGIN-PROBE',fontsize=8))
    def label(root):
        def edit(d):
            rect=d[9].search_for('Unpublished working draft')[0];d[9].add_redact_annot(rect,fill=(1,1,1));d[9].apply_redactions()
        edit_pdf(root,edit)
    def citation(root):
        def edit(d):
            for page in list(d)[4:]:
                for link in page.get_links():
                    label=page.get_text('text',clip=link['from']).strip().strip('[], ')
                    if label.isdigit() and 'page' in link:
                        page.update_link({'xref':link['xref'],'kind':fitz.LINK_GOTO,'page':0,'from':link['from'],'to':fitz.Point(0,0)});return
            raise RuntimeError('No citation found to perturb')
        edit_pdf(root,edit)
    def rebuild(root):
        result=subprocess.run([sys.executable,str(root/'scripts/build_pdf.py')],text=True,capture_output=True)
        if result.returncode:raise RuntimeError(result.stderr)
        result=subprocess.run([sys.executable,str(root/'scripts/export_web.py')],text=True,capture_output=True)
        if result.returncode:raise RuntimeError(result.stderr)
    def missing_citation(root):
        def edit(d):
            for page in list(d)[4:]:
                for link in page.get_links():
                    label=page.get_text('text',clip=link['from']).strip().strip('[], ')
                    if label.isdigit() and 'page' in link:page.delete_link(link);return
            raise RuntimeError('No citation found')
        edit_pdf(root,edit)
    def stale_source(root):
        p=root/'book/manuscript.md';p.write_text(p.read_text().replace('143; all return','142; all return',1))
    def cover_label(root):
        p=root/'scripts/build_pdf.py';text=p.read_text();needle="c.setFont('Body',8);c.drawCentredString(300,34,'Unpublished working draft');"
        if text.count(needle)!=1:raise RuntimeError('Cover label mutation did not match exactly once')
        p.write_text(text.replace(needle,''));rebuild(root)
    def extension_replay(root):
        p=root/'extensions/semantic-evolution/fixture.json';data=json.loads(p.read_text());data['expected_replays'][0]['status']='fail';p.write_text(json.dumps(data))
    def missing_shape(root):
        p=root/'extensions/missing-data/required.ttl';p.write_text(p.read_text().replace('sh:minCount 1','sh:minCount 0'))
    def identity_span(root):
        p=root/'extensions/identity-evidence/fixture.json';data=json.loads(p.read_text());data['mentions'][0]['span']=[1,12];p.write_text(json.dumps(data))
    def web_drift(root):
        p=root/'book/index.md';p.write_text(p.read_text()+'\nUnrebuilt probe.\n')
    def syntax(root):
        p=root/'book/manuscript.md';p.write_text(p.read_text().replace('```sparql\n','```sparql\nSELECT WHERE {\n',1));rebuild(root)
    def local(root):
        p=root/'README.md';p.write_text(p.read_text()+'\n[Invalid probe](missing-local-file-probe.md)\n')
    for name,mutation,expected in [('margin',margin,'Margin violations'),('draft-label',label,'Draft label missing'),('citation-target',citation,'Citation target mismatch'),('syntax',syntax,'ParseException'),('local-link',local,'Missing local link'),('chapter-cover-label',cover_label,'Draft label missing'),('citation-coverage',missing_citation,'Unlinked rendered citation'),('stale-manuscript',stale_source,'Build input drift'),('extension-replay',extension_replay,'Semantic evolution exercise failed'),('missing-shape',missing_shape,'Extension failed'),('identity-locator',identity_span,'Extension failed'),('web-drift',web_drift,'Web export drift')]:
        with tempfile.TemporaryDirectory() as temp:
            copy=Path(temp)/'draft';shutil.copytree(ROOT,copy,ignore=shutil.ignore_patterns('__pycache__'))
            mutation(copy)
            result=subprocess.run([sys.executable,str(copy/'scripts/validate_draft.py')],text=True,capture_output=True)
            if result.returncode==0 or expected not in result.stderr:raise RuntimeError((name,result.stdout,result.stderr))
            if (copy/'dist/draft-validation.json').exists():raise RuntimeError('A failed validation retained a stale pass report')
            checks[name]='rejected; no stale pass report'
    data={'scope':'Deliberately modified temporary copies; no graph-engine run.','checks':checks,'validator_sha256':hashlib.sha256((ROOT/'scripts/validate_draft.py').read_bytes()).hexdigest(),'driver_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    (out/'validator-regressions.json').write_text(json.dumps(data,indent=2)+'\n');print('Draft validation regressions passed:',len(checks),'defects rejected.')
if __name__=='__main__':main()
