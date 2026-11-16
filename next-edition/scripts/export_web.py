"""Export the editable book into ordinary Markdown chapters and original figures."""
from pathlib import Path
import re, importlib.util, io, html, json, hashlib
import fitz
from reportlab.pdfgen.canvas import Canvas
ROOT=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('book_renderer',ROOT/'scripts/build_pdf.py')
render=importlib.util.module_from_spec(spec);spec.loader.exec_module(render)
source=(ROOT/'book/manuscript.md').read_text()
kinds=re.findall(r'^@diagram (\w+)',source,re.M)
render.FIGURE_LABELS={k:f'Figure {i+1}. {render.FIGURE_TITLES[k]}' for i,k in enumerate(kinds)}
figdir=ROOT/'assets/figures';figdir.mkdir(parents=True,exist_ok=True)
for kind in kinds:
    d=render.Diagram(kind);buf=io.BytesIO();c=Canvas(buf,pagesize=(d.width,d.height),invariant=1)
    d.drawOn(c,0,0);c.save();pdf=fitz.open(stream=buf.getvalue(),filetype='pdf');page=pdf[0]
    label=render.FIGURE_LABELS[kind]
    svg=page.get_svg_image()
    svg=re.sub(r'(<svg[^>]*>)',r'\1<title>'+html.escape(label)+'</title>',svg,count=1)
    (figdir/f'{kind}.svg').write_text(svg)
    page.get_pixmap(matrix=fitz.Matrix(2,2),alpha=False).save(figdir/f'{kind}.png')
(ROOT/'book/chapters').mkdir(parents=True,exist_ok=True)
parts={}
for block in re.split(r'^=== ',source,flags=re.M)[1:]:
    heading,body=block.split('\n',1);part,title=heading.split(' | ',1)
    parts.setdefault(part,[]).append((title,body))
roman=['I','II','III','IV','V','VI','VII','VIII','IX','X','XI','XII']
index=['# Read the book','', '**Dr. Mahdi Habibi · Unpublished next-edition working draft**','',
       'Use the chapters in sequence for a first reading. The PDF has matching part and section labels.','']
for part,sections in parts.items():
    token=part.split('·')[0].strip();slug=re.sub(r'[^a-z0-9]+','-',part.lower()).strip('-')
    path=ROOT/'book/chapters'/f'{slug}.md';text=['# '+part,'','**Unpublished next-edition working draft. No edition number or DOI assigned.**','']
    for i,(title,body) in enumerate(sections):
        numbered=f'{roman.index(token)+1}.{i+1} {title}' if token in roman else title
        body=re.sub(r'^@diagram (\w+)',lambda m:f'![{render.FIGURE_LABELS[m[1]]}](../../assets/figures/{m[1]}.svg)',body,flags=re.M)
        # Link numbered citations to the master reference page's fragment anchors.
        if token!='XII':
            segments=re.split(r'(```[\s\S]*?```)',body)
            for k in range(0,len(segments),2):
                inline=re.split(r'(`[^`]*`)',segments[k])
                for j in range(0,len(inline),2):
                    inline[j]=re.sub(r'\[(\d+(?:, \d+)*)\]',lambda m:'['+', '.join(f'[{n}](xii-references.md#ref{n})' for n in m[1].split(', '))+']',inline[j])
                segments[k]=''.join(inline)
            body=''.join(segments)
        else:
            body=re.sub(r'^\[(\d+)\] ',lambda m:f'<a id="ref{m[1]}"></a>\n\n[{m[1]}] ',body,flags=re.M)
        text.extend(['## '+numbered,'',body.strip(),''])
    path.write_text('\n'.join(text).rstrip()+'\n')
    index.append(f'- [{part}](chapters/{slug}.md)')
(ROOT/'book/index.md').write_text('\n'.join(index)+'\n')
pdf=fitz.open(ROOT/'dist/knowledge-graphs-tutorial.pdf')
pdf[0].get_pixmap(matrix=fitz.Matrix(2,2),alpha=False).save(figdir/'cover.png')
print(f'Exported {len(parts)} chapter files and {len(kinds)} original figures (SVG + PNG).')

inputs=['book/manuscript.md','scripts/build_pdf.py','scripts/export_web.py','dist/knowledge-graphs-tutorial.pdf']
outputs=[*sorted((ROOT/'book/chapters').glob('*.md')),ROOT/'book/index.md',*sorted(figdir.glob('*'))]
report={'inputs':{name:hashlib.sha256((ROOT/name).read_bytes()).hexdigest() for name in inputs},'outputs':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in outputs if p.is_file()},'chapters':len(parts),'numbered_sections':sum(len(sections) for part,sections in parts.items() if part.split('·')[0].strip() in roman)}
(ROOT/'dist/web-export.json').write_text(json.dumps(report,indent=2)+'\n')
