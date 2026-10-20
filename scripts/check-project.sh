#!/usr/bin/env bash
set -u

errors=0
required=(README.md .gitignore .env.example docs/api.md docs/setup.md)

echo "[CHECK] Campus Tasks"

# Check required files
for file in "${required[@]}"; do
  if [[ -f "$file" ]]; then
    echo "[OK] $file"
  else
    echo "[ERREUR] fichier absent: $file" >&2
    errors=$((errors + 1))
  fi
done

# Check tracked .env security risk
if git ls-files | grep -Eq '(^|/)\.env$'; then
  echo "[ERREUR] un fichier .env est suivi par Git" >&2
  errors=$((errors + 1))
else
  echo "[OK] aucun .env suivi"
fi

# Final Challenge: Check for uncommitted working directory changes
if [[ -n $(git status --porcelain) ]]; then
  echo "[ERREUR] le dépôt contient des modifications non validées" >&2
  errors=$((errors + 1))
else
  echo "[OK] répertoire de travail propre"
fi

# Exit status code
if [[ $errors -gt 0 ]]; then
  echo "[ECHEC] $errors erreur(s)" >&2
  exit 1
fi

echo "[SUCCES] contrôles validés"
exit 0
