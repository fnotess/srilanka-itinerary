"""Builds index.html from template.html + content/attractions-phase1.csv."""
import csv, json
from pathlib import Path
here = Path(__file__).parent
rows = list(csv.DictReader(open(here.parent / "content" / "attractions-phase1.csv")))
data = json.dumps(rows, ensure_ascii=False).replace("</", "<\\/")
(here / "index.html").write_text((here / "template.html").read_text().replace("__DATA__", data))
print(f"index.html built with {len(rows)} attractions")
