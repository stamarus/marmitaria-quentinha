# -*- coding: utf-8 -*-
"""
Healthcheck Script - Fast Static Analysis & Syntax Verification
Verifies JS syntax inside all HTML files, checks balanced braces, and catches syntax regressions.
"""
import os
import re
import sys
import subprocess
import tempfile

# Force UTF-8 stdout if needed
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

PROJECT_DIR = os.path.abspath(os.path.dirname(__file__))
HTML_FILES = ["index.html", "dashboard.html"]

def check_html_file(filepath):
    filename = os.path.basename(filepath)
    if not os.path.exists(filepath):
        print(f"[FAIL] File not found: {filename}")
        return False

    with open(filepath, "r", encoding="utf-8") as f:
        content = f.read()

    errors = []
    
    # 1. Check double comma in object literals/arrays (e.g. `foo: bar,,`)
    # Avoid false positives inside string literals or comments where feasible
    double_commas = [m.start() for m in re.finditer(r',\s*,', content)]
    if double_commas:
        errors.append(f"Found {len(double_commas)} instances of double comma (',,')")

    # 2. Extract and check JS syntax in all script tags
    scripts = re.findall(r'<script\b[^>]*>(.*?)</script>', content, re.DOTALL | re.IGNORECASE)
    for idx, script in enumerate(scripts):
        clean_script = script.strip()
        if not clean_script:
            continue
        
        with tempfile.NamedTemporaryFile(suffix=".js", delete=False, mode="w", encoding="utf-8") as tmp:
            tmp.write(clean_script)
            tmp_path = tmp.name

        try:
            res = subprocess.run(["node", "-c", tmp_path], capture_output=True, text=True, encoding="utf-8")
            if res.returncode != 0:
                errors.append(f"Script block #{idx + 1} syntax error:\n{res.stderr.strip()}")
        finally:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)

    if errors:
        print(f"[FAIL] {filename}:")
        for err in errors:
            print(f"   - {err}")
        return False
    else:
        print(f"[PASS] {filename} (all scripts and syntax valid)")
        return True

def main():
    print("\n--- Running Rapid Healthcheck ---")
    all_ok = True
    for html in HTML_FILES:
        path = os.path.join(PROJECT_DIR, html)
        if not check_html_file(path):
            all_ok = False

    if all_ok:
        print(">>> HEALTHCHECK 100% GREEN! Safe to commit/push.\n")
        sys.exit(0)
    else:
        print(">>> HEALTHCHECK FAILED! Fix errors before pushing.\n")
        sys.exit(1)

if __name__ == "__main__":
    main()
