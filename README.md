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
empreendimentos/       # 12 projetos com PDFs originais (EIV/RIV + Pareceres)
convocacoes_atas/      # 97 arquivos do portal (convocações + atas)
  convocacoes/         #   64 editais de convocação (2023–2026)
  atas/                #   33 atas de reuniões e audiências (2020–2025)
scripts/               # parse_pdfs.py, download_all.sh, download_convocacoes_atas.sh
docs/                  # index.html + data.json (GitHub Pages)
```

## TODO

### Integrar convocações e atas ao pipeline de dados

Os 97 arquivos em `convocacoes_atas/` já foram baixados do portal mas ainda não estão integrados ao `data.json` nem à visualização.

**Cadeia de correlação entre as 3 páginas do portal:**
```
Convocação (Edital) → Audiência Pública (Ata) → Plenária (Ata) → Parecer CONCIDADE
```

#### 1. Parsear atas de audiências públicas
- Extrair de cada ata: data, projeto discutido, participantes presentes, cidadãos presentes, resumo das deliberações
- As atas de 2025 são PDFs e já nomeiam o empreendimento (ex: `Ata_5a_Audiencia_Publica_19-08-2025_Mapesul.pdf`)
- As atas de 2024 são DOCX — precisam de `python-docx` ou conversão para texto

#### 2. Parsear atas de reuniões/plenárias
- Extrair: data, tipo (ordinária/extraordinária), pauta, votações, resultado (unanimidade/maioria)
- Vincular cada votação ao projeto correspondente

#### 3. Vincular convocações (editais) aos projetos
- Cada edital de convocação referencia um nº de protocolo ou projeto
- Adicionar `url_convocacao` e `url_ata` ao registro de cada projeto em `data.json`

#### 4. Novas visualizações no `index.html`
- **Links de download** nas cards e timeline: ata da audiência pública + ata da plenária por projeto
- **Seção "Atividade do Conselho"**: calendário ou gráfico de frequência de reuniões ao longo do tempo
- **Participação cidadã**: nº de presentes por audiência pública (extraído das atas)
- **Detalhes de votação**: mostrar resultado da votação (unanimidade/maioria/contra) por projeto

#### 5. Dados faltantes
- 2 atas de 2023 (4ª e 5ª reunião ordinária) falharam no download — aparentam estar corrompidas no servidor
- Atas de 2020 são somente 2 arquivos (posse + 1ª reunião) — dados históricos limitados
