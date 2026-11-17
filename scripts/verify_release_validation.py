"""Check that the release validator rejects deliberately introduced document defects."""
import argparse,hashlib,json,re,shutil,subprocess,sys,tempfile
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
            rect=d[9].search_for('Public review draft')[0];d[9].add_redact_annot(rect,fill=(1,1,1));d[9].apply_redactions()
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
        p=root/'scripts/build_pdf.py';text=p.read_text();needle="c.setFont('Body',8);c.drawCentredString(300,34,'Public review draft');"
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
    def source_edit(root,mutation):
        p=root/'book/manuscript.md';old=p.read_text();new=mutation(old)
        if old==new:raise RuntimeError('Mutation did not change source')
        p.write_text(new);rebuild(root)
    def glossary(root):
        def change(text):
            a=re.search(r'^\*\*Graph projection:.*$',text,re.M)[0];b=re.search(r'^\*\*Graph RAG:.*$',text,re.M)[0]
            return text.replace(a,'TEMP-SWAP').replace(b,a).replace('TEMP-SWAP',b)
        source_edit(root,change)
    def core_reference(root):
        source_edit(root,lambda text:text.replace('core questions for this chapter are 1, 3, 4, 6, 7, 9, 10, 13, 16.','core questions for this chapter are 1, 3, 4, 6, 7, 9, 10, 13, 16, 99.',1))
    def misplaced_answer(root):
        def change(text):
            q2=re.search(r'^\*\*Question 2:.*$',text,re.M)
            answer=re.search(r'^\*\*Answer:\*\*.*$',text[q2.end():],re.M)
            start=q2.end()+answer.start();end=q2.end()+answer.end();content=text[start:end]
            text=text[:start]+text[end:];q3=re.search(r'^\*\*Question 3:.*$',text,re.M)
            return text[:q3.end()]+'\n\n'+content+text[q3.end():]
        source_edit(root,change)
    def review_number(root):
        source_edit(root,lambda text:text.replace('### Review 5 · Choose the right test','### Review 6 · Choose the right test',1))
    def web_label(root):
        p=root/'book/chapters/reader-guide.md';p.write_text(p.read_text().replace('Version 0.2.0 · Public review draft','REMOVED-EDITION-LABEL',1))
    def web_code(root):
        p=root/'book/chapters/reader-guide.md';text=p.read_text();match=re.search(r'```[^\n]*\n',text)
        if match is None:raise RuntimeError('No exported code fence to change')
        p.write_text(text[:match.end()]+'CODE-FENCE-PROBE\n'+text[match.end():])
    def outline(root):
        def edit(doc):
            toc=doc.get_toc();item=next(row for row in toc if row[0]==2);item[2]=1;doc.set_toc(toc)
        edit_pdf(root,edit)
    def syntax(root):
        p=root/'book/manuscript.md';p.write_text(p.read_text().replace('```sparql\n','```sparql\nSELECT WHERE {\n',1));rebuild(root)
    def local(root):
        p=root/'README.md';p.write_text(p.read_text()+'\n[Invalid probe](missing-local-file-probe.md)\n')
    def doi_hyperlink(root):
        def edit(doc):
            for page in doc:
                for link in page.get_links():
                    if link.get('uri')=='https://doi.org/10.5281/zenodo.24316420':
                        page.update_link({'xref':link['xref'],'kind':fitz.LINK_URI,'uri':link['uri']+'.','from':link['from']});return
            raise RuntimeError('No edition DOI link found')
        edit_pdf(root,edit)
    def citation_version(root):
        p=root/'CITATION.cff';p.write_text(p.read_text().replace('version: "0.2.0"','version: "0.1.1"',1))
    def bib_doi(root):
        p=root/'publication/citation.bib';p.write_text(p.read_text().replace('24316420','24228810'))
    def record_version(root):
        p=root/'publication/zenodo-record-draft.json';data=json.loads(p.read_text());data['version']='0.1.1';p.write_text(json.dumps(data))
    for name,mutation,expected in [('margin',margin,'Margin violations'),('draft-label',label,'Edition label missing'),('citation-target',citation,'Citation target mismatch'),('syntax',syntax,'ParseException'),('local-link',local,'Missing local link'),('chapter-cover-label',cover_label,'Edition label missing'),('citation-coverage',missing_citation,'Unlinked rendered citation'),('stale-manuscript',stale_source,'Build input drift'),('extension-replay',extension_replay,'Semantic evolution exercise failed'),('missing-shape',missing_shape,'Extension failed'),('identity-locator',identity_span,'Extension failed'),('web-drift',web_drift,'Web export drift'),('glossary-order',glossary,'Glossary ordering'),('core-reference',core_reference,'Core-question reference missing'),('answer-placement',misplaced_answer,'Question missing its answer'),('review-numbering',review_number,'Review heading numbering'),('web-label',web_label,'Web chapter edition label missing'),('web-code',web_code,'Exported code fence differs'),('pdf-outline',outline,'PDF section outline differs'),('citation-version',citation_version,'Citation version mismatch'),('bibtex-doi',bib_doi,'BibTeX DOI mismatch'),('record-version',record_version,'Release metadata version mismatch'),('doi-hyperlink',doi_hyperlink,'Edition DOI hyperlink mismatch')]:
        with tempfile.TemporaryDirectory() as temp:
            copy=Path(temp)/'draft';shutil.copytree(ROOT,copy,ignore=shutil.ignore_patterns('__pycache__','.git'))
            mutation(copy)
            result=subprocess.run([sys.executable,str(copy/'scripts/validate_release.py')],text=True,capture_output=True)
            if result.returncode==0 or expected not in result.stderr:raise RuntimeError((name,result.stdout,result.stderr))
            if (copy/'dist/release-validation.json').exists():raise RuntimeError('A failed validation retained a stale pass report')
            checks[name]='rejected; no stale pass report'
    data={'scope':'Deliberately modified temporary copies; no graph-engine run.','checks':checks,'validator_sha256':hashlib.sha256((ROOT/'scripts/validate_release.py').read_bytes()).hexdigest(),'editorial_checker_sha256':hashlib.sha256((ROOT/'scripts/check_editorial.py').read_bytes()).hexdigest(),'metadata_checker_sha256':hashlib.sha256((ROOT/'scripts/check_release_metadata.py').read_bytes()).hexdigest(),'driver_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}
    (out/'validator-regressions.json').write_text(json.dumps(data,indent=2)+'\n');print('Release validation regressions passed:',len(checks),'defects rejected.')
if __name__=='__main__':main()
