============
Installation
============

The Python package ``MacSGP`` is publicly available at https://github.com/YangLabHKUST/MacSGP/. It's recommended to first create a virtual environment.

.. code-block:: bash

  conda create -n MacSGP python=3.11
  conda activate MacSGP

Requirements
=================================

MacSGP requires ``pytorch`` <https://pytorch.org/get-started/locally/> and ``PyG`` <https://pytorch-geometric.readthedocs.io/en/latest/install/installation.html>. 

For ``PyG``, MacSGP also requires its additional libraries, their installation requires specifications for torch version and CUDA version. Users could use ``nvcc --version`` to check the CUDA version for installation.

Here we provide with an example of the CUDA ``12.8`` installation code.

.. code-block:: bash

  pip install torch_geometric
  
  # Additional dependencies:
  pip install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.8.0+cu128.html

Installing ``MacSGP`` from PyPI
=================================

MacSGP can be directly installed from PyPI

.. code-block:: bash
  
  pip install MacSGP

Installing ``MacSGP`` from Github
=================================

Alternatively, MacSGP can be downloaded from GitHub:

.. code-block:: bash
  
  # Clone the repository
  git clone https://github.com/YangLabHKUST/MacSGP.git
  cd MacSGP
  
  # Install the required packages
  install -r requirements.txt
  
  # Install MacSGP
  python setup.py build
  python setup.py install
