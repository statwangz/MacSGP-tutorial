==========================================================
Simulation study
==========================================================

Here we applied MacSGP to a simulated dataset. We simulated two cell types termed cell type A and cell type B, which were colocalized at each spot within the area in all experiments. The proportion of cell type A increases from left to right along the x-axis, while the proportion of cell type B decreases inversely. We selected 200 genes to form a cell-type-A-specific SGP, which means that the expression of these genes co-varies within cell type A, and we consider cell type B as a null case, where its average gene expression profile exhibited no intra-cell-type spatial variation. 

.. toctree::
   :maxdepth: 3
   
   simulation_macsgp
   simulation_benchmark

.. bibliography::
   :filter: {"analysis/simulation/index"} & docnames
