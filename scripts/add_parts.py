#!/usr/bin/env python3
"""
Syncs the parts lists in data/parts_*.json into data/products.json and data/content.json.
Safe to re-run. Then run: python3 scripts/build_store.py

Photos: put a file named images/parts/<slug>.jpg (or .jpeg/.png/.webp) where <slug> is the part's
page name (e.g. air-filter.jpg for parts/air-filter.html). Re-run this script and it is used instead
of the placeholder.
"""
import glob
import json
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)
PHONE = "646-943-1858"
PLACEHOLDER = "images/parts/engine-placeholder.svg"


def slugify(name):
    s = name.lower().replace("&", "and")
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return s


def photo_for(slug):
    for ext in ("jpg", "jpeg", "png", "webp"):
        if os.path.exists(f"images/parts/{slug}.{ext}"):
            return f"images/parts/{slug}.{ext}"
    return PLACEHOLDER


def main():
    pj = json.load(open("data/products.json", encoding="utf-8"))
    cj = json.load(open("data/content.json", encoding="utf-8"))
    by_id = {p["id"]: p for p in pj["products"]}
    total = 0
    for f in sorted(glob.glob("data/parts_*.json")):
        d = json.load(open(f, encoding="utf-8"))
        cat, sub = d["category"], d["subcategory"]
        seen = set()
        for name in d["items"]:
            slug = slugify(name)
            assert slug not in seen, f"duplicate part page name: {slug}"
            seen.add(slug)
            pid = f"{cat}-{sub}-{slug}"
            img = photo_for(slug)
            entry = by_id.get(pid) or {"id": pid}
            entry.update({"name": name, "category": cat, "subcategory": sub, "url": f"{cat}/{slug}.html",
                          "image": img, "price": None, "inStock": True} if "price" not in entry or entry["price"] is None
                         else {"name": name, "category": cat, "subcategory": sub, "url": f"{cat}/{slug}.html", "image": img})
            if pid not in by_id:
                pj["products"].append(entry)
                by_id[pid] = entry
            cj["products"][pid] = {
                "main": img, "thumbs": [img],
                "bullets": [f"{sub.title()} part", "Call for fitment and pricing", "Ships free once priced"],
                "specs": [["Category", f"Parts / {sub.title()}"], ["Pricing", f"Call {PHONE}"],
                          ["Shipping", "Free, continental U.S. only"]],
                "description": f"{name}: {sub} part from NYC ATV Warehouse in Little Ferry, NJ. Call {PHONE} with your make, model and year to confirm fit and get pricing. Priced parts ship free in the continental U.S.",
            }
            total += 1
    json.dump(pj, open("data/products.json", "w", encoding="utf-8", newline="\n"), indent=1, ensure_ascii=False)
    open("data/products.json", "a").write("\n")
    json.dump(cj, open("data/content.json", "w", encoding="utf-8", newline="\n"), indent=1, ensure_ascii=False)
    open("data/content.json", "a").write("\n")
    print(f"Synced {total} parts.")


if __name__ == "__main__":
    main()
