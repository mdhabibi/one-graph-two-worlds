"""Dependency-free evidence-path and validation helpers."""
from pathlib import Path

def require(condition, detail):
    if not condition: raise RuntimeError(detail)

def fresh_outputs(paths):
    paths=[Path(p) for p in paths]
    require(not any(p.exists() for p in paths),'Refusing to overwrite existing output: '+', '.join(str(p) for p in paths if p.exists()))
    for p in paths:p.parent.mkdir(parents=True,exist_ok=True)
