#!/usr/bin/env python3
"""Parse Penha CONCIDADE EIV/RIV PDFs into structured JSON."""

import json
import os
import re
import subprocess
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EMPREENDIMENTOS_DIR = os.path.join(BASE_DIR, "empreendimentos")
OUT_PATH = os.path.join(BASE_DIR, "docs", "data.json")

# Map project dirs to their key PDF files and metadata
DOWNLOAD_BASE = "https://penha.atende.net/atende.php?rot=1&aca=571&ajax=t&processo=downloadFile&sistema=WPO&classe=UploadMidia&file="

PROJECTS = [
    {
        "dir": "01-1DOC_1.340-2025_Mapesul",
        "parecer_tecnico": "Parecer_RIV_1DOC_1.340_2025_Mapesul_Emp_Imob_Ltda.pdf",
        "parecer_concidade": None,
        "protocolo": "1DOC 1.340/2025",
        "eiv_hash": "E509707B040CDA5204850BE660FF0EA880F0B755",
    },
    {
        "dir": "02-1DOC_2.509-2025_Parkside_SPE",
        "parecer_tecnico": "Parecer_RIV_1DOC_2.509_2025_Parkside_SPE_Ltda.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_03-2025_Parkside_SPE.pdf",
        "protocolo": "1DOC 2.509/2025",
        "eiv_hash": "9FADFA2C059B95EC4E9D634BFA7538A790497C76",
    },
    {
        "dir": "03-1DOC_4.673-2024_Anderson_Teixeira",
        "parecer_tecnico": None,
        "parecer_concidade": "Parecer_Concidade_1DOC_4.673-2024_Anderson_F_C_Teixeira.pdf",
        "protocolo": "1DOC 4.673/2024",
        "categoria": "certidao_uso_solo",
        "eiv_hash": "042523339751C84E4D75B343DE9A21BE14CC383D",
    },
    {
        "dir": "04-1DOC_7.684-2024_HR_Aluguel_Imoveis",
        "parecer_tecnico": "EIV_PENHA_1DOC_7.684-2024_HR_Aluguel_Imoveis_Proprios_Ltda.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_04-2025_HR_Aluguel_Imoveis.pdf",
        "protocolo": "1DOC 7.684/2024",
        "eiv_hash": "4F1360F098B3C91C1BF91910AD16902EF6E099CC",
    },
    {
        "dir": "05-1DOC_9.235-2024_Empreendimento_1SPE",
        "parecer_tecnico": "EIV_Halsten_Penha_Rev_30_08_24_1DOC_9.235-2024_Empreendimento_1SPE.pdf",
        "parecer_concidade": None,
        "protocolo": "1DOC 9.235/2024",
        "eiv_hash": "69E12611F0226CEACF3E82A0E1060763D5C05590",
    },
    {
        "dir": "06-1DOC_9.541-2024_G10_Empreendimentos",
        "parecer_tecnico": "EIV_Ocean_Acqua_View_Penha_GE10_1DOC_9.541-2024.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_05-2025_GE10_Empreendimento.pdf",
        "protocolo": "1DOC 9.541/2024",
        "eiv_hash": "8DA2A31BB2FEC8C216C5A25A76D63DA135CE8B36",
    },
    {
        "dir": "07-1DOC_10.835-2024_Engeoffice",
        "parecer_tecnico": "EIV_BLANC_rev_01_1DOC_10.835.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_01-2025_Engeoffice_Construcao_Civil.pdf",
        "protocolo": "1DOC 10.835/2024",
        "eiv_hash": "578E82ADC96E7C187420CD810DBA7FB67F4782D9",
    },
    {
        "dir": "08-1DOC_11.021-2024_Casa_Prime_Dreams",
        "parecer_tecnico": "EIV_California_1DOC_11.021-2024_Casa_Prime_Dreams_SPE.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_02-2025_Casa_Prime_Dreams_SPE.pdf",
        "protocolo": "1DOC 11.021/2024",
        "eiv_hash": "BF6084FC1D64D2105FB08C038AB17B788F4E87F6",
    },
    {
        "dir": "09-1DOC_2.269-2025_Rogga_SA",
        "parecer_tecnico": "1DOC_2.269-2025_Rogga_SA_Const_Inc_23-07-2025.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_06-2025_Rogga_SA_Construtora_Incorporadora.pdf",
        "protocolo": "1DOC 2.269/2025",
        "eiv_hash": "5BD8B8D75B848DFB4E5E8AB3AD301712F548EECE",
    },
    {
        "dir": "10-1DOC_5.539-2025_RT49_Emp_Imob",
        "parecer_tecnico": "1DOC_5.539-2025_RT_49_Emp_Imob_SPE_23-07-2025.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_08-2025_RT49_Empreendimento_Imobiliario_SPE.pdf",
        "protocolo": "1DOC 5.539/2025",
        "eiv_hash": "28EB5A45E6497C99F21BD470B9244D0311D78B00",
    },
    {
        "dir": "11-1DOC_4.179-2025_Vetter_Emp_32",
        "parecer_tecnico": "EIV_Vetter_Emp32_Ltda_Parecer_Tec_extrato_DOM-SC.pdf",
        "parecer_concidade": "Parecer_CONCIDADE_07-2025_Vetter_Empreendimento_32.pdf",
        "protocolo": "1DOC 4.179/2025",
        "eiv_hash": "952205F99FF7EE550848767A1D34D1C94F1AC37E",
    },
    {
        "dir": "12-1DOC_11.194-2024_Engeoffice_Ed_Vison",
        "parecer_tecnico": "EIV-RIV_Engeoffice_Ed_Vison.pdf",
        "parecer_concidade": None,
        "protocolo": "1DOC 11.194/2024",
        "eiv_hash": "ECF5DB679F2792EEC0A4DD9EF2A78ADC0090AAF7",
    },
]


def pdf_to_text(path):
    """Extract text from PDF using pdftotext."""
    try:
        result = subprocess.run(
            ["pdftotext", path, "-"],
            capture_output=True, text=True, timeout=30
        )
        return result.stdout
    except Exception as e:
        print(f"  WARN: pdftotext failed for {path}: {e}", file=sys.stderr)
        return ""


def parse_br_float(s):
    """Parse Brazilian number format (2.264,32) to float."""
    if not s:
        return None
    s = s.strip().replace(".", "").replace(",", ".")
    try:
        return float(s)
    except ValueError:
        return None


def clean_str(s):
    """Remove stray newlines and collapse whitespace."""
    if not s:
        return s
    return re.sub(r'\s+', ' ', s).strip()


def extract_first(text, pattern, group=1, flags=re.IGNORECASE):
    """Extract first regex match from text."""
    m = re.search(pattern, text, flags)
    return clean_str(m.group(group)) if m else None


def parse_parecer_tecnico(text):
    """Parse the PARECER TÉCNICO section embedded in EIV/RIV PDFs."""
    # Find the PARECER TÉCNICO section (first ~2000 chars after header)
    pt_match = re.search(r'PARECER\s+T[EÉ]CNICO', text)
    if not pt_match:
        return {}
    section = text[pt_match.start():pt_match.start() + 4000]

    data = {}

    # Data do protocolo/reprotocolo do RIV
    data_proto = extract_first(
        section,
        r'DATA\s+DO\s+(?:RE)?PROTOCOLO\s+DO\s+RIV:\s*(.+?)(?:\n)',
    )
    # Handle dd/mm/yyyy format (project 12)
    if data_proto and re.match(r'\d{2}/\d{2}/\d{4}', data_proto):
        d, m, y = data_proto.split('/')
        meses = ['', 'janeiro','fevereiro','março','abril','maio','junho',
                 'julho','agosto','setembro','outubro','novembro','dezembro']
        data_proto = f"{int(d)} de {meses[int(m)]} de {y}"
    data["data_protocolo"] = data_proto

    # Requerente
    data["requerente"] = extract_first(section, r'REQUERENTE:\s*(.+?)(?:\n|CNPJ)')

    # CNPJ
    data["cnpj"] = extract_first(section, r'CNPJ\s*(?:Nº|N[°º])?\s*([0-9./-]+)')

    # Empreendimento name — may span multiple lines before "PARECER SOBRE"
    emp_match = re.search(r'EMPREENDIMENTO:\s*(.+?)PARECER\s+SOBRE', section, re.DOTALL | re.IGNORECASE)
    if emp_match:
        emp = clean_str(emp_match.group(1))
    else:
        emp = extract_first(section, r'EMPREENDIMENTO:\s*(.+?)(?:\n)')
    data["empreendimento"] = emp

    # Endereço
    addr = extract_first(section, r'Endere[çc]o:\s*(.+?)(?:\n)')
    data["endereco"] = addr

    # Bairro — try these in priority order:
    bairro = None
    # 1. Line after endereço with explicit "Bairro" or "Br." prefix
    bairro_match = re.search(r'Endere[çc]o:.*?\n\s*(?:Bairro|Br\.)\s*(.+)', section)
    if bairro_match:
        bairro = bairro_match.group(1).strip()
    # 2. Line after endereço (standalone neighborhood name, not starting with "Área")
    if not bairro:
        bairro_match = re.search(r'Endere[çc]o:.*?\n\s*([^\n]+)', section)
        if bairro_match:
            candidate = bairro_match.group(1).strip()
            if not re.match(r'[ÁA]rea', candidate):
                bairro = candidate
    # 3. "-- Br./Bairro" pattern within endereço line
    if not bairro:
        bairro = extract_first(section, r'Endere[çc]o:.*?--\s*(?:Br\.?\s*|Bairro\s*)?([A-Z].+)')
    # Clean up: remove "Área..." suffix, normalize "--" to " / "
    if bairro:
        bairro = re.sub(r'\s*[ÁA]rea.*$', '', bairro).strip()
        bairro = re.sub(r'\s*--\s*', ' / ', bairro).strip()

    data["bairro"] = bairro

    # Área do terreno
    area_terreno_str = extract_first(section, r'[AÁ]rea\s+(?:do\s+)?terreno:\s*([\d.,]+)\s*m')
    data["area_terreno_m2"] = parse_br_float(area_terreno_str)

    # Área construída
    area_constr_str = extract_first(
        section,
        r'[AÁ]rea\s+(?:Total\s+)?(?:Constru[ií]da|a\s+Construir)\s*[=:]\s*([\d.,]+)\s*m'
    )
    data["area_construida_m2"] = parse_br_float(area_constr_str)

    # Torres and pavimentos
    m_tp = re.search(r'(\d+)\s+torre[s]?\s+com\s+(\d+)\s+pavimento', section, re.IGNORECASE)
    if m_tp:
        data["torres"] = int(m_tp.group(1))
        data["pavimentos"] = int(m_tp.group(2))
    else:
        # "04 torres" alone (pavimentos missing from parecer)
        m_t = re.search(r'Empreendimento:\s*(\d+)\s+torre', section, re.IGNORECASE)
        data["torres"] = int(m_t.group(1)) if m_t else None
        data["pavimentos"] = None

    # Unidades habitacionais
    uh_str = extract_first(section, r'unidades?\s+(?:de\s+)?habita(?:cionai|cional)[es]*:\s*(\d+)', flags=re.IGNORECASE)
    if not uh_str:
        uh_str = extract_first(section, r'unidades?\s+residenciai[s]?:\s*(\d+)', flags=re.IGNORECASE)
    if not uh_str:
        uh_str = extract_first(section, r'(\d+)\s+unidades?\s+residenciai', flags=re.IGNORECASE)
    data["unid_habitacionais"] = int(uh_str) if uh_str else None

    # Unidades comerciais
    uc_str = extract_first(section, r'[Uu]nidades?\s+[Cc]omercia(?:is|l):\s*(\d+)')
    if not uc_str:
        uc_str = extract_first(section, r'[Ss]alas?\s+[Cc]omercia(?:is|l):\s*(\d+)')
    data["unid_comerciais"] = int(uc_str) if uc_str else None

    # Unidades de hospedagem
    hosp_str = extract_first(section, r'unidades?\s+de\s+hospedagem:\s*(\d+)', flags=re.IGNORECASE)
    if not hosp_str:
        hosp_str = extract_first(section, r'(\d+)\s+quartos', flags=re.IGNORECASE)
    data["unid_hospedagem"] = int(hosp_str) if hosp_str else None

    # Vagas de estacionamento — may have multiple lines (simples, duplas, carga, etc.)
    vagas_total_str = extract_first(
        section,
        r'(?:total\s+de\s+)?vagas\s+(?:de\s+)?(?:estacionamento|garagem):\s*(\d+)',
        flags=re.IGNORECASE
    )
    if vagas_total_str:
        data["vagas_estacionamento"] = int(vagas_total_str)
    else:
        # Try to sum all vagas lines
        vagas_block = re.findall(r'(?:vagas?|Ve[ií]culos?|Motos?|PNE|Idoso)\s*[=:]\s*(\d+)', section, re.IGNORECASE)
        if vagas_block:
            data["vagas_estacionamento"] = sum(int(v) for v in vagas_block)
        else:
            data["vagas_estacionamento"] = None

    # For projects with "simples" + "duplas" parking (e.g. Blanc, Vision)
    simples = extract_first(section, r'(\d+)\s+simples', flags=re.IGNORECASE)
    duplas = extract_first(section, r'(\d+)\s+duplas', flags=re.IGNORECASE)
    if simples and duplas:
        data["vagas_estacionamento"] = int(simples) + int(duplas) * 2

    # Tipo empreendimento — infer from keywords
    emp_name = (data.get("empreendimento") or "").upper()
    if "HOTEL" in emp_name or "HOSPEDAGEM" in emp_name or "HOTELEIRO" in emp_name:
        data["tipo"] = "hotel_comercial"
    elif "LOGÍSTICO" in emp_name or "LOG" in emp_name or "RODOVIÁRIO" in emp_name or "GALPÃO" in emp_name or "CARGA" in emp_name:
        data["tipo"] = "logistico_comercial"
    elif "COMERCIAL" in emp_name and "RESIDENCIAL" not in emp_name and "MULTIFAMILIAR" not in emp_name:
        data["tipo"] = "comercial"
    elif "MULTIFAMILIAR" in emp_name or "RESIDENCIAL" in emp_name:
        data["tipo"] = "residencial_multifamiliar"
    else:
        data["tipo"] = "residencial_multifamiliar"

    return data


def parse_parecer_concidade(text):
    """Parse a Parecer CONCIDADE PDF."""
    data = {}

    # Parecer nº
    data["parecer_num"] = extract_first(text, r'PARECER\s+N[ºo°]\s*([\d/]+(?:-?\d+)?)')

    # Audiência pública date
    ap = extract_first(
        text,
        r'[Aa]udi[eê]ncia\s+P[uú]blica.*?dia\s+(\d{1,2}\s+de\s*\n?\s*\w+\s+de\s*\n?\s*\d{4})',
        flags=re.IGNORECASE | re.DOTALL
    )
    data["data_audiencia_publica"] = ap

    # Edital convocação
    data["edital_convocacao"] = extract_first(text, r'Edital\s+de\s+Convoca[çc][ãa]o\s+n[ºo°]\s*([\d/]+-?\d+\s*[-–]\s*\w+)')

    # Edição DOM-SC
    data["edicao_dom_sc"] = extract_first(text, r'Edi[çc][ãa]o\s+n[ºo°]\s*(\d+)')

    # Reunião type and date
    reuniao = extract_first(text, r'(\d+[ªa°]\s+Reuni[ãa]o\s+(?:Ordin[áa]ria|Extraordin[áa]ria))\s+do\s+Conselho')
    data["reuniao"] = reuniao

    reuniao_date = extract_first(
        text,
        r'Reuni[ãa]o\s+(?:Ordin[áa]ria|Extraordin[áa]ria)\s+do\s+Conselho.*?realizada\s+em\s+(\d{1,2}\s+de\s*\n?\s*\w+\s+de\s+\d{4})',
        flags=re.IGNORECASE | re.DOTALL
    )
    data["data_reuniao"] = reuniao_date

    # Vote result — check the "Considerando" section (authoritative), not boilerplate
    considerandos = re.search(r'I\s*[–-]\s*DOS\s+CONSIDERANDOS(.+?)II\s*[–-]', text, re.DOTALL | re.IGNORECASE)
    vote_section = considerandos.group(1) if considerandos else text
    if re.search(r'por\s+unanimidade', vote_section, re.IGNORECASE):
        data["resultado_voto"] = "unanimidade"
    elif re.search(r'maioria\s+absoluta', vote_section, re.IGNORECASE):
        data["resultado_voto"] = "maioria absoluta"
    else:
        data["resultado_voto"] = None

    # Data assinatura (Penha (SC), DD de MM de YYYY at end of document)
    data["data_assinatura"] = extract_first(
        text,
        r'Penha\s*\(SC\)\s*,?\s*(\d{1,2}\s+de\s+\w+\s+de\s+\d{4})\s*\.?\s*\n'
    )

    return data


def main():
    results = []

    for i, proj in enumerate(PROJECTS, 1):
        print(f"[{i:02d}] Processing {proj['dir']}...")
        proj_dir = os.path.join(EMPREENDIMENTOS_DIR, proj["dir"])
        record = {
            "id": i,
            "protocolo": proj["protocolo"],
            "diretorio": proj["dir"],
            "categoria": proj.get("categoria", "empreendimento_impacto"),
            "url_eiv": DOWNLOAD_BASE + proj["eiv_hash"] if proj.get("eiv_hash") else None,
        }

        # Parse Parecer Técnico
        if proj["parecer_tecnico"]:
            pt_path = os.path.join(proj_dir, proj["parecer_tecnico"])
            pt_text = pdf_to_text(pt_path)
            pt_data = parse_parecer_tecnico(pt_text)
            record.update(pt_data)
        else:
            # Project 03 — manual data for certidão uso solo
            if proj.get("categoria") == "certidao_uso_solo":
                record.update({
                    "data_protocolo": None,
                    "requerente": "Anderson Francisco Costa Teixeira",
                    "cnpj": None,
                    "empreendimento": "Estação de Transbordo de Esgotos Domésticos",
                    "endereco": "Rua Dona Francisca, 119",
                    "bairro": "Santa Lídia",
                    "area_terreno_m2": None,
                    "area_construida_m2": None,
                    "torres": None,
                    "pavimentos": None,
                    "unid_habitacionais": None,
                    "unid_comerciais": None,
                    "unid_hospedagem": None,
                    "vagas_estacionamento": None,
                    "tipo": "certidao_uso_solo",
                })

        # Parse Parecer CONCIDADE
        if proj["parecer_concidade"]:
            pc_path = os.path.join(proj_dir, proj["parecer_concidade"])
            pc_text = pdf_to_text(pc_path)
            pc_data = parse_parecer_concidade(pc_text)
            record.update(pc_data)
        else:
            record.update({
                "parecer_num": None,
                "data_audiencia_publica": None,
                "edital_convocacao": None,
                "edicao_dom_sc": None,
                "reuniao": None,
                "data_reuniao": None,
                "resultado_voto": None,
                "data_assinatura": None,
            })

        results.append(record)

    # Write JSON
    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)

    print(f"\nWrote {len(results)} projects to {OUT_PATH}")

    # Summary
    total_hab = sum(r.get("unid_habitacionais") or 0 for r in results)
    total_area = sum(r.get("area_construida_m2") or 0 for r in results)
    total_vagas = sum(r.get("vagas_estacionamento") or 0 for r in results)
    print(f"  Unid. habitacionais: {total_hab}")
    print(f"  Área construída: {total_area:,.2f} m²")
    print(f"  Vagas: {total_vagas}")


if __name__ == "__main__":
    main()
