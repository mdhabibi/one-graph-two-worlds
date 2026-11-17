"""Build the standalone research module from Markdown and retained run evidence."""
from pathlib import Path
import argparse,re,html,textwrap,json,hashlib,sys
from reportlab.platypus import SimpleDocTemplate,Paragraph,Spacer,PageBreak,Preformatted,Table,TableStyle,Flowable,KeepTogether,ListFlowable,ListItem
from reportlab.lib.styles import getSampleStyleSheet,ParagraphStyle
from reportlab.lib import colors
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas
from functools import partial
R=Path(__file__).resolve().parent;E=R/'equivalence'
sys.path.insert(0,str(E))
from support import fresh_outputs
for name,file in [('Body','DejaVuSans.ttf'),('Bold','DejaVuSans-Bold.ttf'),('Mono','DejaVuSansMono.ttf')]:pdfmetrics.registerFont(TTFont(name,str(R/'assets/fonts'/file)))
pdfmetrics.registerFontFamily('Body',normal='Body',bold='Bold',italic='Body',boldItalic='Bold')
navy=colors.HexColor('#142B46');teal=colors.HexColor('#007F86');pale=colors.HexColor('#EDF5F7');ink=colors.HexColor('#25364A')
styles=getSampleStyleSheet();styles.add(ParagraphStyle('BodyKG',fontName='Body',fontSize=9.4,leading=13.0,textColor=ink,spaceAfter=6))
for n,size in [(1,20),(2,14),(3,11)]:styles.add(ParagraphStyle('KG'+str(n),fontName='Bold',fontSize=size,leading=size+5,textColor=teal if n>1 else navy,spaceBefore=12,spaceAfter=8,keepWithNext=True))
styles.add(ParagraphStyle('CodeKG',fontName='Mono',fontSize=8.0,leading=11,backColor=pale,borderPadding=7,spaceAfter=10))
styles.add(ParagraphStyle('CellKG',parent=styles['BodyKG'],fontSize=8,leading=11,spaceAfter=0))
def rich(s):
 s=html.escape(s);links=[]
 def keep(label,url):
  key=f'LINKTOKEN{len(links)}END';links.append(f'<link href="{url}" color="#365CC6">{label}</link>');return key
 s=re.sub(r'\[([^\]]+)\]\((https?://[^)]+)\)',lambda m:keep(m[1],m[2]),s)
 s=re.sub(r'https?://[^\s<>]+',lambda m:keep(m[0],m[0]),s)
 s=re.sub(r'\*\*(.+?)\*\*',r'<b>\1</b>',s);s=re.sub(r'`([^`]+)`',r'<font name="Mono">\1</font>',s)
 for i,link in enumerate(links):s=s.replace(f'LINKTOKEN{i}END',link)
 return s
class Diagram(Flowable):
 def __init__(self):
  super().__init__();self.width=487;self.height=180
 def draw(self):
  c=self.canv
  def box(x,y,w,h,label,color):
   c.setFillColor(color);c.roundRect(x,y,w,h,7,fill=1,stroke=0);c.setFillColor(colors.white);c.setFont('Bold',10);c.drawCentredString(x+w/2,y+h/2-3,label)
  def arrow(x1,y1,x2,y2):
   c.setStrokeColor(teal);c.setLineWidth(1.5);c.line(x1,y1,x2,y2);c.line(x2,y2,x2-4,y2+4);c.line(x2,y2,x2+4,y2+4)
  box(126,142,235,30,'Same conceptual facts + explicit contract',navy)
  box(27,82,185,32,'RDF / SPARQL',teal);box(275,82,185,32,'LPG / Cypher',teal)
  c.setStrokeColor(teal);c.line(185,142,119,114);c.line(303,142,367,114)
  arrow(119,82,119,58);arrow(367,82,367,58)
  box(27,28,185,30,'Observed result pairs',navy);box(275,28,185,30,'Observed result pairs',navy)
  c.setFont('Bold',9);c.setFillColor(teal);c.drawCentredString(243,39,'COMPARE')
  c.setFont('Body',8);c.drawCentredString(243,9,'Agreement is conditional; counterexamples test the boundary.')
def parse(s):
 out=[];lines=s.splitlines();i=0
 while i<len(lines):
  line=lines[i]
  if not line.strip():i+=1;continue
  if line.startswith('```'):
   code=[];i+=1
   while i<len(lines) and not lines[i].startswith('```'):code.extend(textwrap.wrap(lines[i],width=88,replace_whitespace=False,drop_whitespace=False) or ['']);i+=1
   out.append(KeepTogether([Preformatted('\n'.join(code),styles['CodeKG'])]));i+=1;continue
  if line.startswith('|'):
   rows=[]
   while i<len(lines) and lines[i].startswith('|'):
    cells=[x.strip() for x in lines[i].strip().strip('|').split('|')]
    if not all(re.fullmatch(r'[:\- ]+',x) for x in cells):rows.append([Paragraph(rich(x),styles['CellKG']) for x in cells])
    i+=1
   widths=[155,332] if len(rows[0])==2 else ([190,50,100,147] if len(rows[0])==4 else ([225,55,65,60,82] if len(rows[0])==5 else [487/len(rows[0])]*len(rows[0])))
   t=Table(rows,colWidths=widths,repeatRows=1,hAlign='LEFT');t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),pale),('VALIGN',(0,0),(-1,-1),'TOP'),('LINEBELOW',(0,0),(-1,0),.8,teal),('BOTTOMPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),7),('GRID',(0,1),(-1,-1),.3,colors.HexColor('#DCE7ED'))]));out.extend([t,Spacer(1,9)]);continue
  if line.startswith('- ') or re.match(r'^\d+\. ',line):
   numbered=not line.startswith('- ');items=[]
   while i<len(lines) and (bool(re.match(r'^\d+\. ',lines[i])) if numbered else lines[i].startswith('- ')):
    text=re.sub(r'^\d+\. |^- ','',lines[i]);i+=1
    while i<len(lines) and lines[i].startswith('   '):text+=' '+lines[i].strip();i+=1
    items.append(ListItem(Paragraph(rich(text),styles['BodyKG'])))
   out.append(ListFlowable(items,bulletType='1' if numbered else 'bullet',leftIndent=14,bulletFontName='Body',bulletFontSize=9.4 if numbered else 7));continue
  if line in ['## Inspect the boundary cases','## 8. Primary references','## Retained evidence']:out.append(PageBreak())
  if line.startswith('#'):
   m=re.match(r'(#+) (.*)',line);level=min(len(m[1]),3);out.append(Paragraph(rich(m[2]),styles['KG'+str(level)]));i+=1;continue
  group=[line];i+=1
  while i<len(lines) and lines[i].strip() and not lines[i].startswith(('#','```','|','- ')):
   if re.match(r'^\d+\. ',lines[i]):break
   group.append(lines[i]);i+=1
  out.append(Paragraph(rich(' '.join(x.strip() for x in group)),styles['BodyKG']))
 return out

def footer(c,d):
 c.setStrokeColor(teal);c.line(54,43,541,43);c.setFont('Body',8);c.setFillColor(navy);c.drawString(54,29,'Dr. Mahdi Habibi · Research companion · Working draft');c.drawRightString(541,29,str(d.page))
 c.setFont('Body',7.5);c.drawString(54,818,'KNOWLEDGE GRAPHS | REPRODUCIBLE EQUIVALENCE STUDY')
if __name__=='__main__':
 parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--out',type=Path,default=R);parser.add_argument('--results',type=Path,default=E/'derived/RESULTS.md');parser.add_argument('--report',type=Path,default=E/'results/paired-run.json');args=parser.parse_args()
 destination=args.out/'Research-Companion-Equivalence.pdf';fresh_outputs([destination])
 report=json.loads(args.report.read_text())
 if report['status']!='pass':raise RuntimeError('Paired report has not passed')
 out=[Spacer(1,45),Paragraph('When do two recommendation queries mean the same thing?',ParagraphStyle('Cover',fontName='Bold',fontSize=26,leading=33,textColor=navy,spaceAfter=18)),Paragraph('A contract, counterexamples, and a reproducible RDF–Cypher experiment',styles['KG2']),Spacer(1,16),Paragraph('Dr. Mahdi Habibi',styles['KG2']),Paragraph('16 November 2026 · Working research module',styles['BodyKG']),Spacer(1,25),Diagram(),Spacer(1,15),Paragraph('Scope: one published recommendation query pair; 145 controlled datasets. This is a research companion in development, not a general graph-model equivalence claim or a performance benchmark.',styles['BodyKG']),PageBreak()]
 out.extend(parse((E/'PROTOCOL.md').read_text()));out.append(PageBreak());out.extend(parse(args.results.read_text()))
 d=SimpleDocTemplate(str(destination),pagesize=(595.28,841.89),leftMargin=54,rightMargin=54,topMargin=55,bottomMargin=58,title='When do two recommendation queries mean the same thing?',author='Dr. Mahdi Habibi',subject='Controlled query-equivalence study, working draft')
 d.build(out,onFirstPage=footer,onLaterPages=footer,canvasmaker=partial(canvas.Canvas,invariant=1));print('Built',destination)
