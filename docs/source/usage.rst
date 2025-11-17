=====
Usage
=====

Required data
=============

* Spatial transcriptomic (ST) data: gene expression + spatial coordinates;

* Annotated single-cell RNA-sequencing (scRNA-seq) data: gene expression + cell type labels.

Pipeline overview
=================

.. figure:: figures/pipeline.png
   :width: 960px
   :align: center
   :alt: Pipeline

Cell type deconvolution
=======================


Cell-type-specific SGP identification
=====================================

With the deconvolution results, we can identify cell-type-specific SGPs by applying ``MacSGP``.
Please see more examples in :doc:`/analysis/index`.

.. bibliography::
    :filter: {"usage"} & docnames

