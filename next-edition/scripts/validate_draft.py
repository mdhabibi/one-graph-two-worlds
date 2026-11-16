"""Validate an unpublished PDF, source syntax, local links and retained input hashes."""
import argparse,hashlib,json,re,subprocess,sys
from pathlib import Path
from check_editorial import check_source,check_exports
import fitz
from pypdf import PdfReader
from rdflib import Graph
from rdflib.plugins.sparql.parser import parseQuery,parseUpdate
ROOT=Path(__file__).resolve().parent.parent

def require(condition,detail):
    if not condition:raise RuntimeError(detail)
def compact(text):return ''.join(text.split())

def validate(root):
    dest=root/'dist/draft-validation.json';dest.unlink(missing_ok=True)
    pdf=root/'dist/knowledge-graphs-tutorial.pdf';doc=fitz.open(pdf);reader=PdfReader(pdf)
    source=(root/'book/manuscript.md').read_text();records=json.loads((root/'dist/page-map.json').read_text())
    require(len(records)==len(re.split(r'^=== ',source,flags=re.M))-1,'Section count differs from source')
    build=json.loads((root/'dist/build-inputs.json').read_text())
    required_inputs={'book/manuscript.md','scripts/build_pdf.py','VERSION',*['assets/fonts/'+p.name for p in (root/'assets/fonts').glob('*.ttf')]}
    require(set(build['inputs'])==required_inputs,'Build input inventory mismatch')
    for name,digest in build['inputs'].items():require(hashlib.sha256((root/name).read_bytes()).hexdigest()==digest,('Build input drift',name))
    require(hashlib.sha256((root/'dist/page-map.json').read_bytes()).hexdigest()==build['page_map_sha256'],'Page map differs from build')
    editorial=check_source(source)
    exported=check_exports(root,source)
    page_ids={p.indirect_reference.idnum:i for i,p in enumerate(reader.pages)}
    texts=[p.get_text() for p in doc];full=' '.join(' '.join(t.split()) for t in texts)
    require(doc.metadata['author']=='Dr. Mahdi Habibi','PDF author metadata')
    require('(unpublished draft)' in doc.metadata.get('title',''),'PDF metadata lacks draft marker')
    for i,text in enumerate(texts):
        require('Dr. Mahdi Habibi' in text,('Author missing',i+1))
        require('\ufffd' not in text,('Replacement character',i+1))
        require(('Next-edition working draft' in text and 'Unpublished' in text) if i==0 else 'Unpublished working draft' in text,('Draft label missing',i+1))
    require('Version next-draft' not in texts[0],'Cover presents a placeholder as a version')
    for phrase in ['Independent paired reproduction remains open','143; all return equal pairs','Section 10.3 states the scoped alignment condition']:
        require(phrase in full,('Missing expected text',phrase))
    bounds=[]
    for n,page in enumerate(doc):
        for block in page.get_text('dict')['blocks']:
            for line in block.get('lines',[]):
                for span in line['spans']:
                    a,b,c,d=span['bbox']
                    valid=a>=0 and b>=0 and c<=page.rect.width and d<=page.rect.height
                    if n:valid=valid and a>=40 and c<=555 and b>=15 and d<=815
                    if not valid:bounds.append([n+1,span['text'],span['bbox']])
    require(not bounds,('Margin violations',bounds))
    targets=[];toc_pages=(len(records)+25)//26;all_links=[]
    for n,page in enumerate(reader.pages):
        for annotation in page.get('/Annots',[]):
            ann=annotation.get_object();destination=ann.get('/Dest')
            action=ann.get('/A')
            if destination is None and action is not None and action.get('/S')=='/GoTo':destination=action.get('/D')
            if destination is not None:
                require(isinstance(destination,list) and destination[0].idnum in page_ids,('Invalid internal link',n+1))
                target=page_ids[destination[0].idnum];all_links.append((n,ann,target))
                if 1<=n<=toc_pages:targets.append(target)
    expected=[]
    for title,page,*_ in records:
        require(compact(title) in compact(texts[page-1]),('Heading/page mismatch',title,page));expected.append(page-1)
    require(targets==expected,'Contents destinations differ from section headings')
    section_outline=[(title,page) for level,title,page in doc.get_toc() if level==2]
    require(section_outline==[(title,page) for title,page,*_ in records],'PDF section outline differs from page map')
    covers=[i for i,t in enumerate(texts) if re.search(r'CHAPTER \d{2}  /',t)]
    require(len(covers)==12,('Chapter cover count',len(covers)))
    for number,i in enumerate(covers,1):
        require(f'CHAPTER {number:02d}' in texts[i] and i+1<len(doc) and 'CHAPTER ' not in texts[i+1],('Chapter cover sequence',number))
    task=[i+1 for i,t in enumerate(texts) if any(h in ' '.join(t.split()) for h in ['Write a query before reading the solutions','Try these before reading the solutions'])]
    solutions=[i+1 for i,t in enumerate(texts) if 'Practice solutions — compare after trying' in ' '.join(t.split())]
    require(len(task)==len(solutions)==3,('Practice block count',task,solutions))
    require(all(s>t for t,s in zip(task,solutions)) and not set(task)&set(solutions),('Tasks/solutions share pages or are reversed',task,solutions))
    # Check the actual label under each numeric citation link against its reference entry.
    reference_numbers=set(re.findall(r'^\[(\d+)\] ',source,re.M));ref_start=min(page for title,page,part in records if part.startswith('XII'))-1
    references={}
    for i in range(ref_start,len(doc)):
        for match in re.finditer(r'^\[(\d+)\]\s',texts[i],re.M):references[match[1]]=i
    require(reference_numbers==set(references),'Reference entries missing from rendered PDF')
    citations=0;citation_rects={}
    for n,ann,target in all_links:
        if 1<=n<=toc_pages:continue
        a,b,c,d=[float(x) for x in ann['/Rect']];height=doc[n].rect.height
        label=doc[n].get_text('text',clip=fitz.Rect(a-.5,height-d-.5,c+.5,height-b+.5)).strip()
        match=re.fullmatch(r'[\[\],\s]*(\d+)[\[\],\s]*',label)
        require(match is not None,('Unrecognized internal citation label',n+1,label))
        citation_rects.setdefault(n,[]).append(fitz.Rect(a,height-d,c,height-b))
        number=match[1];require(number in references and target==references[number],('Citation target mismatch',n+1,number,target+1,references.get(number,-1)+1));citations+=1
    require(citations>0,'No checked citation links')
    # Verify coverage by rendered position, not counts: one citation may have several link rectangles.
    rendered_citations=0
    for n in range(toc_pages+1,ref_start):
        for block in doc[n].get_text('rawdict')['blocks']:
            for line in block.get('lines',[]):
                chars=[ch for span in line['spans'] if 'Mono' not in span['font'] for ch in span['chars']]
                text=''.join(ch['c'] for ch in chars)
                for group in re.finditer(r'\[(\d+(?:,\s*\d+)*)\]',text):
                    for number in re.finditer(r'\d+',group[1]):
                        start=group.start(1)+number.start();end=group.start(1)+number.end()
                        rect=fitz.Rect(chars[start]['bbox'])
                        for ch in chars[start+1:end]:rect|=fitz.Rect(ch['bbox'])
                        center=(rect.tl+rect.br)/2
                        require(any(center in area for area in citation_rects.get(n,[])),('Unlinked rendered citation',n+1,number[0]))
                        rendered_citations+=1
    require(rendered_citations>0,'No rendered citations checked')
    # Check the PDF hash after document checks so deliberate defects retain specific diagnostics.
    require(hashlib.sha256(pdf.read_bytes()).hexdigest()==build['pdf_sha256'],'PDF differs from recorded build')
    questions={};answers={}
    for block in re.split(r'^=== ',source,flags=re.M)[1:]:
        heading,body=block.split('\n',1);part=heading.split(' | ')[0]
        qs=[int(number) for number in re.findall(r'\*\*Question (\d+):',body)]
        if qs:
            questions.setdefault(part,[]).extend(qs)
            answers[part]=answers.get(part,0)+len(re.findall(r'^\*\*Answer:\*\*',body,re.M))
    for part,numbers in questions.items():
        require(numbers==list(range(1,len(numbers)+1)) and answers[part]==len(numbers),('Q&A numbering/answer mismatch',part))
    syntax={}
    for language,code in re.findall(r'```(\w+)\n(.*?)\n```',source,re.S):
        if language=='turtle':Graph().parse(data=code,format='turtle')
        elif language=='json':Graph().parse(data=code,format='json-ld')
        elif language=='sparql':(parseUpdate if 'INSERT DATA' in code else parseQuery)(code)
        else:continue
        syntax[language]=syntax.get(language,0)+1
    local_links=0
    for md in [root/'README.md',*(root/'book').rglob('*.md'),*(root/'lab').rglob('*.md'),*(root/'extensions').rglob('*.md')]:
        for target in re.findall(r'\]\(([^)]+)\)',md.read_text()):
            if re.match(r'^(https?://|#|mailto:)',target):continue
            path=target.split('#',1)[0]
            require((md.parent/path).exists(),('Missing local link',str(md.relative_to(root)),target));local_links+=1
    manifest=json.loads((root/'research/MANIFEST.json').read_text())
    for name,digest in manifest.items():require(hashlib.sha256((root/'research'/name).read_bytes()).hexdigest()==digest,('Research artifact drift',name))
    paired=json.loads((root/'research/equivalence/results/paired-run.json').read_text())
    for name,digest in paired['inputs'].items():require(hashlib.sha256((root/'research/equivalence'/name).read_bytes()).hexdigest()==digest,('Research input drift',name))
    web=json.loads((root/'dist/web-export.json').read_text())
    for group in ['inputs','outputs']:
        for name,digest in web[group].items():require(hashlib.sha256((root/name).read_bytes()).hexdigest()==digest,('Web export drift',name))
    require(web['numbered_sections']==sum(1 for _,_,part in records if not part.startswith('Reader guide')),'Web section count differs')
    # All exported numeric citations must resolve to actual reference anchors.
    for md in (root/'book/chapters').glob('*.md'):
        for path,anchor in re.findall(r'\]\(([^)#]+)#([^)]*)\)',md.read_text()):
            linked=md.parent/path
            require(linked.exists() and ('id="'+anchor+'"') in linked.read_text(),('Missing web reference anchor',md.name,anchor))
    for name,script in [('identity-evidence','check_identity.py'),('missing-data','check_missing_data.py')]:
        execution=subprocess.run([sys.executable,str(root/'extensions'/name/script)],text=True,capture_output=True)
        require(execution.returncode==0,('Extension failed',name,execution.stderr))
        require(json.loads(execution.stdout)==json.loads((root/'dist'/(name+'.json')).read_text()),('Extension report drift',name))
    extension=subprocess.run([sys.executable,str(root/'extensions/semantic-evolution/check_evolution.py')],text=True,capture_output=True)
    require(extension.returncode==0,('Semantic evolution exercise failed',extension.stderr))
    extension_report=json.loads(extension.stdout)
    require(extension_report==json.loads((root/'dist/semantic-evolution.json').read_text()),'Semantic evolution report drift')
    result={'editorial_checks':editorial,'exported_code_fences_checked':exported['code_fences'],'pdf_section_bookmarks_checked':len(section_outline),'web_chapter_draft_labels_checked':exported['chapters'],'web_chapters_checked':web['chapters'],'qa_pairs_checked':{part:len(numbers) for part,numbers in questions.items()},'new_exercise_reports_checked':3,'semantic_evolution_checks':len(extension_report['checks']),'status':'pass','pdf_sha256':hashlib.sha256(pdf.read_bytes()).hexdigest(),'pages':len(doc),'margin_violations':bounds,'contents_links':len(targets),'section_headings_checked':len(records),'chapter_covers':len(covers),'author_and_draft_status_on_every_page':True,'task_pages':task,'solution_pages':solutions,'rendered_citation_numbers_checked':rendered_citations,'build_inputs_checked':len(build['inputs']),'citation_links_checked':citations,'references':len(references),'syntax_checked':syntax,'local_links_checked':local_links,'retained_research_hashes':'pass','scope':'Document margins, status, author, covers, contents, task separation, citation targets, RDF/SPARQL syntax, local links, semantic-evolution exercise and retained hashes. No new graph-engine run, remote-link or accessibility certification.'}
    dest.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ['scope','pdf_sha256']},indent=2))
    return result
if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--root',type=Path,default=ROOT);validate(parser.parse_args().root.resolve())
