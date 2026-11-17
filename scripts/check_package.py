"""Validate the current book package and retained OWL inputs; no publication."""
import hashlib,json
from pathlib import Path
import fitz
from validate_release import validate
ROOT=Path(__file__).resolve().parent.parent

def main():
    # Remove former pass reports before checking the current candidate.
    for name in ['package-validation.json','EDITION-CHECK.json']:
        (ROOT/'publication'/name).unlink(missing_ok=True)
    report=validate(ROOT)
    owl=json.loads((ROOT/'publication/owl-dl-validation.json').read_text())
    if owl['status']!='pass':raise RuntimeError('Retained OWL report did not pass')
    for name,digest in owl['sources'].items():
        path=ROOT/'lab'/name if name in ['catalog.ttl','ontology.ttl'] else ROOT/'lab/owl_dl'/name
        if hashlib.sha256(path.read_bytes()).hexdigest()!=digest:raise RuntimeError(('OWL source drift',name))
    for name,digest in owl['generated_input_sha256'].items():
        if hashlib.sha256((ROOT/'lab/owl_dl/fixtures'/name).read_bytes()).hexdigest()!=digest:raise RuntimeError(('OWL fixture drift',name))
    with fitz.open(ROOT/'dist/knowledge-graphs-tutorial.pdf') as pdf:
        texts=[' '.join(page.get_text().split()) for page in pdf]
        start=next(i+1 for i,t in enumerate(texts) if 'Question 1: Why can a query with a short graph pattern' in t)
        end=next(i+1 for i,t in enumerate(texts) if 'Question 20: A faulty mapping release' in t)
    edition={'version':report['version'],'edition_doi':report['metadata_checks']['edition_doi'],
             'pages':report['pages'],'review_questions':report['qa_pairs_checked'],
             'total_review_questions':sum(report['qa_pairs_checked'].values()),
             'glossary_entries':report['editorial_checks']['glossary_entries'],
             'chapter_7_review_pages':[start,end],'writing_task_pages':report['task_pages'],
             'writing_solution_pages':report['solution_pages'],'pdf_sha256':report['pdf_sha256'],
             'page_metadata':'Regenerated from PDF text by scripts/check_package.py',
             'targeted_owl_dl_evidence':'Retained report inputs match; fresh targeted run recorded separately in publication/owl-0.2.0-validation.json',
             'scope':'Automated document, editorial and retained-input checks; no human peer review or production certification.'}
    (ROOT/'publication/EDITION-CHECK.json').write_text(json.dumps(edition,indent=2)+'\n')
    (ROOT/'publication/package-validation.json').write_text(json.dumps(report,indent=2)+'\n')
    print('Release package checks passed for version '+report['version'])
if __name__=='__main__':main()
