"""Download the pinned standalone HermiT bundle; no package installation.
Upstream: Owlready2 0.49 source distribution. Output must be a new directory.
The archive and JAR checksums are pinned to the verified artifacts.
"""
from pathlib import Path
import argparse,hashlib,io,json,tarfile,urllib.request
URL='https://files.pythonhosted.org/packages/62/06/de9eab54845aeb1a60d1b9bfe115e55540e00bab50d1ec52a4c503f33097/owlready2-0.49.tar.gz'
ARCHIVE_SHA='f076f0a89f64cf27088b69f2ff65c7d5c27da15c0ac6c5ac57ec726e89baf928'
JAR_SHA='97e53f519720a0a2e328556e03b806aa239347c85e57637a935e6433ed2ad3a8'
p=argparse.ArgumentParser(description=__doc__);p.add_argument('--output',required=True,type=Path);a=p.parse_args()
assert not a.output.exists(),'Choose a new output directory.'
data=urllib.request.urlopen(URL,timeout=60).read()
assert hashlib.sha256(data).hexdigest()==ARCHIVE_SHA,'Archive checksum mismatch'
with tarfile.open(fileobj=io.BytesIO(data),mode='r:gz') as archive:
 jars=[x for x in archive.getmembers() if x.isfile() and x.name.endswith('/hermit/HermiT.jar')]
 assert len(jars)==1
 jar=archive.extractfile(jars[0]).read()
 assert hashlib.sha256(jar).hexdigest()==JAR_SHA,'JAR checksum mismatch'
 notices=[x for x in archive.getmembers() if x.isfile() and x.name.endswith('/hermit/readme.txt')]
 assert len(notices)==1
 notice=archive.extractfile(notices[0]).read()
a.output.mkdir(parents=True)
(a.output/'HermiT.jar').write_bytes(jar);(a.output/'UPSTREAM-README.txt').write_bytes(notice)
(a.output/'download.json').write_text(json.dumps({'source':URL,'archive_sha256':ARCHIVE_SHA,'hermit_jar_sha256':JAR_SHA},indent=2)+'\n')
print('Verified standalone HermiT 1.3.8.1099 saved to '+str(a.output))
