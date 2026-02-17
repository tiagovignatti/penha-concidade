#!/bin/bash
# Download all EIV/RIV - CONCIDADE files from Penha municipality portal
# Source: https://penha.atende.net/cidadao/pagina/publicacoes-eivriv-concidade
#
# The download URL pattern was reverse-engineered from the portal's JS:
#   download_arquivo(hash) -> POST to atende.php?rot=1&aca=571&processo=downloadFile&file=HASH&sistema=WPO&classe=UploadMidia
# A simple GET also works for public files.
#
# Usage: bash download_all.sh [DEST_DIR]

BASE_URL="https://penha.atende.net/atende.php?rot=1&aca=571&ajax=t&processo=downloadFile&sistema=WPO&classe=UploadMidia"
DEST="${1:-$(dirname "$0")/..}"

download_file() {
  local dir="$1"
  local hash="$2"
  local name="$3"

  mkdir -p "$DEST/$dir"
  local filepath="$DEST/$dir/$name.pdf"

  if [ -f "$filepath" ]; then
    echo "  SKIP (exists): $name.pdf"
    return
  fi

  echo "  Downloading: $name.pdf"
  curl -s -L -o "$filepath" "${BASE_URL}&file=${hash}"

  if [ $? -eq 0 ] && [ -s "$filepath" ]; then
    local size=$(du -h "$filepath" | cut -f1)
    echo "    OK ($size)"
  else
    echo "    FAILED"
    rm -f "$filepath"
  fi
}

# Group 1: 1DOC 1.340-2025 - Mapesul Emp. Imob. Ltda
echo "=== 1DOC 1.340-2025 - Mapesul Emp. Imob. Ltda ==="
DIR="01-1DOC_1.340-2025_Mapesul"
download_file "$DIR" "E509707B040CDA5204850BE660FF0EA880F0B755" "Parecer_RIV_1DOC_1.340_2025_Mapesul_Emp_Imob_Ltda"

# Group 2: 1DOC 2.509-2025 - Parkside SPE Ltda
echo "=== 1DOC 2.509-2025 - Parkside SPE Ltda ==="
DIR="02-1DOC_2.509-2025_Parkside_SPE"
download_file "$DIR" "9FADFA2C059B95EC4E9D634BFA7538A790497C76" "Parecer_RIV_1DOC_2.509_2025_Parkside_SPE_Ltda"
download_file "$DIR" "DCE7C47678E8D9E23969FE42FEA772378AD8975F" "1o_Termo_Publicacao_Complementar_RIV_1DOC_2.509-2025_Parkside"
download_file "$DIR" "7B74F7DDE3BCD9ADBBF8AFB8000460A45F8CF783" "Parecer_CONCIDADE_03-2025_Parkside_SPE"

# Group 3: 1DOC 4.673-2024 - Anderson F. C. Teixeira
echo "=== 1DOC 4.673-2024 - Anderson F. C. Teixeira ==="
DIR="03-1DOC_4.673-2024_Anderson_Teixeira"
download_file "$DIR" "042523339751C84E4D75B343DE9A21BE14CC383D" "Parecer_Concidade_1DOC_4.673-2024_Anderson_F_C_Teixeira"

# Group 4: 1DOC 7.684-2024 - HR Aluguel de Imóveis Próprios Ltda
echo "=== 1DOC 7.684-2024 - HR Aluguel de Imóveis Próprios Ltda ==="
DIR="04-1DOC_7.684-2024_HR_Aluguel_Imoveis"
download_file "$DIR" "4F1360F098B3C91C1BF91910AD16902EF6E099CC" "EIV_PENHA_1DOC_7.684-2024_HR_Aluguel_Imoveis_Proprios_Ltda"
download_file "$DIR" "EEA35E58175262BAAD08081921577A3E06B0ECB8" "1o_Termo_Publicacao_Complementar_RIV_1DOC_7.684-2024"
download_file "$DIR" "5406681C4B322CF516F54E912956A274A6EBAB49" "2o_Termo_Publicacao_Comp_RIV_Declaracao_DOM-SC"
download_file "$DIR" "F9D217F301CFB5DEB8F0D9A26E6FF8644DB4CE86" "Parecer_CONCIDADE_04-2025_HR_Aluguel_Imoveis"

# Group 5: 1DOC 9.235-2024 - Empreendimento 1SPE Ltda
echo "=== 1DOC 9.235-2024 - Empreendimento 1SPE Ltda ==="
DIR="05-1DOC_9.235-2024_Empreendimento_1SPE"
download_file "$DIR" "69E12611F0226CEACF3E82A0E1060763D5C05590" "EIV_Halsten_Penha_Rev_30_08_24_1DOC_9.235-2024_Empreendimento_1SPE"

# Group 6: 1DOC 9.541-2024 - G10 Empreendimentos Ltda
echo "=== 1DOC 9.541-2024 - G10 Empreendimentos Ltda ==="
DIR="06-1DOC_9.541-2024_G10_Empreendimentos"
download_file "$DIR" "8DA2A31BB2FEC8C216C5A25A76D63DA135CE8B36" "EIV_Ocean_Acqua_View_Penha_GE10_1DOC_9.541-2024"
download_file "$DIR" "9F2A4D200E3B93A5F766DC8C3009DD36FC0E6998" "1o_Termo_Publicacao_Comp_RIV_Prop_9.541-2024"
download_file "$DIR" "F69F46416F69E63D880338503A0C14FB6F37EFE6" "Parecer_CONCIDADE_05-2025_GE10_Empreendimento"

# Group 7: 1DOC 10.835-2024 - Engeoffice Const. Civil Ltda
echo "=== 1DOC 10.835-2024 - Engeoffice Const. Civil Ltda ==="
DIR="07-1DOC_10.835-2024_Engeoffice"
download_file "$DIR" "578E82ADC96E7C187420CD810DBA7FB67F4782D9" "EIV_BLANC_rev_01_1DOC_10.835"
download_file "$DIR" "8EC3505A5695EC8181DC2482CE2E6F8F4CC3E05D" "1o_Termo_Publ_Comp_Prot_10.835-2024_23-07-2025"
download_file "$DIR" "C2F9EC25C766CAAADD9E9E7E7DB3D6C4B4B32BE8" "Parecer_CONCIDADE_01-2025_Engeoffice_Construcao_Civil"

# Group 8: 1DOC 11.021-2024 - Casa Prime Dreams SPE Ltda
echo "=== 1DOC 11.021-2024 - Casa Prime Dreams SPE Ltda ==="
DIR="08-1DOC_11.021-2024_Casa_Prime_Dreams"
download_file "$DIR" "BF6084FC1D64D2105FB08C038AB17B788F4E87F6" "EIV_California_1DOC_11.021-2024_Casa_Prime_Dreams_SPE"
download_file "$DIR" "E9C8C778CCB9DC2FD047CE9CD250AAC9122B1E9D" "1o_Termo_Pub_Comp_Riv_Prot_11.021-2024_DOM-SC_RIV_complem"
download_file "$DIR" "222E5AE8698D3D4560D04F8D9538D75EDEB132BA" "Parecer_CONCIDADE_02-2025_Casa_Prime_Dreams_SPE"

# Group 9: 1DOC 2.269-2025 - Rogga S.A. Const. e Inc
echo "=== 1DOC 2.269-2025 - Rogga S.A. Const. e Inc ==="
DIR="09-1DOC_2.269-2025_Rogga_SA"
download_file "$DIR" "5BD8B8D75B848DFB4E5E8AB3AD301712F548EECE" "1DOC_2.269-2025_Rogga_SA_Const_Inc_23-07-2025"
download_file "$DIR" "F9D822330B2E877DD575F3435B8EB88FDA239A48" "1o_Termo_Publicacao_Comp_EIV-RIV_Prot_2.269-2025_1DOC"
download_file "$DIR" "22FA6CE6257E21126C3E62629C797D3462953692" "Parecer_CONCIDADE_06-2025_Rogga_SA_Construtora_Incorporadora"

# Group 10: 1DOC 5.539-2025 - RT 49 Emp. Imob. SPE Ltda
echo "=== 1DOC 5.539-2025 - RT 49 Emp. Imob. SPE Ltda ==="
DIR="10-1DOC_5.539-2025_RT49_Emp_Imob"
download_file "$DIR" "28EB5A45E6497C99F21BD470B9244D0311D78B00" "1DOC_5.539-2025_RT_49_Emp_Imob_SPE_23-07-2025"
download_file "$DIR" "D7B6B99DD041DC4A9610DDA2FD5B3BE3BEF63CB6" "1o_Termo_Publicacao_Complementar_RIV_Prot_5.539-2025_1DOC_Resp_EIV"
download_file "$DIR" "84F617F174983B4B1B1C94B967872A688A79D1AA" "Parecer_CONCIDADE_08-2025_RT49_Empreendimento_Imobiliario_SPE"

# Group 11: 1DOC-4.179-2025 - Vetter Empreendimento 32 LTDA
echo "=== 1DOC-4.179-2025 - Vetter Empreendimento 32 LTDA ==="
DIR="11-1DOC_4.179-2025_Vetter_Emp_32"
download_file "$DIR" "952205F99FF7EE550848767A1D34D1C94F1AC37E" "EIV_Vetter_Emp32_Ltda_Parecer_Tec_extrato_DOM-SC"
download_file "$DIR" "976AAE575AEB66C01E5C0FF3B9FB7768409AD885" "1o_Termo_Publicacao_Complementar_RIV_Prot_4.170-2025_1DOC"
download_file "$DIR" "916814299E29729733016107C75C40C5F961929B" "Parecer_CONCIDADE_07-2025_Vetter_Empreendimento_32"

# Group 12: 1DOC-11.194-2024-Engeoffice Construção Civil Ltda
echo "=== 1DOC-11.194-2024 - Engeoffice Construção Civil Ltda ==="
DIR="12-1DOC_11.194-2024_Engeoffice_Ed_Vison"
download_file "$DIR" "ECF5DB679F2792EEC0A4DD9EF2A78ADC0090AAF7" "EIV-RIV_Engeoffice_Ed_Vison"

echo ""
echo "=== DOWNLOAD COMPLETE ==="
echo ""
total=$(find "$DEST" -name "*.pdf" | wc -l)
total_size=$(du -sh "$DEST" | cut -f1)
echo "Total: $total PDF files ($total_size)"
