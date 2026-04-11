# Architecture Overview

## Purpose

This document describes the **architecture and execution models** used in the *Enterprise Identity Automation* project.

The goal of the architecture is to demonstrate how **the same PowerShell identity logic** can be safely executed across **multiple enterprise orchestration layers** without rewriting core functionality.

---

## High‑Level Architecture

Request / Trigger
│
▼
Orchestration Layer
(RMM or Azure Automation)
│
▼
PowerShell Automation Logic
(Modular, Idempotent)
│
▼
Active Directory
│
▼
Audit & Execution Logs

This separation ensures:
- Secure execution
- Platform portability
- Enterprise‑grade auditability

---

## Core Components

### 1. PowerShell Business Logic (Modules)

**Location:** `/modules`

This layer contains reusable, platform‑agnostic logic:
- User provisioning logic
- Input validation
- Idempotency checks
- Structured output

**Key Characteristics**
- No embedded credentials
- No platform‑specific assumptions
- Safe to reuse across execution models

This mirrors how enterprises separate **business logic** from **automation tooling**.

---

### 2. Orchestration Layer (Execution Models)

The project intentionally supports **two execution models**, reflecting real enterprise environments.

---

## Execution Model 1: RMM (NinjaOne)

**Location:** `/rmm/NinjaOne`

### Use Case
Operational, technician‑approved identity actions.

### Characteristics
- Human‑initiated execution
- Governed by RMM approvals and role‑based access
- Runs under a service account scoped to specific OUs
- Ideal for:
  - Help desk workflows
  - Exception handling
  - MSP or hybrid environments

### Architectural Role
The RMM acts as:
- The **control plane**
- The **audit boundary**
- The **approval mechanism**

The PowerShell script acts only as the execution engine.

---

## Execution Model 2: Azure Automation Runbook

**Location:** `/azure-automation`

### Use Case
Enterprise IAM and event‑driven identity lifecycle automation.

### Characteristics
- Cloud‑orchestrated execution
- Runs under **Managed Identity**
- Uses **Hybrid Runbook Workers** for on‑prem Active Directory
- Triggered by:
  - Webhooks
  - APIs
  - Schedules
  - HR or ITSM systems

### Architectural Role
Azure Automation acts as:
- The orchestration engine
- The identity boundary
- The audit and logging platform

This model aligns with **Joiner / Mover / Leaver** workflows in mature IAM environments.

---

## Identity & Security Model

### Authentication
- ❌ No interactive logons
- ❌ No credentials stored in scripts
- ✅ Service accounts (RMM)
- ✅ Managed Identity (Azure Automation)

### Authorization
- Permissions scoped to:
  - Specific Organizational Units
  - Limited AD actions (create, modify)
- Domain Admin rights are **not required**

### Security Principles Applied
- Least privilege
- Separation of duties
- No shared credentials
- Execution isolation

---

## Idempotency & Safety

All provisioning logic is **idempotent**:
- Existing users are detected before creation
- Re‑execution does not cause duplication
- Failures are explicit and logged

This allows:
- Safe retries
- Automation chaining
- Event‑driven execution without risk

---

## Logging & Auditability

### RMM Execution
- Script output captured by RMM job logs
- Technician identity and execution context preserved

### Azure Automation Execution
- Job history stored in Automation Account
- Output available for:
  - Log Analytics
  - SIEM integration
  - Compliance review

No local file logging is required in cloud execution.

---

## Why a Single Repository

This project intentionally uses **one repository** to represent **one solution**.

The repository contains:
- One business problem
- One automation design
- Multiple execution strategies

This reflects real enterprise practices, where:
- Logic is reused
- Platforms evolve
- Automation survives tooling changes

---

## Architectural Takeaway

This project demonstrates that **enterprise automation is not about the tool** — it is about:

- Clean separation of logic
- Secure identity handling
- Platform‑agnostic design
- Operational realism

The same automation can operate safely whether triggered by:
- A technician in an RMM
- An HR system via Azure Automation
- A future IAM platform

---

## Future Architecture Extensions

Planned architectural enhancements include:
- Joiner / Mover / Leaver workflows
- ITSM webhook integration (ServiceNow‑style)
- Centralized log analytics
- Group‑based access automation
- CI validation of PowerShell modules