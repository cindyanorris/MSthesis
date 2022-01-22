# Governance and Voting Systems Within Decentralized Organizations and Communities

You can find the most recent PDF [here](output/thesis.pdf).

## Requirements

- Python
  - Pygments - `pip install pygments`
  - Pygments - Solidity - `pip install pygments-lexer-solidity`

## Building

There are a number of ways to build this project:

- `xelatex`

    ```sh
    xelatex -output-directory=output -shell-escape thesis.tex
    ```

- `make`

    ```sh
    make
    ```

- `tectronic`

    ```sh
    tectronic thesis.tex
    ```

- `latexmk`, this will watch the files and update them with a live preview.

    ```sh
    latexmk -pvc -file-line-error -interaction=nonstopmode -xelatex -shell-escape -output-directory=output
    ```

Note that generated PDF figures within `figures/**/figure.pdf` need to be
updated if the `figure.tex` generating said PDF has been updated.
