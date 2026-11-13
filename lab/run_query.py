from pathlib import Path
import sys
from rdflib import Graph
root = Path(__file__).resolve().parent
data_file = sys.argv[1] if len(sys.argv) > 1 else "catalog.ttl"
query_file = sys.argv[2] if len(sys.argv) > 2 else "practice.rq"
graph = Graph().parse(root / data_file, format="turtle")
query = (root / query_file).read_text()
for row in graph.query(query):
    print(*(str(v) if v is not None else "(unbound)" for v in row),
          sep=" | ")
