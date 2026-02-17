#!/bin/bash
# Download all Convocações and Atas from CONCIDADE Penha portal
# Source: https://penha.atende.net/cidadao/pagina/convocacoes-concidade
#         https://penha.atende.net/cidadao/pagina/atas-concidade
#
# Usage: bash download_convocacoes_atas.sh [DEST_DIR]

BASE_URL="https://penha.atende.net/atende.php?rot=1&aca=571&ajax=t&processo=downloadFile&sistema=WPO&classe=UploadMidia"
DEST="${1:-$(dirname "$0")/../convocacoes_atas}"

download_file() {
  local dir="$1"
  local hash="$2"
  local name="$3"
  local ext="$4"

  mkdir -p "$DEST/$dir"
  local filepath="$DEST/$dir/$name.$ext"

  if [ -f "$filepath" ]; then
    echo "  SKIP (exists): $name.$ext"
    return
  fi

  echo "  Downloading: $name.$ext"
  curl -s -L -o "$filepath" "${BASE_URL}&file=${hash}"

  if [ $? -eq 0 ] && [ -s "$filepath" ]; then
    local size=$(du -h "$filepath" | cut -f1)
    echo "    OK ($size)"
  else
    echo "    FAILED"
    rm -f "$filepath"
  fi
}

# ============================================================
# CONVOCAÇÕES
# ============================================================

# --- 2023 ---
echo "=== CONVOCAÇÕES 2023 ==="
DIR="convocacoes/2023"
download_file "$DIR" "616B0E63462E5650F22A22F071631A9E2E6DD4B2" "Convocacao_6a_Reuniao_Ordinaria_2023" "docx"

# --- 2024 ---
echo "=== CONVOCAÇÕES 2024 ==="
DIR="convocacoes/2024"
download_file "$DIR" "90C522E05AB132B910C836624E1FA6B662C61A2A" "Convocacao_1a_Conferencia_2024" "docx"
download_file "$DIR" "893B5AB6E7BFA0F5054CE288B583891EFDD6E8C7" "Convocacao_1a_Pre_Conferencia_2024" "docx"
download_file "$DIR" "A08A55C7D05FB8BAF58269DC673CC16E6F2011E3" "Convocacao_2a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "8E559F8E787362071D391179B8ECEDE5819A9642" "Convocacao_2a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "BA36EE30976BD8188102AF2DD30A2FA2D2140093" "Convocacao_3a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "7F6043FC7E549E01BCD5C866C1F7E091D85896B0" "Convocacao_3a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "A40A6A29700195BF3BAFACF561F14150EE3BCF65" "Convocacao_4a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "616D1F8BBAD2AE1EF9CC22CFEC2AFD86FC237990" "Convocacao_4a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "1E436189EBF37848CFDD9D9C6DA403078210342D" "Convocacao_5a_Audiencia_Publica_2024_14-05" "docx"
download_file "$DIR" "383C5149B3D5A30399115C71FD94924B61B06CBC" "Convocacao_5a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "6E8A6761E9229E80DDF5984397722D0E2388F438" "Convocacao_5a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "2E976F64FA765FDD496F4979EED86FD3805647C7" "Convocacao_5a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "27435D1B326D1A9342B33B83E67B17C7A586F6DD" "Convocacao_6a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "FEE2FD94FE96D230C637F86C5142BD5A8299C579" "Convocacao_6a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "FC5FCBC5505C49700942D1A8D454B111CBB8C369" "Convocacao_6a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "5661E1D1568559AAD988B00F3E13050AF12E5F64" "Convocacao_7a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "C80C1B705E3567462011C53BF3839ABDCA8EB89B" "Convocacao_8a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "0E35201DFEFCD19668568590A1CD7B6B54F69283" "Convocacao_9a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "F5EFB7A12A26BB8FB8C885548183403C1AC0BE4A" "Convocacao_10a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "69F96758935CBB9D50D8AA96E179927CBAB282CF" "Convocacao_11a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "888F98802DC5505EB2C57004B6417A86A23BAE07" "Convocacao_12a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "A6A4BE92F4A582C39120DC2128872B2FBD6976A0" "Convocacao_13a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "B543A9A4D250254BC40270BBE3BE8BD9C7179C1A" "Convocacao_14a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "153C7B6D1167A4D2EE1A4249692B2A25CE2E7F78" "Convocacao_15a_Audiencia_Publica_2024" "docx"

# --- 2025 ---
echo "=== CONVOCAÇÕES 2025 ==="
DIR="convocacoes/2025"
download_file "$DIR" "AC749A23329DA6A53DC7CEBF7843FF1BE954C6C2" "Edital_001-2025_Convocacao_1a_Reuniao_Ordinaria" "pdf"
download_file "$DIR" "7B0F51F71E1D1FC4C231359AE9C56F268F78CFCA" "CONCIDADE_2025" "pdf"
download_file "$DIR" "206E28E61E36D775C38B0C8D274A9F2C30B83C83" "Edital_003-2025_1a_Audiencia_Publica" "pdf"
download_file "$DIR" "4950C23939E51B8555CED077238134B343674635" "Edital_004-2025_2a_Audiencia_Publica" "pdf"
download_file "$DIR" "599E9736989DD8A2EA438699899D00389AAC9B3F" "Edital_005-2025_3a_Audiencia_Publica" "pdf"
download_file "$DIR" "DCFBF44A916E54564CB4DF1DA39C90058B8BDD76" "Edital_006-2025_4a_Audiencia_Publica" "pdf"
download_file "$DIR" "C4B47C8B05F53BA89684E222CEE95E834E184120" "Edital_007-2025_5a_Audiencia_Publica" "pdf"
download_file "$DIR" "680A66F161689C05E96CD88F68AEAD6329C7F531" "Termo_Cancelamento_01-2025_Edital_004" "pdf"
download_file "$DIR" "6B3BB1849799A1B7069B7BC287A64DB431C0E1B3" "Edital_008-2025" "pdf"
download_file "$DIR" "BF3A67EC04200CE13E4715F285FE3167E1E1B083" "1o_Termo_Retificacao" "pdf"
download_file "$DIR" "5DE767AEE1F884A9F8E5C44FFBB35D8F55B64881" "Termo_Cancelamento_02-2025" "pdf"
download_file "$DIR" "64822071C8067B8F2A21692F173FCEA28FEA0C5E" "Termo_Cancelamento_03-2025" "pdf"
download_file "$DIR" "D089D46A9B5E4655E779E8666F200DCE890C58B5" "Termo_Cancelamento_04-2025" "pdf"
download_file "$DIR" "7FDEB26CDDE2C017C80E15E170AA6082381C3B8F" "Edital_009-2025_2a_Audiencia_Publica" "pdf"
download_file "$DIR" "346ECF2089D79679C98F380C3B7A6752CA28BC5A" "Edital_010-2025_3a_Audiencia_Publica" "pdf"
download_file "$DIR" "9BC6AC0E5A6473A4F0ECF9E4601402794BF984C2" "Edital_011-2025_4a_Audiencia_Publica" "pdf"
download_file "$DIR" "EA20433ECE2FF94DB2FC8C8D2F9930D8F984C317" "Edital_012-2025_5a_Audiencia_Publica" "pdf"
download_file "$DIR" "2EA1B096DA5A18B5F94012616603810E297FBF9F" "Edital_013-2025_6a_Audiencia_Publica" "pdf"
download_file "$DIR" "9BA52C1B75DC58BEF22876CBACE85A9B8E12853C" "Edital_014-2025_7a_Audiencia_Publica" "pdf"
download_file "$DIR" "6F084978F6CE02D377EB940B887EE5A152CD8E32" "Edital_015-2025_Extrato_DOM" "pdf"
download_file "$DIR" "CFA50080723D3D1F3A7E6E72FBB4FA2C7D578BBD" "Edital_016-2025_Convocacao_1a_Reuniao_Extraordinaria_15-08-2025" "pdf"
download_file "$DIR" "553DE9EFA4732F4C36B3BD532E18B4F4E1D07262" "Termo_Cancelamento_05-2025_Edital_014" "pdf"
download_file "$DIR" "2A6CF491F77C651F98F9D5ED1354E5D6791413A7" "Edital_017-2025_Publicacao_RIV-EIV_Vetter32" "pdf"
download_file "$DIR" "5901F2BC148C2118DC47EB61DDD37AEF69607BB0" "Edital_018-2025_Convocacao_3a_Reuniao_Ordinaria_02-SET-2025" "pdf"
download_file "$DIR" "28A5D3E35EC0B8E193959DC543AC51C6E6C1187B" "Edital_019-2025_7a_Audiencia_Publica_Rogga" "pdf"
download_file "$DIR" "772597A1F3501DCC23A85EC8A65E459A47517254" "Edital_020-2025_8a_Audiencia_Publica_RT49" "pdf"
download_file "$DIR" "98860A8C629CAF543A37B47EBA76ABD1E709D3F5" "Edital_021-2025_9a_Audiencia_Publica_Vetter" "pdf"
download_file "$DIR" "17356D5EA38A5DB00CC6BDE5398D41CDDAE55603" "Edital_022-2025_Publicacao_RIV-EIV_Engeoffice_Vision" "pdf"
download_file "$DIR" "BF36ADB562E610DE432E0BC386E57404B82E4410" "Edital_023-2025_Convocacao_2a_Reuniao_Extraordinaria_07-10-2025" "pdf"
download_file "$DIR" "B29E8890E6A8F5705CCE7A0713C6DEDD82CB1A26" "Edital_024-2025_Convocacao_4a_Reuniao_Ordinaria_04-NOV-2025" "pdf"
download_file "$DIR" "BB3AE7B3C58363F82F05E879C3F277F4D566E4C5" "Edital_025-2025_10a_Audiencia_Publica_Engeoffice" "pdf"
download_file "$DIR" "3F247C3061F9E1720E466BC6F08140CCBB3DF21C" "TSAP_01-2025_Engeoffice_Prot_11194" "pdf"
download_file "$DIR" "CC215F890C52DF17265F3EC8329C40DFB7B4BC71" "Edital_026-2025_10a_Audiencia_Publica_Engeoffice_Reconvocacao" "pdf"
download_file "$DIR" "D0FB54C5C5F1233382500F767816FA16B47EC3AC" "Retificacao_Edital_026-2025_Engeoffice" "pdf"
download_file "$DIR" "9D0E8799875563FECC8113D95D17345A3C31D8E9" "Termo_Cancelamento_06-2025_Edital_026" "pdf"

# --- 2026 ---
echo "=== CONVOCAÇÕES 2026 ==="
DIR="convocacoes/2026"
download_file "$DIR" "9D20DBC61C97E971D8187EFC3EB87678E14572AC" "Edital_01-2026_Convocacao_1a_Reuniao_Ordinaria_19jan2026" "pdf"
download_file "$DIR" "92F3C6EFE4E809B6DB7EF018903EB3068796442E" "Edital_02-2026_1a_Audiencia_Publica_Engeoffice" "pdf"
download_file "$DIR" "F4C48C7A9E2B348DD548384185B2E2155E2588B9" "Edital_03-2026_1a_Pre_Conferencia_02-02-2026" "pdf"
download_file "$DIR" "C799281A9AB1E20D595E1DE0ABA9C332445CD9F2" "Edital_04-2026_1a_Conferencia_05-03-2026" "pdf"

# ============================================================
# ATAS
# ============================================================

# --- 2020 ---
echo "=== ATAS 2020 ==="
DIR="atas/2020"
download_file "$DIR" "9BA8F65AA4BAD9BF780E80B5B85099670A79C106" "Ata_7a_Audiencia_Publica_2020" "pdf"

# --- 2023 ---
echo "=== ATAS 2023 ==="
DIR="atas/2023"
download_file "$DIR" "FC9C6A277BC41E0F4D1BA801BD4FD85AA331624C" "Ata_4a_Reuniao_Ordinaria_2023" "docx"
download_file "$DIR" "1447CEEA084AE06D4D41629CAE1FCB78AB041C66" "Ata_5a_Reuniao_Ordinaria_2023" "docx"
download_file "$DIR" "42B2549A08DD415481F6A7A9A375DF3AB1C6F63D" "Ata_6a_Reuniao_Ordinaria_2023" "odt"

# --- 2024 ---
echo "=== ATAS 2024 ==="
DIR="atas/2024"
download_file "$DIR" "38BE90388A5E0DB1E445C34D8C91265F49AF230A" "Ata_1a_Reuniao_Ordinaria_2024" "odt"
download_file "$DIR" "E431B3627016D934E16DEF30B45262441B919C8A" "Ata_2a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "50EB91FF7C24EA208E8AA40FC5D03FEB2E693848" "Ata_3a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "2E640CAB2B87957A4A472DBBB7DED51B541A8B77" "Ata_3a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "4643C5EC61AC03957E7F7632352F2E53265235A0" "Ata_4a_Reuniao_Extraordinaria_2024" "docx"
download_file "$DIR" "20C328AABEC9979A72C80D31292285004E9E56FE" "Ata_5a_Reuniao_Ordinaria_2024" "docx"
download_file "$DIR" "30EED4A8F57D416677B13E3C51D4C996CDF880F6" "Ata_1a_Conferencia_2024" "docx"
download_file "$DIR" "3CEDC8A869C7A66B60C66160D63AC047758CF24B" "Ata_5a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "74C961C3F15C02D8B2DD30335C65BB94F3C12060" "Ata_6a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "6A26DBFA78ED72D57A85F5EF30D25C81D6EEEE8C" "Ata_7a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "DDB3F1F77A5F63670F620C1F1A40E07A07642726" "Ata_10a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "13C0C712271D6BFC69B60AF761DA3DCDEAF26348" "Ata_11a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "299255E8A4CA98061AE7277C536DE20F044148B5" "Ata_12a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "A6B07DFCF7D82A0107025969ED8B87D88971551E" "Ata_13a_Audiencia_Publica_2024" "docx"
download_file "$DIR" "5F0A72EA803B4EB86105FC8B3FCC3201952C68E2" "Ata_5a_Reuniao_Extraordinaria_2024" "docx"

# --- 2025 ---
echo "=== ATAS 2025 ==="
DIR="atas/2025"
download_file "$DIR" "B65B25B56EFA6248ED1E6A9C890F090B7D6BC32F" "Ata_Posse_CONCIDADE_2025" "pdf"
download_file "$DIR" "8CF499763E0C003959562550E2A5428208E7E0CE" "Ata_1a_Reuniao_Ordinaria_06-05-2025" "pdf"
download_file "$DIR" "EBDB8FB0253A19BEB51B13933924012EFC07616E" "Ata_1a_Audiencia_Publica_18-06-2025_Engeoffice" "pdf"
download_file "$DIR" "68B3FE82118F5A2C2E8A12B213F3C5BDCF883478" "Ata_2a_Reuniao_Ordinaria_01-07-2025" "pdf"
download_file "$DIR" "AA11D4E7F48B2E47935F23D7E94BCFB2DA813959" "Ata_1a_Reuniao_Extraordinaria_15-08-2025" "pdf"
download_file "$DIR" "47B7F2633488D02AF6BF97993706EE4F6DCE83CB" "Ata_3a_Reuniao_Ordinaria_02-09-2025" "pdf"
download_file "$DIR" "0664303391F4B22112A659E0A9D1CB00CBEFB813" "Ata_2a_Audiencia_Publica_31-07-2025_Casa_Prime_Dreams" "pdf"
download_file "$DIR" "338798CF6E79C076B782C16707FC0A088FFBFA81" "Ata_3a_Audiencia_Publica_12-08-2025_HR_Aluguel" "pdf"
download_file "$DIR" "527CCECDB6366670CCF91D7670EB094624566B91" "Ata_4a_Audiencia_Publica_13-08-2025_GE10" "pdf"
download_file "$DIR" "E3BA6F7BF8104DD3AAABA2AC11356E78BC972612" "Ata_5a_Audiencia_Publica_19-08-2025_Mapesul" "pdf"
download_file "$DIR" "03C76B670C353AB58E9CC225E655126D95344341" "Ata_6a_Audiencia_Publica_21-08-2025_Parkside" "pdf"
download_file "$DIR" "0C8B8F4492C5D9873352078CA0D431CDF11DF5B0" "Ata_7a_Audiencia_Publica_09-09-2025_Rogga" "pdf"
download_file "$DIR" "05B2B3736AF46DDC0085A91BFCCDA4A894231C9A" "Ata_8a_Audiencia_Publica_11-09-2025_RT49" "pdf"
download_file "$DIR" "7906D7B3C7B0C136286B154F7DCF83FD50DE30B4" "Ata_9a_Audiencia_Publica_25-09-2025_Vetter" "pdf"
download_file "$DIR" "AA17D68240E514B2C9A9202FE795B5C96C66CC04" "Ata_2a_Reuniao_Extraordinaria_07-10-2025" "pdf"
download_file "$DIR" "563947B14991D01D44094AD2014E073BB194B0BB" "Ata_4a_Reuniao_Ordinaria" "pdf"

echo ""
echo "=== DOWNLOAD COMPLETE ==="
echo ""
total=$(find "$DEST" -type f | wc -l)
total_size=$(du -sh "$DEST" | cut -f1)
echo "Total: $total files ($total_size)"
