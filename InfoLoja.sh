#!/usr/bin/env bash

cd "HARDWARE"
tmp=$(mktemp -d)
ls > $tmp/setores.txt
nSetores=$(wc -l "$tmp/setores.txt" | tr ' ' '&' | cut '-d&' -f1)
cont=1
while [[ "$cont" -le "$nSetores" ]]; do
# while [[ "$cont" -le 1 ]]; do
  nomeSetor=$(cat "$tmp/setores.txt" | head -n "$cont" | tail -n 1)
  cd "$nomeSetor"
  ls > "$tmp"/"$nomeSetor".txt
  totalEquipe=$(wc -l "$tmp/$nomeSetor.txt"| tr ' ' '&' | cut '-d&' -f1)
  echo "Total de máquinas no setor $nomeSetor: $totalEquipe"
  cont2=1
  while [[ "$cont2" -le "$totalEquipe" ]]; do
  #while [[ "$cont2" -le 1 ]]; do
    funcionarioMaquina=$(cat "$tmp/$nomeSetor.txt" | head -n "$cont2" | tail -n 1 | cut '-d.' -f1)
    nomePC=$(grep -a 'Computer Name' "$funcionarioMaquina.LOG")
    nomeFuncionario=$(grep -a 'Computer Description' "$funcionarioMaquina.LOG")
    rede=$(grep -a -E 'Network Card|MAC Address' "$funcionarioMaquina.LOG")
    SO=$(grep -a 'Operating System:' "$funcionarioMaquina.LOG")
    nSerieMB=$(grep -a -E 'Mainboard Serial Number:|Motherboard Model:' "$funcionarioMaquina.LOG")
    modeloChipset=$(grep -a -E 'Computer Brand Name:|Motherboard Chipset:' "$funcionarioMaquina.LOG")
    processador=$(grep -a 'Processor Name' "$funcionarioMaquina.LOG")
    RAM=$(grep -a -A7 'Row:' "$funcionarioMaquina.LOG")
    ramTotal=$(grep -a 'Total Memory Size:' "$funcionarioMaquina.LOG")
    ROM=$(grep -a 'Drive Model:' "$funcionarioMaquina.LOG")
    ROM+=$(grep -a 'Drive Capacity:' "$funcionarioMaquina.LOG")
    ROM+=$(grep -a 'Media Rotation Rate:' "$funcionarioMaquina.LOG")
cat << EOF >> "$nomeSetor.txt"
  Setor: $nomeSetor
  $nomePC
  $nomeFuncionario
  ------------------------------------------------------------
  Placa(s) de Rede e MAC
  $rede
  ------------------------------------------------------------
  Sistema Operacional
  $SO
  ------------------------------------------------------------
  Número de série note e modelo da placa mãe
  $nSerieMB
  ------------------------------------------------------------
  Modelo Note e Chiptset
  $modeloChipset
  ------------------------------------------------------------
  Processoador
  $processador
  ------------------------------------------------------------
  Memória(s)
  $ramTotal
  $RAM
  ------------------------------------------------------------
  HD(s). OBS: Vai aparecer tbm os pendrives ou drives opticos
  $ROM

  ###########################################################################################################################
EOF
    ((cont2++))
  done
  echo '---------'
  cd ..
  ((cont++))
done
exit 0
