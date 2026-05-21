#!/bin/bash  
source ~/.bashrc
conda activate ldsc
cd /import/home2/share/yqzeng/MacSGP

size=${1:-450}

LDSC_DIR=/import/home/share/zw/pql/methods/LDSC # keep
LDSC_DATA_DIR=/import/home/share/zw/data/LDSC # keep
SUMSTATS_DIR=/import/home/share/zw/pql/data/sumstats_LDSC # own data
SVG_RESULT_DIR=/import/home2/share/yqzeng/MacSGP/results/Mouth_brain_visium/MacSGP/visium_1/enrichment_final/top${size} # own path
SAVE_DIR=/import/home2/share/yqzeng/MacSGP/results/Mouth_brain_visium/MacSGP/visium_1/enrichment_final/top${size}/SLDSC/LD_scores # own path
mkdir -p ${SAVE_DIR}

mkdir -p ${SAVE_DIR}/all
mkdir -p ${SAVE_DIR}/brain

celltype_seq=(Ext_Amy_2 Ext_Hpc_CA1 Ext_Hpc_CA3 Ext_Hpc_DG1 Ext_L23 Ext_L5_1 Ext_L5_2 Ext_Med Ext_Pir Ext_Thal_1 Ext_Thal_2 Inh_1 Inh_4 Oligo_2)
for celltype in ${celltype_seq[@]}; do
    mkdir -p ${SAVE_DIR}/${celltype}
done

for chromosome in {1..22}; do
    {
        # Create annotation file by mapping all genes measured in ST data to the genome
        if [ -f "${SAVE_DIR}/all/all.${chromosome}.annot.gz" ]; then
            echo "[SKIP] all annot chr${chromosome} already exists."
        else
            python ${LDSC_DIR}/make_annot.py \
                --gene-set-file ${SVG_RESULT_DIR}/all_genes.txt \
                --gene-coord-file ${LDSC_DATA_DIR}/gencode/gene_coord.txt \
                --windowsize 100000 \
                --bimfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome}.bim \
                --annot-file ${SAVE_DIR}/all/all.${chromosome}.annot.gz
        fi
        
        # Compute LD scores for all genes annotations
        if [ -f "${SAVE_DIR}/all/all.${chromosome}.l2.ldscore.gz" ]; then
            echo "[SKIP] all ldscore chr${chromosome} already exists."
        else
            python ${LDSC_DIR}/ldsc.py \
                --l2 \
                --bfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome} \
                --ld-wind-cm 1 \
                --annot ${SAVE_DIR}/all/all.${chromosome}.annot.gz \
                --thin-annot \
                --out ${SAVE_DIR}/all/all.${chromosome} \
                --print-snps ${LDSC_DATA_DIR}/hapmap3_snps/hm.${chromosome}.snp
        fi

        # Create annotation file by mapping brain genes to the genome
        if [ -f "${SAVE_DIR}/brain/brain.${chromosome}.annot.gz" ]; then
            echo "[SKIP] brain annot chr${chromosome} already exists."
        else
            python ${LDSC_DIR}/make_annot.py \
                --gene-set-file ${SVG_RESULT_DIR}/brain_genes.txt \
                --gene-coord-file ${LDSC_DATA_DIR}/gencode/gene_coord.txt \
            --windowsize 100000 \
            --bimfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome}.bim \
            --annot-file ${SAVE_DIR}/brain/brain.${chromosome}.annot.gz
        fi

        # Compute LD scores for brain genes annotations
        if [ -f "${SAVE_DIR}/brain/brain.${chromosome}.l2.ldscore.gz" ]; then
            echo "[SKIP] brain ldscore chr${chromosome} already exists."
        else
            python ${LDSC_DIR}/ldsc.py \
                --l2 \
                --bfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome} \
            --ld-wind-cm 1 \
            --annot ${SAVE_DIR}/brain/brain.${chromosome}.annot.gz \
            --thin-annot \
            --out ${SAVE_DIR}/brain/brain.${chromosome} \
            --print-snps ${LDSC_DATA_DIR}/hapmap3_snps/hm.${chromosome}.snp
        fi

        for celltype in ${celltype_seq[@]}; do
            # Create annotation file by mapping cell-type-specific SVGs to the genome
            if [ -f "${SAVE_DIR}/${celltype}/sig_genes.${chromosome}.annot.gz" ]; then
                echo "[SKIP] ${celltype} sig genes annot chr${chromosome} already exists."
            else
                python ${LDSC_DIR}/make_annot.py \
                    --gene-set-file ${SVG_RESULT_DIR}/${celltype}_sig_genes.txt \
                    --gene-coord-file ${LDSC_DATA_DIR}/gencode/gene_coord.txt \
                    --windowsize 100000 \
                    --bimfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome}.bim \
                    --annot-file ${SAVE_DIR}/${celltype}/sig_genes.${chromosome}.annot.gz
            fi

            # Compute LD scores for annotations
            if [ -f "${SAVE_DIR}/${celltype}/sig_genes.${chromosome}.l2.ldscore.gz" ]; then
                echo "[SKIP] ${celltype} sig genes ldscore chr${chromosome} already exists."
            else
                python ${LDSC_DIR}/ldsc.py \
                    --l2 \
                    --bfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome} \
		        --ld-wind-cm 1 \
		        --annot ${SAVE_DIR}/${celltype}/sig_genes.${chromosome}.annot.gz \
		        --thin-annot \
		        --out ${SAVE_DIR}/${celltype}/sig_genes.${chromosome} \
		        --print-snps ${LDSC_DATA_DIR}/hapmap3_snps/hm.${chromosome}.snp
            fi

            # Create annotation file for control genes
            if [ -f "${SAVE_DIR}/${celltype}/control.${chromosome}.annot.gz" ]; then
                echo "[SKIP] ${celltype} control genes annot chr${chromosome} already exists."
            else
                python ${LDSC_DIR}/make_annot.py \
                    --gene-set-file ${SVG_RESULT_DIR}/${celltype}_control_genes.txt \
                    --gene-coord-file ${LDSC_DATA_DIR}/gencode/gene_coord.txt \
                    --windowsize 100000 \
                    --bimfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome}.bim \
                    --annot-file ${SAVE_DIR}/${celltype}/control.${chromosome}.annot.gz
            fi

            # Compute LD scores for cell-type-specific control annotations
            if [ -f "${SAVE_DIR}/${celltype}/control.${chromosome}.l2.ldscore.gz" ]; then
                echo "[SKIP] ${celltype} control genes ldscore chr${chromosome} already exists."
            else
                python ${LDSC_DIR}/ldsc.py \
                    --l2 \
                    --bfile ${LDSC_DATA_DIR}/1000G_Phase3_EUR_plinkfiles/1000G.EUR.QC.${chromosome} \
                    --ld-wind-cm 1 \
                    --annot ${SAVE_DIR}/${celltype}/control.${chromosome}.annot.gz \
                    --thin-annot \
                    --out ${SAVE_DIR}/${celltype}/control.${chromosome} \
                    --print-snps ${LDSC_DATA_DIR}/hapmap3_snps/hm.${chromosome}.snp
            fi
        done
    } &
done

wait
echo "[DONE] All LD score computations finished."
