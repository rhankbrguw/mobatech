import os
import re

directories = [
    'mobatech-flutter/lib',
    'mobatech-backend',
    'mobatech-crm/src',
    'mobatech-ai'
]

exclude_dirs = ['node_modules', '.next', 'build', 'out', 'vendor', '.dart_tool']
exclude_files = ['doctor.go', 'AGENTS.md', 'SKILL.md', 'README.md', 'package-lock.json', 'pubspec.lock', 'go.sum']

violations = {
    'oversized_files': [],
    'hardcoded_colors': [],
    'ai_comments': [],
    'secrets': []
}

color_regex = re.compile(r'(?<!\w)(#[0-9a-fA-F]{3,8}|rgba?\([^)]+\))')
ai_comment_regex = re.compile(r'//\s*(this function|here we|note that|todo|fixme|step \d|let\'s)', re.IGNORECASE)
secret_regex = re.compile(r'(sk-[a-zA-Z0-9]{20,}|AIza[0-9A-Za-z-_]{35}|password\s*=\s*["\'][^"\']+["\'])')

for d in directories:
    for root, dirs, files in os.walk(d):
        dirs[:] = [di for di in dirs if di not in exclude_dirs]
        for f in files:
            if f in exclude_files or f.endswith('.png') or f.endswith('.svg') or f.endswith('.csv'):
                continue
            
            filepath = os.path.join(root, f)
            try:
                with open(filepath, 'r', encoding='utf-8') as file:
                    lines = file.readlines()
            except Exception:
                continue
                
            if len(lines) > 150:
                violations['oversized_files'].append((filepath, len(lines)))
                
            for i, line in enumerate(lines):
                # Skip theme files for colors
                if not ('theme' in filepath.lower() or 'color' in filepath.lower() or 'css' in filepath.lower() or 'tailwind.config' in filepath.lower()):
                    if color_regex.search(line):
                        violations['hardcoded_colors'].append((filepath, i+1, line.strip()))
                
                if ai_comment_regex.search(line):
                    violations['ai_comments'].append((filepath, i+1, line.strip()))
                    
                if secret_regex.search(line):
                    violations['secrets'].append((filepath, i+1, line.strip()))

print(f"Oversized files (>150 lines): {len(violations['oversized_files'])}")
for f, l in violations['oversized_files']:
    print(f"  {f}: {l} lines")

print(f"\nHardcoded colors: {len(violations['hardcoded_colors'])}")
for f, l, c in violations['hardcoded_colors'][:10]:
    print(f"  {f}:{l} -> {c}")
if len(violations['hardcoded_colors']) > 10: print("  ...")

print(f"\nAI/Bad comments: {len(violations['ai_comments'])}")
for f, l, c in violations['ai_comments'][:10]:
    print(f"  {f}:{l} -> {c}")
if len(violations['ai_comments']) > 10: print("  ...")

print(f"\nSecrets/Keys leaked: {len(violations['secrets'])}")
for f, l, c in violations['secrets']:
    print(f"  {f}:{l} -> {c}")
