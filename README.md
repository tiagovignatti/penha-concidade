# CONCIDADE Penha/SC — EIV/RIV

Dados e visualização dos Relatórios de Impacto de Vizinhança publicados pelo Conselho Municipal da Cidade de Penha/SC.

**Acesse online:** https://tiagovignatti.github.io/penha-concidade/

## Uso local

```bash
# Extrair dados dos PDFs (requer poppler-utils)
python3 scripts/parse_pdfs.py

# Servir a página localmente
python3 -m http.server 8000 -d docs/
# Abrir http://localhost:8000
```

## Estrutura

```
empreendimentos/   # 12 projetos com PDFs originais (EIV/RIV + Pareceres)
scripts/           # parse_pdfs.py, download_all.sh, scrape_page.js
docs/              # index.html + data.json (GitHub Pages)
```
