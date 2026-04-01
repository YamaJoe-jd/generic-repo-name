<p align="center">
  <img src="https://via.placeholder.com/120" width="120" alt="Network File Guard Logo"/>
</p>

<h1 align="center">Network File Guard</h1>

<p align="center">
  Concurrency‑safe monitoring and write orchestration for SMB network shares.
</p>



Network File Guard is a full‑stack monitoring and management agent designed to protect files on SMB network shares from concurrent write conflicts. When multiple users or processes attempt to update the same file, Network File Guard intelligently queues write operations and flushes them in a single, safe burst once the file becomes free — preventing data corruption, lock collisions, and partial writes.

## 📸 Dashboard Preview

> *UI preview coming soon — live monitoring, queued writes, and system health at a glance.*


## ✨ Key Features
- **Concurrency‑safe write orchestration** for SMB network shares  
- **Real‑time monitoring** of file access and lock state  
- **Write‑intent queueing** with deterministic flush behavior  
- **Full‑stack TypeScript monorepo**  
- **Structured logging** for auditability and debugging  
- **Modern frontend dashboard** for system visibility  

## 🧩 Tech Stack

### Frontend
- React + Vite  
- Tailwind CSS  
- Radix UI (shadcn/ui)  
- Wouter  
- TanStack Query (React Query)  
- Orval‑generated OpenAPI hooks  

### Backend
- Node.js 24  
- Express 5  
- PostgreSQL  
- Drizzle ORM  
- Zod (shared schemas)  
- Pino logging  

### Tooling & Architecture
- pnpm workspaces  
- TypeScript project references  
- esbuild (API)  
- Vite (frontend)  
- Docker + docker-compose  

```mermaid
flowchart TD

    A[Frontend Dashboard<br/>React + Vite] 
        --> B[API Server<br/>Express 5 + Node 24]

    B --> C[Write Intent Queue<br/>PostgreSQL + Drizzle ORM]

    C --> D[Safe Flush Engine<br/>Atomic Write Orchestration]

    D --> E[SMB Network Share<br/>Shared File System]

    style A fill:#4c8bf5,stroke:#1b4db3,stroke-width:1px,color:#fff
    style B fill:#6c5ce7,stroke:#3d2db3,stroke-width:1px,color:#fff
    style C fill:#00b894,stroke:#006f52,stroke-width:1px,color:#fff
    style D fill:#fdcb6e,stroke:#b88700,stroke-width:1px,color:#000
    style E fill:#d63031,stroke:#8b1e1e,stroke-width:1px,color:#fff
```



```mermaid
sequenceDiagram
    autonumber

    participant U as User/Process
    participant API as API Server<br/>Express 5
    participant DB as Write Intent Queue<br/>PostgreSQL + Drizzle
    participant FE as Safe Flush Engine
    participant SMB as SMB Network Share

    U->>API: Write Request (file + payload)
    API->>API: Validate payload (Zod)
    API->>DB: Insert Write Intent
    API-->>U: Acknowledged (queued)

    Note over DB: Queue grows while file is locked

    FE->>SMB: Check file lock state
    SMB-->>FE: File is locked

    FE->>SMB: Poll until file becomes free
    SMB-->>FE: File is free

    FE->>DB: Fetch queued write intents
    FE->>FE: Merge & prepare atomic write
    FE->>SMB: Perform safe flush (single write burst)
    SMB-->>FE: Write successful

    FE->>DB: Mark intents as completed
```




```mermaid
flowchart LR

    subgraph Local_Dev [Local Development Environment]
        direction TB
        DEV_PC[Developer Machine\nNode 24 + pnpm + TypeScript]
        VITE[Frontend - React + Vite]
        API_LOCAL[API Server - Express 5]
        DB_LOCAL[(PostgreSQL - Local/Docker)]
        SMB_LOCAL[[SMB Network Share]]

        DEV_PC --> VITE
        DEV_PC --> API_LOCAL
        API_LOCAL --> DB_LOCAL
        API_LOCAL --> SMB_LOCAL
    end

    subgraph Production [Production Deployment - Fly.io]
        direction TB
        FLY_API[Fly.io App - Node 24 + Express 5]
        FLY_DB[(Fly.io PostgreSQL)]
        SMB_PROD[[SMB Network Share]]

        FLY_API --> FLY_DB
        FLY_API --> SMB_PROD
    end

    VITE -. API URL .-> FLY_API
    API_LOCAL -. mirrors .-> FLY_API
```

