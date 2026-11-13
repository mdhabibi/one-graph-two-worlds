from pathlib import Path
import re, math, json, html, os
from functools import partial
from datetime import datetime, timezone
os.environ.setdefault("SOURCE_DATE_EPOCH",str(int(datetime(2026,11,13,tzinfo=timezone.utc).timestamp())))
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Flowable, KeepTogether, Preformatted, CondPageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from pypdf import PdfReader
ROOT=Path(__file__).resolve().parent.parent
OUT=ROOT/'dist'
OUT.mkdir(parents=True,exist_ok=True)
FONT_DIR=ROOT/'assets'/'fonts'
for name,file in [('Body','DejaVuSans.ttf'),('Bold','DejaVuSans-Bold.ttf'),('Serif','DejaVuSans.ttf'),('Mono','DejaVuSansMono.ttf')]:
    pdfmetrics.registerFont(TTFont(name,str(FONT_DIR/file)))
pdfmetrics.registerFontFamily('Body',normal='Body',bold='Bold',italic='Body',boldItalic='Bold')
NAVY=colors.HexColor('#132A46'); TEAL=colors.HexColor('#007F86'); ORANGE=colors.HexColor('#D9712B'); BLUE=colors.HexColor('#365CC6'); PURPLE=colors.HexColor('#7656AD'); INK=colors.HexColor('#203448'); MUTED=colors.HexColor('#526575'); LIGHT=colors.HexColor('#EEF5F8')
W,H=595.276,841.89
styles={
'p':ParagraphStyle('p',fontName='Body',fontSize=10.0,leading=14.4,textColor=INK,spaceAfter=9,allowWidows=0,allowOrphans=0),
'h':ParagraphStyle('h',fontName='Bold',fontSize=12,leading=16,textColor=TEAL,spaceBefore=10,spaceAfter=7,keepWithNext=True),
'small':ParagraphStyle('small',fontName='Body',fontSize=8.3,leading=10.6,textColor=MUTED,spaceAfter=4),
'cell':ParagraphStyle('cell',fontName='Body',fontSize=8.8,leading=12.2,textColor=INK),
'headcell':ParagraphStyle('headcell',fontName='Bold',fontSize=8.8,leading=12,textColor=colors.white),
'call':ParagraphStyle('call',fontName='Body',fontSize=9.3,leading=12.7,textColor=NAVY),
'code':ParagraphStyle('code',fontName='Mono',fontSize=8.3,leading=11.8,textColor=NAVY,backColor=LIGHT,borderPadding=10,spaceBefore=5,spaceAfter=10),
}
styles['answer']=ParagraphStyle('answer',parent=styles['p'],fontSize=9.7,leading=14.1,backColor=LIGHT,borderPadding=5,leftIndent=7,rightIndent=7,spaceBefore=3,spaceAfter=13)
refs={}
FIGURE_LABELS={}
FIGURE_TITLES={'running':'The learning catalog as connected facts','models':'One fact in RDF and LPG representations','stack':'Five responsibilities across the two approaches','identity':'Reconcile local IDs to a canonical course','ontology':'A class hierarchy for learning resources','world':'A missing fact and an explicit decision policy','validation':'Validate before publishing a candidate graph','event':'An identified completion occurrence with evidence','query':'Anchor, expand, and aggregate','hybrid':'A governed semantic source and application projection','rag':'Retrieve, expand, generate, and verify','decision':'Choose candidates by binding requirements','performance':'Selectivity, expansion, and output cost','rdfstore':'The application, RDF server, and storage engine'}

def rich(s):
    anchor=re.match(r'^\[(\d+)\] ',s)
    s=html.escape(s)
    if anchor: s=f'<a name="ref{anchor[1]}"/>'+s
    s=re.sub(r'\*\*(.*?)\*\*',r'<b>\1</b>',s)
    s=re.sub(r'`([^`]+)`',r'<font name="Mono" size="9">\1</font>',s)
    s=re.sub(r'\[(\d+(?:, \d+)*)\]',lambda m: '['+', '.join(f'<link href="#ref{n}" color="#365CC6">{n}</link>' for n in m[1].split(', '))+']',s)
    s=re.sub(r'(https://[^\s<]+)',lambda m: '<link href="'+m[0]+'" color="#365CC6">'+('neo4j.com — Operations Manual: Database transactions' if m[0]=='https://neo4j.com/docs/operations-manual/current/database-internals/transaction-management/' else m[0])+'</link>',s)
    return s

def P(s,sty='p'): return Paragraph(rich(s),styles[sty])

class Diagram(Flowable):
    def __init__(self,kind): Flowable.__init__(self);self.kind=kind;self.width=483;self.height=310 if kind=='stack' else 180 if kind not in ['decision','rag'] else 292 if kind=='rag' else 240
    def draw(self):
        c=self.canv; h=self.height
        c.setFillColor(colors.HexColor('#F5F8FB'));c.roundRect(0,0,self.width,h,9,fill=1,stroke=0)
        def box(x,y,w,t,sub='',col=TEAL):
            c.setFillColor(col);c.roundRect(x,y,w,42,6,fill=1,stroke=0)
            c.setFillColor(colors.white);c.setFont('Bold',9);c.drawCentredString(x+w/2,y+25,t)
            c.setFont('Body',8);c.drawCentredString(x+w/2,y+11,sub)
        def edge(x,y,X,Y,label=''):
            c.setStrokeColor(MUTED);c.setLineWidth(1.2);c.line(x,y,X,Y)
            a=math.atan2(Y-y,X-x);p=c.beginPath();p.moveTo(X,Y);p.lineTo(X-7*math.cos(a-.45),Y-7*math.sin(a-.45));p.lineTo(X-7*math.cos(a+.45),Y-7*math.sin(a+.45));p.close();c.setFillColor(MUTED);c.drawPath(p,fill=1,stroke=0)
            if label:c.setFont('Body',7.5);c.setFillColor(INK);c.drawCentredString((x+X)/2,(y+Y)/2+7,label)
        k=self.kind
        if k=='running':
            box(20,103,90,'Maya','learner');box(197,103,105,'Graph Basics','course',BLUE);box(374,103,90,'Graphs','topic',PURPLE)
            edge(110,124,197,124,'completed');edge(302,124,374,124,'about')
            box(197,22,105,'Graph Search','course',BLUE);edge(249,103,249,64,'prerequisite of');edge(302,43,419,103,'about')
            c.setStrokeColor(MUTED);c.setLineWidth(1.2);c.line(65,145,65,165);c.line(65,165,419,165);edge(419,165,419,145);c.setFont('Body',7.5);c.setFillColor(INK);c.drawCentredString(240,170,'likes topic')
        elif k=='models':
            box(18,110,100,'RDF','statement graph');box(185,110,110,'ex:c1','resource',BLUE);box(365,110,100,'ex:graphs','resource',PURPLE);edge(295,131,365,131,'ex:about')
            box(18,25,100,'Property graph','node + edge');box(185,25,110,'Course','id: c1',BLUE);box(365,25,100,'Topic','id: graphs',PURPLE);edge(295,46,365,46,'ABOUT')
        elif k=='stack':
            c.setFillColor(NAVY);c.setFont('Bold',9)
            c.drawCentredString(52,287,'SAME JOB')
            c.drawCentredString(193,287,'RDF APPROACH')
            c.drawCentredString(381,287,'LPG / NEO4J APPROACH')
            rows=[
                ('1  Identity','IRIs','Identify resources and terms','Stable node keys','IRIs can also be retained'),
                ('2  Facts','RDF triples','Subject / predicate / object','Nodes + relationships','Labels and properties'),
                ('3  Meaning','RDFS / OWL','Definitions and consequences','Domain model + rules','Explicitly chosen execution'),
                ('4  Questions','SPARQL','Match patterns in RDF','Cypher','Match graph patterns'),
                ('5  Quality','SHACL + store checks','Inspect the submitted graph','Constraints + app checks','Enforce the chosen contract')]
            for i,(job,rt,rs,pt,ps) in enumerate(rows):
                y=226-i*48
                c.setFillColor(colors.HexColor('#E1EAF0'));c.roundRect(8,y,88,42,5,fill=1,stroke=0)
                c.setFillColor(NAVY);c.setFont('Bold',8.5);c.drawCentredString(52,y+18,job)
                box(106,y,175,rt,rs,TEAL);box(294,y,175,pt,ps,BLUE)
            c.setFillColor(INK);c.setFont('Body',8)
            c.drawCentredString(241,20,'Read across each row. These are responsibilities, not processing stages.')
        elif k=='identity':
            box(20,103,125,'Source A: c1','local identifier',TEAL);box(338,103,125,'Source B: 73','local identifier',BLUE);box(160,23,163,'Canonical course','https://example.org/c1',PURPLE);edge(82,103,200,65,'mapping');edge(400,103,285,65,'mapping')
        elif k=='ontology':
            box(173,116,137,'Learning resource','general class',TEAL);box(38,24,137,'Course','specialization',BLUE);box(307,24,137,'Article','specialization',PURPLE);edge(107,66,205,116,'subclass of');edge(375,66,278,116,'subclass of')
        elif k=='world':
            box(20,103,126,'No completion fact','input');box(193,103,120,'OWL view','unknown',BLUE);box(348,103,115,'Policy view','not eligible',ORANGE);edge(146,124,193,124);edge(313,124,348,124)
            c.setFillColor(INK);c.setFont('Body',9);c.drawCentredString(241,48,'An application decision needs an explicit completeness policy.');c.drawCentredString(241,30,'Missing evidence is not automatically evidence of absence.')
        elif k=='validation':
            box(15,103,125,'Incoming data','candidate graph');box(180,103,125,'SHACL validation','shape version 1',BLUE);box(345,103,122,'Accepted graph','publish',TEAL);edge(140,124,180,124);edge(305,124,345,124);box(180,20,125,'Report / quarantine','repair',ORANGE);edge(242,103,242,62)
        elif k=='event':
            box(20,107,107,'Maya','Person');box(186,107,112,'Completion e1','score: 0.9',ORANGE);box(356,107,107,'Graph Basics','Course',BLUE);edge(186,128,127,128,'learner');edge(298,128,356,128,'course');box(186,19,112,'Evidence d1','source / time',PURPLE);edge(242,107,242,61,'supported by')
        elif k=='rdfstore':
            box(14,100,132,'Learning application','SPARQL client',TEAL)
            box(175,100,132,'Fuseki server','SPARQL endpoint',BLUE)
            box(336,100,132,'TDB2 store','Persistent RDF data',PURPLE)
            edge(146,121,175,121);edge(307,121,336,121)
            c.setFillColor(INK);c.setFont('Body',9)
            c.drawCentredString(241,63,'Illustrative implementation: Apache Jena Fuseki with TDB2')
            c.drawCentredString(241,43,'The baseline Python lab uses RDFLib in memory instead.')
        elif k=='query':
            box(15,104,110,'Anchor','Maya by ID');box(184,104,115,'Expand','completed',BLUE);box(354,104,115,'Match','about topic',PURPLE);edge(125,125,184,125);edge(299,125,354,125);box(184,21,115,'Aggregate','distinct courses',ORANGE);edge(411,104,299,42)
        elif k=='hybrid':
            box(16,108,130,'Canonical RDF','identity + ontology');box(188,108,130,'Projection pipeline','mapping version',ORANGE);box(358,108,110,'Property graph','application',BLUE);edge(146,129,188,129);edge(318,129,358,129);box(188,22,130,'Reconciliation','counts + hashes',PURPLE);edge(248,108,248,64)
        elif k=='rag':
            items=[(14,224,'Question','user + permissions',TEAL),(181,224,'Policy query','reviewed facts',TEAL),(348,224,'Retrieve','authorized text',BLUE),(348,137,'Expand','bounded graph',PURPLE),(181,137,'Evidence','filter + rank',ORANGE),(181,50,'Generate','cite sources',BLUE),(14,50,'Verify','answer or abstain',TEAL)]
            for x,y,t,sub,col in items:box(x,y,121,t,sub,col)
            edge(135,245,181,245);edge(302,245,348,245);edge(409,224,409,179);edge(348,158,302,158);edge(241,137,241,92);edge(181,71,135,71)
        elif k=='decision':
            box(141,184,200,'What is the binding requirement?','Choose by evidence',NAVY);box(15,106,140,'Shared formal meaning','evaluate RDF / OWL',TEAL);box(328,106,140,'Application traversal','evaluate property graph',BLUE);edge(182,184,85,148);edge(300,184,398,148);box(141,29,200,'Benchmark + governance review','hybrid only if justified',ORANGE);edge(85,106,180,71);edge(398,106,300,71)
        elif k=='performance':
            for x,t,s,col in [(18,'Selectivity','few starting nodes',TEAL),(180,'Fan-out','bounded expansion',BLUE),(342,'Output','small result set',ORANGE)]:box(x,105,124,t,s,col)
            edge(142,126,180,126);edge(304,126,342,126);c.setFont('Body',9);c.setFillColor(INK);c.drawCentredString(241,48,'Workload cost = access + joins / traversal + reasoning + transfer');c.drawCentredString(241,29,'A graph model alone does not determine latency.')
        c.setFillColor(MUTED);c.setFont('Body',7);c.drawString(10,7,FIGURE_LABELS.get(self.kind,self.kind))

class Title(Paragraph):
    def __init__(self,s,key,part):super().__init__(rich(s),ParagraphStyle('title',fontName='Bold',fontSize=23,leading=27,textColor=NAVY,spaceAfter=13,keepWithNext=True));self.key=key;self.part=part

CHAPTER_INTROS={
'I': ('Start with the story, then learn the graph.', 'Meet Maya and the learning catalog. Learn the vocabulary, identify the two approaches, and separate the responsibilities of a working graph system.', 'Entities / Connections / Identity'),
'II': ('Give facts a precise representation and meaning.', 'Read RDF statements and serializations, explore ontology definitions, and distinguish logical consequences from checks on submitted data.', 'RDF / RDFS / OWL / SHACL'),
'III': ('Turn a question into patterns and evidence.', 'Trace SPARQL results, handle missing and repeated values, and express the catalog recommendation policy with explicit data assumptions.', 'Patterns / Paths / Policy'),
'IV': ('Rebuild the same catalog as a property graph.', 'Model labeled nodes and relationships, query them with Cypher, and examine the guarantees and limits of constraints and transactions.', 'Labels / Properties / Cypher'),
'V': ('Preserve the distinctions that matter.', 'Give events and claims their own identities. Keep provenance, design ontologies, and map between representations without hiding information loss.', 'Events / Evidence / Interoperability'),
'VI': ('Choose an architecture through requirements.', 'Compare strengths in context, apply binding requirements before preference scores, and record a decision that evidence can challenge.', 'Requirements / Tradeoffs / Decisions'),
'VII': ('Test the system beyond the small example.', 'Examine realistic performance, recovery, governance, and security. Turn operational expectations into measurable checks and ownership.', 'Performance / Recovery / Governance'),
'VIII': ('Retrieve evidence before generating answers.', 'Combine structured policy with source passages, evaluate graph RAG failures, and keep predictions separate from reviewed eligibility facts.', 'Retrieval / Grounding / Analytics'),
'IX': ('Put the ideas to work.', 'Diagnose common mistakes, solve controlled exercises, and compare architecture cases using the models and policies developed throughout the book.', 'Practice / Diagnosis / Architecture'),
'X': ('Make the examples reproducible.', 'Locate the companion files, understand their execution scope, and use the lab instructions and expected outputs to check your understanding.', 'Files / Execution / Verification'),
'XI': ('Keep the vocabulary close at hand.', 'Return to concise definitions of the graph, semantic, query, and engineering terms used throughout the tutorial.', 'Terms / Definitions / Connections'),
'XII': ('Follow the ideas back to their sources.', 'Consult the specifications, research, and implementation documentation supporting the tutorial. Match implementation guidance to the release you use.', 'Standards / Research / Documentation'),
}

class ChapterCover(Flowable):
    def __init__(self,part,number):
        Flowable.__init__(self);self.part=part;self.number=number;self.width=483;self.height=690
    def draw(self):
        c=self.canv;c.saveState();c.resetTransforms()
        token,title=self.part.split(' · ',1);tagline,description,topics=CHAPTER_INTROS[token]
        accent=[TEAL,BLUE,PURPLE,ORANGE][(self.number-1)%4]
        c.setFillColor(colors.HexColor('#F3F7FA'));c.rect(0,0,W,H,fill=1,stroke=0)
        c.setFillColor(NAVY);c.rect(0,H-17,W,17,fill=1,stroke=0)
        c.setFillColor(accent);c.rect(56,H-109,42,5,fill=1,stroke=0)
        c.setFont('Bold',10);c.drawString(56,H-88,'KNOWLEDGE GRAPHS')
        c.setFillColor(accent);c.setFont('Bold',12);c.drawString(56,H-151,f'CHAPTER {self.number:02d}  /  {token}')
        def paragraph(text,y,size,leading,color,font='Body'):
            para=Paragraph(html.escape(text),ParagraphStyle('chapterText',fontName=font,fontSize=size,leading=leading,textColor=color))
            _,height=para.wrap(470,500);para.drawOn(c,56,y-height);return y-height
        y=paragraph(title,H-181,32,38,NAVY,'Bold')
        y=paragraph(tagline,y-26,15,21,accent,'Bold')
        paragraph(description,y-18,11,17,INK)
        # Original vector network: one visual language, a different chapter accent.
        pts=[(74,213),(173,270),(279,221),(395,279),(514,210),(409,133),(277,152),(160,121)]
        c.setStrokeColor(colors.HexColor('#C8D7E2'));c.setLineWidth(1.5)
        for a,b in [(0,1),(1,2),(2,3),(3,4),(4,5),(5,6),(6,7),(7,0),(1,7),(2,6),(2,5),(3,5)]:c.line(*pts[a],*pts[b])
        for i,(x,y) in enumerate(pts):
            c.setFillColor(accent if i in [self.number%8,(self.number+3)%8] else colors.HexColor('#9FB5C6'))
            c.circle(x,y,14 if i==self.number%8 else 7,fill=1,stroke=0)
        c.setFont('Bold',9);c.setFillColor(accent);c.drawString(56,78,topics)
        c.setStrokeColor(colors.HexColor('#CDDCE5'));c.line(56,54,539,54)
        c.setFillColor(MUTED);c.setFont('Body',9);c.drawString(56,34,'Dr. Mahdi Habibi');c.drawRightString(539,34,str(c.getPageNumber()))
        c.restoreState()

class Doc(SimpleDocTemplate):
    def afterFlowable(self,f):
        if isinstance(f,ChapterCover):
            key='chapter-'+str(f.number);self.canv.bookmarkPage(key)
            self.canv.addOutlineEntry(f.part,key,0,True)
            self.last_part=f.part;self.current_section=None
        elif isinstance(f,Title):
            self.canv.bookmarkPage(f.key)
            if re.fullmatch(r's\d+',f.key):
                if not hasattr(self,'section_record'):self.section_record=[]
                if getattr(self,'last_part',None)!=f.part:
                    partkey='part-'+f.key
                    self.canv.bookmarkPage(partkey);self.canv.addOutlineEntry(f.part,partkey,0,True)
                    self.last_part=f.part
                self.canv.addOutlineEntry(f.getPlainText(),f.key,1,True)
                self.section_record.append((f.getPlainText(),self.page,f.part))
                self.current_section=f.key;self.subheading=0
            else:
                self.canv.addOutlineEntry(f.getPlainText(),f.key,0,False);self.current_section=None
            self.record.append((f.getPlainText(),self.page,f.part))
        elif isinstance(f,Paragraph) and f.style.name=='h' and getattr(self,'current_section',None):
            self.subheading+=1;key=f'{self.current_section}-h{self.subheading}'
            self.canv.bookmarkPage(key);self.canv.addOutlineEntry(f.getPlainText(),key,2,False)

def frame(c,d):
    if d.page==1:return
    c.saveState();c.setStrokeColor(colors.HexColor('#D9E3EA'));c.line(56,791,539,791);c.setFillColor(MUTED);c.setFont('Body',8);c.drawString(56,802,'KNOWLEDGE GRAPHS  /  FROM FIRST PRINCIPLES TO ARCHITECTURE');c.line(56,48,539,48);c.drawString(56,33,'RDF • OWL • SPARQL • SHACL  |  Neo4j • Cypher');c.drawRightString(504,33,'Dr. Mahdi Habibi');c.drawRightString(539,33,str(d.page));c.restoreState()

class Cover(Flowable):
    def __init__(self):
        Flowable.__init__(self); self.width=483; self.height=690
    def draw(self):
        c=self.canv; c.resetTransforms(); c.translate(56,76);c.setFillColor(NAVY);c.rect(-56,-76,W,H,fill=1,stroke=0)
        c.setFillColor(colors.HexColor('#88DFD2'));c.setFont('Bold',11);c.drawString(0,659,'AN ILLUSTRATED TECHNICAL TUTORIAL')
        c.setFillColor(colors.white);c.setFont('Bold',40)
        for y,t in [(578,'Knowledge'),(530,'Graphs')]:c.drawString(0,y,t)
        c.setFont('Body',19);c.drawString(0,480,'Semantic graphs and property graphs');c.setFont('Body',13);c.drawString(0,450,'RDF / OWL / SPARQL / SHACL');c.drawString(0,429,'Neo4j labeled property graphs / Cypher');c.setFont('Bold',14);c.setFillColor(colors.HexColor('#88DFD2'));c.drawString(0,391,'Dr. Mahdi Habibi')
        pts=[(34,281),(146,335),(259,270),(398,327),(449,214),(321,168),(165,184),(55,127)]
        for a,b in [(0,1),(1,2),(2,3),(3,4),(4,5),(5,6),(6,7),(7,0),(0,6),(2,6),(2,5),(1,3)]:
            c.setStrokeColor(colors.HexColor('#395974'));c.setLineWidth(1.5);c.line(*pts[a],*pts[b])
        for i,(x,y) in enumerate(pts):c.setFillColor([TEAL,colors.HexColor('#EBA05D'),colors.HexColor('#8EA7F0'),colors.HexColor('#AA91D2')][i%4]);c.circle(x,y,11 if i%3 else 17,fill=1,stroke=0)
        c.setFillColor(colors.white);c.setFont('Body',11);c.drawString(0,67,'BEGINNER → PRACTITIONER → ARCHITECT');c.setFont('Body',9);c.drawString(0,42,'Running examples • Original diagrams • Worked queries • Decision frameworks');c.setFillColor(colors.HexColor('#B9CBD9'));c.drawString(0,15,'Version 0.1.0  |  Author review draft  |  13 November 2026')

def parse(body):
    lines=body.strip().splitlines();result=[];i=0
    while i<len(lines):
        line=lines[i].strip()
        if not line:i+=1;continue
        if line.startswith('```'):
            code=[];i+=1
            while i<len(lines) and not lines[i].startswith('```'):code.append(lines[i]);i+=1
            for s in code:
                if len(s)>85:print('LONG CODE',len(s),s)
            code_box=Table([[P(line[3:].strip().upper(),'small')],[Preformatted('\n'.join(code),styles['code'])]],colWidths=[483],splitByRow=0)
            code_box.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),LIGHT),('BOX',(0,0),(-1,-1),.5,colors.HexColor('#CCDCE5')),('LEFTPADDING',(0,0),(-1,-1),12),('RIGHTPADDING',(0,0),(-1,-1),12),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6)]))
            result.extend([code_box,Spacer(1,10)]);i+=1
        elif line.startswith('### '):
            if line[4:]=='A notation card to return to':result.append(CondPageBreak(350))
            if line[4:]=='Practice solutions — compare after trying':result.append(PageBreak())
            result.append(P(line[4:],'h'));i+=1
        elif line.startswith('@diagram '):result.extend([Diagram(line.split()[1]),Spacer(1,10)]);i+=1
        elif line.startswith('> '):
            t=Table([[P(line[2:],'call')]],colWidths=[483]);t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,-1),LIGHT),('BOX',(0,0),(-1,-1),.6,colors.HexColor('#B9DAD9')),('LEFTPADDING',(0,0),(-1,-1),12),('RIGHTPADDING',(0,0),(-1,-1),12),('TOPPADDING',(0,0),(-1,-1),10),('BOTTOMPADDING',(0,0),(-1,-1),10)]));result.extend([t,Spacer(1,10)]);i+=1
        elif line.startswith('|'):
            rows=[]
            while i<len(lines) and lines[i].strip().startswith('|'):
                row=[v.strip() for v in lines[i].strip().strip('|').split('|')]
                if not all(re.fullmatch(r'[-: ]+',v) for v in row):rows.append(row)
                i+=1
            n=len(rows[0]);widths=([104,189.5,189.5] if n==3 else [140,343] if n==2 else [483/n]*n)
            data=[[P(s,'headcell' if r==0 else 'cell') for s in row] for r,row in enumerate(rows)]
            t=Table(data,colWidths=widths,hAlign='LEFT',repeatRows=1);t.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),NAVY),('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,LIGHT]),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),8),('RIGHTPADDING',(0,0),(-1,-1),8),('TOPPADDING',(0,0),(-1,-1),6),('BOTTOMPADDING',(0,0),(-1,-1),6),('LINEBELOW',(0,0),(-1,0),.8,TEAL)]));result.extend([t,Spacer(1,10)])
        elif line.startswith('- '):result.append(Paragraph('• '+rich(line[2:]),styles['p']));i+=1
        elif re.match(r'^\d+\. ',line):result.append(P(line));i+=1
        else:
            para=[line];i+=1
            while i<len(lines) and lines[i].strip() and not lines[i].startswith(('###','```','> ','|','@diagram','- ')) and not re.match(r'^\d+\. ',lines[i]):para.append(lines[i].strip());i+=1
            para_flow=P(' '.join(para),'small' if line.startswith('https://') else 'answer' if line.startswith('**Answer:**') else 'p')
            if re.match(r'^\*\*(?:Worked fragment|Isolated|Separate JSON|Baseline|Schema|Dataset|Independent update|Pattern illustration|Loader excerpt|RDF model extension|LPG version|Architecture pseudocode|Local lab commands)',line) or next((x.strip() for x in lines[i:] if x.strip()),'').startswith('@diagram'):
                para_flow.keepWithNext=True
            if line.startswith('**Question'):para_flow.keepWithNext=True
            result.append(para_flow)
    return result

def build():
    content=(ROOT/'book'/'manuscript.md').read_text()
    global FIGURE_LABELS
    kinds=re.findall(r'^@diagram (\w+)',content,re.M)
    FIGURE_LABELS={k:f'Figure {i+1}. {FIGURE_TITLES[k]}' for i,k in enumerate(kinds)}
    sections=[]
    for block in re.split(r'^=== ',content,flags=re.M)[1:]:
        title,body=block.split('\n',1);part,title=title.split(' | ',1);sections.append((part,title,body))
    # Number sections and regenerate all contents destinations from the prior pass.
    roman=['I','II','III','IV','V','VI','VII','VIII','IX','X','XI','XII']
    seen={}
    numbered=[]
    for part,title,body in sections:
        token=part.split('·')[0].strip()
        if token in roman:
            seen[part]=seen.get(part,0)+1
            title=f'{roman.index(token)+1}.{seen[part]} {title}'
        numbered.append((part,title,body))
    sections=numbered
    toc_pages=math.ceil(len(sections)/26)
    records=[]
    for iteration in range(2):
        story=[Cover(),PageBreak()]
        for half in range(toc_pages):
            story.append(Title('Contents' if half==0 else 'Contents / continued',f'toc{half}','Reader guide'))
            start=half*26;end=min(len(sections),start+26)
            last=None
            for j in range(start,end):
                part,title,_=sections[j]
                if part!=last:story.append(Paragraph(rich(part),ParagraphStyle('tocgroup',fontName='Bold',fontSize=10,leading=12,textColor=TEAL,spaceBefore=5,spaceAfter=3)));last=part
                pg=records[j][1] if records else j+toc_pages+2
                para=Paragraph(f'<link href="#s{j}" color="#203448">{html.escape(title)} <font color="#526575"> · p. {pg}</font></link>',styles['small'])
                t=Table([[para]],colWidths=[483]);t.setStyle(TableStyle([('LEFTPADDING',(0,0),(-1,-1),0),('RIGHTPADDING',(0,0),(-1,-1),0),('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2)]));story.append(t)
            story.append(PageBreak())
        for j,(part,title,body) in enumerate(sections):
            token=part.split('·')[0].strip()
            chapter_start=token in roman and (j==0 or part!=sections[j-1][0])
            if chapter_start:
                story.extend([PageBreak(),ChapterCover(part,roman.index(token)+1),PageBreak()])
            elif j>0:
                if title.endswith('Separate the five layers'):story.append(PageBreak())
                elif part!=sections[j-1][0] and part.startswith('IX ·'):story.append(PageBreak())
                elif part!=sections[j-1][0]:story.extend([Spacer(1,26),CondPageBreak(500)])
                else:story.extend([Spacer(1,18),CondPageBreak(180)])
            part_label=P(part.upper(),'small');part_label.keepWithNext=True
            story.extend([part_label,Title(title,f's{j}',part)]);story.extend(parse(body))
        doc=Doc(str(OUT/'knowledge-graphs-tutorial.pdf'),pagesize=(W,H),rightMargin=56,leftMargin=56,topMargin=68,bottomMargin=66,title='Knowledge Graphs: Semantic Graphs and Property Graphs',author='Dr. Mahdi Habibi',subject='RDF, OWL, SPARQL, SHACL and Neo4j/Cypher tutorial',pageCompression=1)
        doc.record=[];doc.build(story,onFirstPage=frame,onLaterPages=frame,canvasmaker=partial(canvas.Canvas,invariant=1))
        records=doc.section_record
    (OUT/'page-map.json').write_text(json.dumps(records,indent=2))
    reader=PdfReader(OUT/'knowledge-graphs-tutorial.pdf')
    print(json.dumps({'pages':len(reader.pages),'sections':len(sections),'bytes':(OUT/'knowledge-graphs-tutorial.pdf').stat().st_size,'section_pages':[(r[0],r[1]) for r in records]},indent=2))
if __name__=='__main__':build()
