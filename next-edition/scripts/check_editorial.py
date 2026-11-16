"""Check structural editorial invariants; this does not judge answer or citation meaning."""
from collections import Counter
import re

def require(condition, detail):
    if not condition:
        raise RuntimeError(detail)

def chapter_bodies(source):
    chapters={}
    for block in re.split(r'^=== ',source,flags=re.M)[1:]:
        heading,body=block.split('\n',1)
        chapters.setdefault(heading.split(' | ')[0],[]).append(body)
    return {part:'\n'.join(bodies) for part,bodies in chapters.items()}

def code_fences(text):
    return re.findall(r'```([^\n]*)\n(.*?)```',text,re.S)

def check_source(source):
    chapters=chapter_bodies(source);counts={};review_counts={};core_count=0
    for part,body in chapters.items():
        plain=re.sub(r'```[\s\S]*?```','',body)
        reviews=[int(x) for x in re.findall(r'^### Review (\d+)\b',plain,re.M)]
        require(reviews==list(range(1,len(reviews)+1)),('Review heading numbering',part,reviews))
        if reviews:review_counts[part]=len(reviews)
        numbers=[];pending=None
        tokens=re.finditer(r'^\*\*(?:Question (?P<number>\d+):|(?P<answer>Answer):\*\*)',plain,re.M) if re.search(r'^\*\*Question \d+:',plain,re.M) else []
        for token in tokens:
            if token['number']:
                require(pending is None,('Question missing its answer',part,pending))
                pending=int(token['number']);numbers.append(pending)
            else:
                require(pending is not None,('Answer without a pending question',part))
                pending=None
        require(pending is None,('Question missing its answer',part,pending))
        require(numbers==list(range(1,len(numbers)+1)),('Question numbering',part,numbers))
        if numbers:counts[part]=len(numbers)
        for listing in re.findall(r'core questions for this chapter are ([^\n.]+)\.',plain):
            for item in listing.split(','):
                match=re.fullmatch(r'\s*(\d+)(?:\s*[–-]\s*(\d+))?\s*',item)
                require(match is not None,('Malformed core-question reference',part,item))
                start=int(match[1]);end=int(match[2] or match[1])
                require(start<=end and all(n in numbers for n in range(start,end+1)),('Core-question reference missing',part,item))
                core_count+=end-start+1
    glossary='\n'.join(body for part,body in chapters.items() if part.startswith('XI ·'))
    terms=re.findall(r'^\*\*([^*\n]+):\*\*',glossary,re.M)
    key=lambda term:re.sub(r'[^a-z0-9]','',term.casefold())
    keys=[key(term) for term in terms]
    require(bool(keys) and keys==sorted(keys) and len(keys)==len(set(keys)),('Glossary ordering or duplicate entry',terms))
    return {'qa_pairs':counts,'review_headings':review_counts,'core_question_references':core_count,'glossary_entries':len(terms)}

def check_exports(root,source):
    chapters=chapter_bodies(source);exports={};fences=0
    for md in (root/'book/chapters').glob('*.md'):
        text=md.read_text();part=text.splitlines()[0].removeprefix('# ')
        require(part not in exports,('Duplicate web chapter',part))
        require('Unpublished next-edition working draft' in '\n'.join(text.splitlines()[:6]),('Web chapter draft label missing',md.name))
        exports[part]=text
    require(set(chapters)==set(exports),'Web chapter inventory differs from manuscript')
    for part,body in chapters.items():
        original=code_fences(body);exported=code_fences(exports[part])
        require(original==exported,('Exported code fence differs',part))
        fences+=len(original)
    require('Unpublished next-edition working draft' in (root/'book/index.md').read_text(),'Web index draft label missing')
    return {'chapters':len(exports),'code_fences':fences}
