# Configuration file for the Sphinx documentation builder.

# -- Project information

project = "MacSGP"
copyright = "2025, Yeqin Zeng"
author = "Yeqin Zeng and Zhiwei Wang"

release = "0.1"
version = "0.1.0"

# -- General configuration

extensions = [
    "sphinx.ext.duration",
    "sphinx.ext.doctest",
    "sphinx.ext.autodoc",
    "sphinx.ext.autosummary",
    "sphinx.ext.intersphinx",
    "sphinx_copybutton",  # Add "copy to clipboard" buttons to all text/code boxes
    "sphinxcontrib.bibtex",  # Manage bibliography
    "nbsphinx",  # Jupyter Notebook tools for Sphinx
]

intersphinx_mapping = {
    "python": ("https://docs.python.org/3/", None),
    "sphinx": ("https://www.sphinx-doc.org/en/master/", None),
}
intersphinx_disabled_domains = ["std"]

templates_path = ["_templates"]

# -- Options for HTML output

# html_theme = "sphinx_rtd_theme"
html_theme = "press"

html_static_path = ["_static"]


def setup(app):
    app.add_css_file("my_theme.css")


exclude_patterns = ["_build", "**.ipynb_checkpoints", "**.rmd"]

# -- Options for EPUB output
epub_show_urls = "footnote"

# References
bibtex_bibfiles = ["refs.bib"]
bibtex_bibliography_header = ".. rubric:: References"
