#!/bin/bash
source ~/.bashrc
set -e

SIZE=${1:-450}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "========================================"
echo " MacSGP S-LDSC Pipeline  (size=$SIZE)"
echo "========================================"

echo "[Step 1/3] Extracting cell-type-specific genes..."
conda activate factor
python "${SCRIPT_DIR}/MacSGP_ct_genes.py" "$SIZE"
echo "[Step 1/3] Done."

echo "[Step 2/3] Computing LD scores for all chromosomes..."
conda activate ldsc
bash "${SCRIPT_DIR}/SLDSC_compute_LD_scores.sh" "$SIZE"
echo "[Step 2/3] Done."

echo "[Step 3/3] Running S-LDSC regression..."
bash "${SCRIPT_DIR}/SLDSC_with_control_genes.sh" "$SIZE"
echo "[Step 3/3] Done."

echo "========================================"
echo " Pipeline finished. size=$SIZE"
echo "========================================"
