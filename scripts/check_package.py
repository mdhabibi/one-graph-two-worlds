"""Check the publication artifact and local source relationships; no publishing."""
from pathlib import Path
import re,json,hashlib
import fitz
from rdflib import Graph
from rdflib.plugins.sparql.parser import parseQuery,parseUpdate
ROOT=Path(__file__).resolve().parent.parent
source=(ROOT/'book/manuscript.md').read_text();pdf=fitz.open(ROOT/'dist/knowledge-graphs-tutorial.pdf')
assert pdf.metadata['author']=='Dr. Mahdi Habibi'
assert all('Dr. Mahdi Habibi' in page.get_text() for page in pdf)
assert 'Public review draft' in pdf[0].get_text()
version=(ROOT/'VERSION').read_text().strip()
assert f'Version {version}' in pdf[0].get_text()
record=json.loads((ROOT/'publication/zenodo-record-draft.json').read_text())
pdf_text=' '.join(' '.join(p.get_text().split()) for p in pdf)
assert record['version']==version
if record['doi']:
    assert record['doi'] in pdf_text
else:
    assert record['status'].startswith('PREPARED'), 'A published edition must have its own DOI'
assert record['version'] in pdf_text
assert 'not yet an archived public release' not in pdf_text
assert 'Reserved DOI:' not in pdf_text
assert 'author review draft' not in pdf_text.lower()
# Publication status belongs to release metadata; historical PDF wording is not
# an invariant future editions should be forced to retain.
sections=re.split(r'^=== ',source,flags=re.M)[1:]
page_map=json.loads((ROOT/'dist/page-map.json').read_text())
assert len(page_map)==len(sections)
# Match every contents link to the expected numbered title at its destination.
links=[link for p in pdf for link in p.get_links()]
def destination(link):
    if link['kind']==fitz.LINK_GOTO:return link.get('page',-1)
    if link['kind']==fitz.LINK_NAMED and str(link.get('page','')).isdigit():return int(link['page'])-1
    return None
assert all(0<=destination(x)<len(pdf) for x in links if destination(x) is not None)
for title,page,part in page_map:
    text=' '.join(pdf[page-1].get_text().split())
    assert ' '.join(title.split()) in text,(title,page)
    assert any(destination(x)==page-1 for x in links[:200]),(title,'contents destination')
chapter_covers=[i for i,page in enumerate(pdf) if re.search(r'CHAPTER \d{2}  /',page.get_text())]
assert len(chapter_covers)==12,chapter_covers
for number,i in enumerate(chapter_covers,1):
    assert f'CHAPTER {number:02d}' in pdf[i].get_text()
    assert i+1<len(pdf) and 'CHAPTER ' not in pdf[i+1].get_text()
task_pages=[i+1 for i,page in enumerate(pdf) if 'Write a query before reading the solutions' in ' '.join(page.get_text().split())]
solution_pages=[i+1 for i,page in enumerate(pdf) if 'Practice solutions — compare after trying' in ' '.join(page.get_text().split())]
assert len(task_pages)==len(solution_pages)==2
assert all(solution>task for task,solution in zip(task_pages,solution_pages))
assert not set(task_pages)&set(solution_pages)
bounds=[]
for n,page in enumerate(pdf):
    assert '\ufffd' not in page.get_text()
    for b in page.get_text('dict')['blocks']:
        for line in b.get('lines',[]):
            for span in line['spans']:
                x0,y0,x1,y1=span['bbox']
                if n and (x0<40 or x1>555 or y0<15 or y1>815):bounds.append((n+1,span['text']))
assert not bounds,bounds
syntax={}
for lang,code in re.findall(r'```(\w+)\n(.*?)\n```',source,re.S):
    if lang=='turtle':Graph().parse(data=code,format='turtle')
    elif lang=='json':Graph().parse(data=code,format='json-ld')
    elif lang=='sparql':
        (parseUpdate if 'INSERT DATA' in code else parseQuery)(code)
    else:continue
    syntax[lang]=syntax.get(lang,0)+1
# Verify generated local links; fragments need no network access.
for md in list((ROOT/'book').rglob('*.md'))+[ROOT/'README.md']:
    if md.name=='manuscript.md':continue
    for target in re.findall(r'\]\(([^)]+)\)',md.read_text()):
        if re.match(r'^(https?://|#)',target):continue
        path=target.split('#',1)[0]
        assert (md.parent/path).exists(),(str(md.relative_to(ROOT)),target)
# Ensure the targeted reasoner evidence still matches the delivered sources/inputs.
owl_report=json.loads((ROOT/'publication/owl-dl-validation.json').read_text())
assert owl_report['status']=='pass'
for name,expected in owl_report['sources'].items():
    path=ROOT/'lab'/name if name in ['catalog.ttl','ontology.ttl'] else ROOT/'lab/owl_dl'/name
    assert hashlib.sha256(path.read_bytes()).hexdigest()==expected,('OWL source drift',name)
for name,expected in owl_report['generated_input_sha256'].items():
    assert hashlib.sha256((ROOT/'lab/owl_dl/fixtures'/name).read_bytes()).hexdigest()==expected,('OWL fixture drift',name)
report={'pages':len(pdf),'chapter_covers':len(chapter_covers),'sections':len(sections),'diagrams':source.count('@diagram '),
        'targeted_owl_dl_evidence':'pass',
        'references':len(re.findall(r'^\[\d+\] ',source,re.M)),
        'bookmarks':len(pdf.get_toc()),'internal_links':sum(destination(x) is not None for x in links),
        'syntax_checked':syntax,'page_margin_bounds':'pass','local_links':'pass','author_on_every_page':True,
        'pdf_sha256':hashlib.sha256((ROOT/'dist/knowledge-graphs-tutorial.pdf').read_bytes()).hexdigest(),
        'scope':'Automated document and fixture checks; not independent peer review or PDF/UA certification.'}
# Regenerate page metadata from the actual rendered artifact, never hand-edit it.
edition_path=ROOT/'publication/EDITION-CHECK.json'
edition=json.loads(edition_path.read_text())
texts=[' '.join(page.get_text().split()) for page in pdf]
start=next(i+1 for i,text in enumerate(texts) if 'Question 1: Why can a query with a short graph pattern' in text)
end=next(i+1 for i,text in enumerate(texts) if 'Question 20: A faulty mapping release' in text)
edition['chapter_7_review_pages']=[start,end]
edition['writing_task_pages']=task_pages
edition['writing_solution_pages']=solution_pages
edition['pdf_sha256']=report['pdf_sha256']
edition['page_metadata']='Regenerated from PDF text by scripts/check_package.py'
edition_path.write_text(json.dumps(edition,indent=2)+'\n')
(ROOT/'publication/package-validation.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
