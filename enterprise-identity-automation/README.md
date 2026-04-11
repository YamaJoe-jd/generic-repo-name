# Enterprise Identity Automation

## Overview
This project demonstrates enterprise‑safe Active Directory automation using PowerShell across two execution models:
- RMM‑based operational automation (NinjaOne)
- Cloud‑orchestrated Azure Automation runbooks

The same identity logic is reused across platforms while maintaining least privilege, idempotency, and auditability.

## Execution Models
- **RMM (NinjaOne):** Technician‑approved operational workflows
- **Azure Automation:** Event‑driven IAM and lifecycle automation

## Core Principles
- Separation of business logic from orchestration
- No embedded credentials
- Least‑privilege execution
- Safe re‑execution (idempotent design)
- Enterprise‑ready logging

See ARCHITECTURE.md for design details.

## Disclaimer
This project is intended for learning and demonstration purposes and mirrors real enterprise automation patterns.
