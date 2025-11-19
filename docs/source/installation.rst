============
Installation
============

The Python package ``MacSGP`` is publicly available at https://github.com/YangLabHKUST/MacSGP/. It's recommended to first create a virtual environment.

.. code-block:: bash

  conda create -n MacSGP python=3.11
  conda activate MacSGP

Installing ``MacSGP`` from PyPI
=================================

MacSGP can be directly installed from PyPI:

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
