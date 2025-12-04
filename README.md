[Amos](https://github.com/open-amos/amos) | [Core](https://github.com/open-amos/core) | [Reconciliation](https://github.com/open-amos/reconciliation) | **Dashboard** | [Source Example](https://github.com/open-amos/source-example)

---

# AMOS Dashboard

A reference implementation of a BI dashboard for private markets built on top of AMOS, based on the [Evidence](https://evidence.dev) framework (Svelte).

![image](https://img.shields.io/badge/version-0.1.0-blue?style=for-the-badge) ![image](https://img.shields.io/badge/status-public--beta-yellow?style=for-the-badge) ![image](https://img.shields.io/badge/JavaScript-323330?style=for-the-badge&logo=javascript&logoColor=F7DF1E) ![image](https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00)

---

## Quick Start

Install and run [AMOS](https://github.com/open-amos/amos) with Docker:

```bash
# 1. Clone the repo
git clone [https://github.com/open-amos/amos.git](https://github.com/open-amos/amos.git)
cd amos

# 2. Launch the stack
docker-compose up -d

# 3. Access the UI
# Dashboard: http://localhost:3000
# Database: localhost:5432
```
If you prefer to run this in your own environment without Docker:

1. Install [Amos](https://github.com/open-amos/amos) manually
2. Git clone this repository
3. Configure your database connection details in `sources/**/connection.yaml`
4. Run `npm install` to install the dependencies
5. Run `npm run sources` to install the sources
6. Run `npm run dev` to start the development server

Then open the local URL printed by the dev server.

## Demo

Explore a live dashboard built on top of the AMOS architecture.
[**→ View live demo**](https://demo.amos.tech)
![image](https://amos.tech/wp-content/uploads/2025/04/screely-1764599384361-2048x1175.png)

## Licensing

This subproject is part of the AMOS public preview. Licensing terms will be finalized before version 1.0.
For now, the code is shared for evaluation and feedback only. Commercial or production use requires written permission from the maintainers.
