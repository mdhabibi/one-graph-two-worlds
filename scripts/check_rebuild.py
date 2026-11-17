"""Capture or compare PDF text/navigation; byte equality is reported, not required."""
import argparse,hashlib,json
from pathlib import Path
import fitz
ROOT=Path(__file__).resolve().parent.parent

def require(condition,detail):
    if not condition:raise RuntimeError(detail)

def snapshot(root):
    path=root/'dist/knowledge-graphs-tutorial.pdf'
    with fitz.open(path) as pdf:
        return {'pdf_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
                'page_text_sha256':[hashlib.sha256(' '.join(page.get_text().split()).encode()).hexdigest() for page in pdf],
                'page_map':json.loads((root/'dist/page-map.json').read_text()),
                'outline':pdf.get_toc(),
                'metadata':{key:pdf.metadata.get(key,'') for key in ['title','author','subject']}}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('mode',choices=['capture','compare'])
    parser.add_argument('--root',type=Path,default=ROOT)
    parser.add_argument('--baseline',type=Path)
    parser.add_argument('--out',type=Path,required=True)
    args=parser.parse_args();out=args.out.resolve()
    require(not out.exists(),('Refusing to overwrite',str(out)))
    current=snapshot(args.root.resolve())
    if args.mode=='compare':
        require(args.baseline is not None,'Compare needs --baseline')
        previous=json.loads(args.baseline.read_text())
        for key in ['page_text_sha256','page_map','outline','metadata']:
            require(previous[key]==current[key],('Rebuilt document content differs',key))
        result={'status':'pass','pages':len(current['page_text_sha256']),
                'baseline_pdf_sha256':previous['pdf_sha256'],'rebuilt_pdf_sha256':current['pdf_sha256'],
                'byte_equal':previous['pdf_sha256']==current['pdf_sha256'],
                'scope':'Normalized page text, page map, outline, title, author and subject. Byte equality not required; not visual or accessibility equivalence.'}
    else:result=current
    out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,indent=2)+'\n')
    print('Captured document snapshot.' if args.mode=='capture' else 'Rebuild content/navigation comparison passed.')
if __name__=='__main__':main()
