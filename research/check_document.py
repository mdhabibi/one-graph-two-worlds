"""Check fresh PDF evidence: text, defined margins and links; no accessibility certification."""
import argparse,hashlib,json,sys
from pathlib import Path
import fitz
ROOT=Path(__file__).resolve().parent
sys.path.insert(0,str(ROOT/'equivalence'))
from support import fresh_outputs,require

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--pdf',type=Path,default=ROOT/'Research-Companion-Equivalence.pdf')
    p.add_argument('--report',type=Path,default=ROOT/'equivalence/results/paired-run.json')
    p.add_argument('--out',type=Path,default=ROOT/'equivalence/results')
    args=p.parse_args();target=args.out/'document-check.json';fresh_outputs([target])
    report=json.loads(args.report.read_text());require(report['status']=='pass','Paired report has not passed')
    doc=fitz.open(args.pdf);violations=[];links=[]
    for number,page in enumerate(doc,1):
        for block in page.get_text('dict')['blocks']:
            for line in block.get('lines',[]):
                for span in line['spans']:
                    x0,y0,x1,y1=span['bbox']
                    # Horizontal margins: 54 pt, allowing 1 pt glyph tolerance.
                    # Header/footer bands are intentional; body margins are 54/58 pt.
                    band=y1<=43 or y0>=798
                    valid=x0>=53 and x1<=page.rect.width-53 and y0>=10 and y1<=page.rect.height-10
                    if not band:valid=valid and y0>=53 and y1<=page.rect.height-57
                    if not valid:violations.append([number,span['text'],span['bbox']])
        links.extend(link['uri'] for link in page.get_links() if link.get('uri'))
    full=' '.join(' '.join(p.get_text().split()) for p in doc);compact=''.join(full.split())
    aligned=sum(r['verified_query_aligned'] for r in report['results'])
    integrity=sum(r['verified_fixture_integrity'] for r in report['results'])
    shapes=sum(r['shacl_conforms'] for r in report['results'])
    required=['When do two recommendation queries mean the same thing?','Dr. Mahdi Habibi',f"Paired datasets {report['case_count']}",f'Query alignment A {aligned}',f'Fixture integrity B {integrity}',f'SHACL intake C {shapes}','C12-all-multiple-prerequisites-completed','Independent paired reproduction remains open']
    missing=[t for t in required if ''.join(t.split()) not in compact]
    require(not violations and not missing and len(links)>0,{'margin_violations':violations,'missing':missing})
    data={'pdf_sha256':hashlib.sha256(args.pdf.read_bytes()).hexdigest(),'report_sha256':hashlib.sha256(args.report.read_bytes()).hexdigest(),'page_count':len(doc),'margin_violations':violations,'missing_expected_text':missing,'external_link_count':len(links),'scope':'Defined text margins with header/footer bands, report-derived counts, required text and link annotations. No remote-link, PDF/UA or screen-reader claim.'}
    target.write_text(json.dumps(data,indent=2)+'\n');print('Document checks passed:',len(doc),'pages;',len(links),'links.')
if __name__=='__main__':main()
