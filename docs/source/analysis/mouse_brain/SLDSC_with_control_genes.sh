#!/bin/bash  
source ~/.bashrc
conda activate ldsc
cd /import/home2/share/yqzeng/MacSGP

size=${1:-450}

LDSC_DIR=/import/home/share/zw/pql/methods/LDSC # keep
LDSC_DATA_DIR=/import/home/share/zw/data/LDSC # keep
SUMSTATS_DIR=/import/home2/share/yqzeng/MacSGP/data/sumstats_LDSC
SVG_RESULT_DIR=/import/home2/share/yqzeng/MacSGP/results/Mouth_brain_visium/MacSGP/visium_1/enrichment_final/top${size} # own path
SAVE_DIR=/import/home2/share/yqzeng/MacSGP/results/Mouth_brain_visium/MacSGP/visium_1/enrichment_final/top${size}/SLDSC # own path
mkdir -p ${SAVE_DIR}/SLDSC_control

celltype_seq=(Ext_Amy_2 Ext_Hpc_CA1 Ext_Hpc_CA3 Ext_Hpc_DG1 Ext_L23 Ext_L5_2 Ext_Med Ext_Pir Ext_Thal_1 Ext_Thal_2 Inh_1 Inh_4)

# Create a file that lists the annotation files for each cell type
# Use genes expressed in brain as control genes
> ${SAVE_DIR}/SLDSC_control/mouse_brain.ldcts
for celltype in ${celltype_seq[@]}; do
    echo -e "${celltype}\t${SAVE_DIR}/LD_scores/${celltype}/sig_genes.,${SAVE_DIR}/LD_scores/brain/brain." >> \
    ${SAVE_DIR}/SLDSC_control/mouse_brain.ldcts
done


trait_seq=(ADHD AN ALS BMD Angina ANX BW BMI CAD CUD Depression Epilepsy \
           EDS FRS Height IQ Memory Migraine NEU \
           NCF PANIC PTSD Religious RT SD T2D WHR OCS CKD)

# trait_seq=(DBP Epilepsy HDL HC Insomnia LDL SBP Thyroiditis)
for trait in ${trait_seq[@]}; do
    # Run the regression for each trait
    python ${LDSC_DIR}/ldsc.py \
	    --h2-cts ${SUMSTATS_DIR}/${trait}.sumstats.gz \
        --ref-ld-chr ${LDSC_DATA_DIR}/1000G_Phase3_baselineLD_v2.2_ldscores/baselineLD. \
        --ref-ld-chr-cts ${SAVE_DIR}/SLDSC_control/mouse_brain.ldcts \
        --w-ld-chr ${LDSC_DATA_DIR}/weights_hm3_no_hla/weights. \
        --out ${SAVE_DIR}/SLDSC_control/${trait}
done

