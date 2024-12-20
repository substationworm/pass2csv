# pass2csv

![](pass2csv-MainHeader.png "pass2csv-MainHeader")

[![Curriculum Lattes](https://img.shields.io/badge/Lattes-white)](http://lattes.cnpq.br/8846358506427099)
[![ORCID](https://img.shields.io/badge/ORCID-grey)](https://orcid.org/0000-0002-6254-7306)
[![SciProfiles](https://img.shields.io/badge/SciProfiles-black)](https://sciprofiles.com/profile/lffreitas-gutierres)
[![Scopus](https://img.shields.io/badge/Scopus-white)](https://www.scopus.com/authid/detail.uri?authorId=57195542368)
[![Web of Science](https://img.shields.io/badge/ResearcherID-grey)](https://www.webofscience.com/wos/author/record/Q-8444-2016)
[![substationworm](https://img.shields.io/badge/substationworm-black)](https://github.com/substationworm)

## Introduction

`pass2csv` is a command line interface (CLI) for exporting passwords from `pass` ([the standard Unix password manager](https://www.passwordstore.org/)) into a CSV format compatible with [KeePass](https://keepass.info/) import functionality.

## Usage básico

Possuindo dependência com o `pass` (❗), a execução do `pass2csv`é efetuada da seguinte forma:

1. 👉 Download o script a partir de:
```bash
git clone https://github.com/substationworm/pass2csv.git
cd pass2csv
```

2. 👉 Grant execution permission using the command:
```bash
chmod +x pass2csv.sh
```

3. 👉 Run the script in the terminal with:
```bash
./pass2csv.sh
```

`pass2csv` possui as seguintes opções de linha de comando:
- `-h`: Displays the help message.
- `-o <file>`: Specifies the output file (default: passwordsCSV.csv).
- `-f <fields>`: Excludes specific fields from the CSV. Available fields:
    - Title.
    - User.
    - Password.
    - URL.
    - Notes.
- `-d <directory>`: Specifies the `.password-store` directory (default: `~/.password-store`).

---

*Corresponding author:* [Prof. Dr. Luiz F. Freitas-Gutierres](https://www.linkedin.com/in/lffreitas-gutierres/) ([luiz.gutierres@ufsm.br](mailto:luiz.gutierres@ufsm.br)).

*License:* [MIT](https://github.com/substationworm/pass2csv/blob/main/LICENSE).



