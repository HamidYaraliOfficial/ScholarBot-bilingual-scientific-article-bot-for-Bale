# Changelog

## 1.0.0 — 2026-11-15
First complete release of **ScholarBot** by Hamid Yarali.

- Bilingual (Persian / English) Bale bot: DOI, title, author, article link, arXiv / PubMed / PMC identifiers.
- Legal-sources-only retrieval: Crossref, OpenAlex, Unpaywall, Europe PMC (PubMed Central), DOAJ, arXiv, CORE.
- PDF validation (signature, structure, SHA-256), de-duplication by DOI / title hash / file hash.
- Admin dashboard (FastAPI + Jinja2 + HTMX): statistics and charts, article management with checkbox bulk actions,
  permanent library, history, users, sources, administrators with roles, reports, settings, logs, backup & restore.
- Security: Argon2 passwords, CSRF, CSP, SSRF-safe downloader with IP pinning, rate limits, account lockout, audit log,
  write-only secrets, formula-injection-safe exports.
- Start scripts for Windows (`start_windows.bat`) and Linux/macOS (`start_unix.sh`), Alembic migrations, 119 automated tests.
