"""Check current-edition identity across release metadata and reader artifacts."""
import json,re

def check_metadata(root,pdf_text):
    def require(condition,detail):
        if not condition:raise RuntimeError(detail)
    version=(root/'VERSION').read_text().strip()
    require(re.fullmatch(r'\d+\.\d+\.\d+',version) is not None,'Invalid release version')
    record=json.loads((root/'publication/zenodo-record-draft.json').read_text())
    require(record['version']==version,'Release metadata version mismatch')
    doi=record['doi'];require(re.fullmatch(r'10\.5281/zenodo\.\d+',doi) is not None,'Invalid edition DOI')
    require(record['doi_status'] in ['reserved','published'],'Invalid DOI status')
    require(record['concept_doi']!=doi,'Concept DOI used as edition DOI')
    require(record['record_url']=='https://zenodo.org/records/'+doi.rsplit('.',1)[1],'Record URL differs from edition DOI')
    if record['doi_status']=='reserved':
        require(record['status'].startswith('PREPARED') and record['publication_date'] is None,'Reserved DOI falsely marked published')
    else:
        require(record['status'].startswith('PUBLISHED') and re.fullmatch(r'\d{4}-\d{2}-\d{2}',record['publication_date'] or ''),'Published metadata lacks publication date')
    require(doi in pdf_text,'Release metadata DOI missing from PDF')
    cff=(root/'CITATION.cff').read_text()
    require(re.findall(r'^\s*version: "([^"]+)"',cff,re.M)==[version,version],'Citation version mismatch')
    require(re.findall(r'^\s*doi: "([^"]+)"',cff,re.M)==[doi],'Citation DOI mismatch')
    require('https://orcid.org/'+record['orcid'] in cff,'Citation ORCID mismatch')
    require('name: "Zenodo"' in cff and record['repository_url'] in cff,'Citation publisher or repository missing')
    bib=(root/'publication/citation.bib').read_text()
    require(re.findall(r'\bversion\s*=\s*\{([^}]+)\}',bib)==[version],'BibTeX version mismatch')
    require(re.findall(r'\bdoi\s*=\s*\{([^}]+)\}',bib)==[doi],'BibTeX DOI mismatch')
    require(record['record_url'] in bib and 'publisher = {Zenodo}' in bib,'BibTeX publisher or URL mismatch')
    for name in ['README.md','book/manuscript.md','book/index.md']:
        text=(root/name).read_text()
        require(version in '\n'.join(text.splitlines()[:15]),('Reader artifact lacks current version',name))
        if name!='book/index.md':require(doi in text,('Reader artifact lacks edition DOI',name))
        require(not any(phrase in text for phrase in ['No edition number or DOI assigned','No new edition number','Unpublished next-edition working draft','open the next-edition folder']),('Obsolete draft status',name))
    for path in (root/'book/chapters').glob('*.md'):
        require(doi in '\n'.join(path.read_text().splitlines()[:6]),('Chapter edition DOI missing',path.name))
    require('## '+version+' ' in (root/'CHANGELOG.md').read_text(),'Changelog lacks current version')
    return {'status':'pass','version':version,'edition_doi':doi,'doi_status':record['doi_status'],'scope':'Local identity consistency; does not verify DOI registration or publication.'}
