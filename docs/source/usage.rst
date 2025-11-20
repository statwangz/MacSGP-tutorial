=====
Usage: 
=====

Required data
=============

* Spatial transcriptomic (ST) data: gene expression + spatial coordinates;

* Annotated single-cell RNA-sequencing (scRNA-seq) data: gene expression + cell type labels.

Preprocessing
=============
First, we need to prepare the ST data and reference data into two ``AnnData`` objects, which is the standard data class we use in ``MacSGP``. If you’re unfamiliar, you can refer to their `documentation <https://anndata.readthedocs.io/en/latest/index.html>`_ for details on creating ``AnnData`` objects from scratch and importing other formats (CSV, MTX, Loom, etc.) into ``AnnData``.

Here we use the 10x visium mouse brain data for example, the ``h5ad`` project of ST data and reference data can be downloaded from here. 





Overview of MacSGP
==================

.. figure:: figures/overview.png
   :width: 960px
   :align: center
   :alt: Overview

Cell type deconvolution
=======================

To distinguish cell-type-specific SGPs from cell type markers, we first need to estimate the cell type proportions to account for cell type mixtures through deconvolution methods. Here we provide our own implementation for cell type deconvolution that leverages deep graph neural networks and keeps consistency between the deconvolution results and the MacSGP model in terms of the definition of cell type proportion and correction of platform effects between ST and scRNA-seq technologies.



Cell-type-specific SGP identification
=====================================

With the deconvolution results, we can identify cell-type-specific SGPs by applying ``MacSGP``.
Please see more examples in :doc:`/analysis/index`.

.. bibliography::
    :filter: {"usage"} & docnames

