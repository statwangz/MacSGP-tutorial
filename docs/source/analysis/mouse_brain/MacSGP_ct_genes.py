import sys
import pandas as pd
import numpy as np
import scanpy as sc
import anndata as ad
import scipy.io
import os
import warnings

RAW_PATH = "/import/home2/share/yqzeng/data/Mouth_brain_visium" # Raw data
DATA_PATH = "/import/home2/share/yqzeng/MacSGP/data/Mouth_brain_visium" # Raw data
SAVE_PATH = "/import/home2/share/yqzeng/MacSGP/results/Mouth_brain_visium/MacSGP" # Deconvolution results

all_genes = pd.read_csv(os.path.join(RAW_PATH, "visium_1/mouse_brain_visium_1_counts.csv"), index_col=0).columns
adata_result = sc.read_h5ad(os.path.join(SAVE_PATH, 'visium_1', "adata_result_visium_1.h5ad"))
adata_ref = sc.read_h5ad('/import/home2/share/yqzeng/MacSGP/data/Mouth_brain_visium/visium_1/adata_basis.h5ad')

def mcube_filter_genes_cell_type(celltype, all_celltypes, gene_test,
                                  library_sizes, proportions, reference,
                                  reference_threshold=0.5, platform_effects=None):
    C = 15
    N_cells = np.sum(proportions[celltype])

    library_sizes_list = library_sizes[proportions[celltype] >= 0.99]
    if len(library_sizes_list) < 10:
        library_sizes_list = library_sizes[proportions[celltype] >= 0.80]
    if len(library_sizes_list) < 10:
        library_sizes_list = library_sizes[proportions[celltype] >= 0.50]
    if len(library_sizes_list) < 10:
        library_sizes_list = library_sizes[proportions[celltype] >= 0.01]

    library_sizes_median = np.median(library_sizes_list)
    expr_thresh = C / (N_cells * library_sizes_median)

    reference_renorm = reference.loc[all_celltypes][gene_test] * np.exp(platform_effects[gene_test])

    gene_list_type = np.setdiff1d(gene_test, gene_test[reference_renorm.loc[celltype] < expr_thresh])

    celltype_means = reference_renorm.loc[all_celltypes][gene_list_type]
    if proportions.shape[1] > 1:
        celltype_mean_ratio = celltype_means.loc[celltype] / np.max(celltype_means, axis=0)
        gene_list_type = gene_list_type[celltype_mean_ratio >= reference_threshold]

    print(f"mcubeFilterGenesCellType: Select {len(gene_list_type)} genes to analyze for {celltype}.")

    return gene_list_type

all_celltypes = [
 'Ext_Amy_2',
 'Ext_Hpc_CA1',
 'Ext_Hpc_CA3',
 'Ext_Hpc_DG1',
 'Ext_L23',
 'Ext_L5_1',
 'Ext_L5_2',
 'Ext_Med',
 'Ext_Pir',
 'Ext_Thal_1',
 'Ext_Thal_2',
 'Inh_1',
 'Inh_4',
 'Oligo_2']
gene_test = adata_ref.var_names#.to_list()
library_sizes = adata_result.obs['library_size']
proportions = adata_result.obsm['proportion']
reference = pd.DataFrame(adata_ref.X, index=adata_ref.obs_names, columns=adata_ref.var_names)
platform_effects = adata_result.var['gamma']

ct_genes = {}
for ct in all_celltypes:
    ct_genes[ct] = mcube_filter_genes_cell_type(ct, all_celltypes, gene_test,
                                  library_sizes, proportions, reference,
                                  reference_threshold=0.3, platform_effects=platform_effects)
    
homologs = pd.read_csv(os.path.join(DATA_PATH, "mouse_human_homologs.txt"), sep="\t")

size = int(sys.argv[1]) if len(sys.argv) > 1 else 450

os.makedirs(os.path.join(SAVE_PATH, "visium_1", 'enrichment_final', f"top{size}"), exist_ok=True)
save_path = os.path.join(SAVE_PATH, "visium_1", 'enrichment_final', f"top{size}")

# Get all genes that were measured as control genes
all_genes_df = pd.DataFrame({
    'MOUSE_GENE_SYM': all_genes
})

all_genes_df = pd.merge(
    all_genes_df,
    homologs,
    on='MOUSE_GENE_SYM'
    )

all_genes_df['HUMAN_GENE_SYM'].to_csv(
    os.path.join(save_path, "all_genes.txt"),
    header=False,
    index=False,
    quoting=3
)
# Get all test genes that are expressed in brain as control genes
brain_genes_df = pd.DataFrame({
    'MOUSE_GENE_SYM': adata_result.var_names
})

brain_genes_df = pd.merge(
    brain_genes_df,
    homologs,
    on='MOUSE_GENE_SYM'
)

brain_genes_df['HUMAN_GENE_SYM'].to_csv(
    os.path.join(save_path, "brain_genes.txt"),
    header=False,
    index=False,
    quoting=3
)
ct_list = all_celltypes
# Get cell-type-specific test genes that are expressed in certain cell type as control genes
loading_df = adata_result.varm['loading']

for celltype in ct_list:
    sig_genes_1 = set(ct_genes[celltype]).intersection(set(loading_df[celltype].nlargest(size).index.tolist()))
    sig_genes_2 = set(ct_genes[celltype]).intersection(set(loading_df[celltype].nsmallest(size).index.tolist()))
    sig_genes = sig_genes_1.union(sig_genes_2)
    print(celltype, len(sig_genes))
    sig_genes_df = pd.DataFrame({
        'MOUSE_GENE_SYM': list(sig_genes)
    })

    sig_genes_df = pd.merge(
        sig_genes_df,
        homologs,
        on='MOUSE_GENE_SYM'
    )

    sig_genes_df['HUMAN_GENE_SYM'].to_csv(
        os.path.join(save_path, f"{celltype}_sig_genes.txt"),
        header=False,
        index=False,
        quoting=3
    )

for celltype in ct_list:
    control_genes_df = pd.DataFrame({
        'MOUSE_GENE_SYM': list(ct_genes[celltype])
    })

    control_genes_df = pd.merge(
        control_genes_df,
        homologs,
        on='MOUSE_GENE_SYM'
    )

    control_genes_df['HUMAN_GENE_SYM'].to_csv(
        os.path.join(save_path, f"{celltype}_control_genes.txt"),
        header=False,
        index=False,
        quoting=3
    )

