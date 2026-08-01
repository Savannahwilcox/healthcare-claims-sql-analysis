# Project Workflow

```mermaid
flowchart LR
    A[CMS Synthetic Medicare CSV Files]
    B[Raw PostgreSQL Staging Tables]
    C[Clean Analytical Tables]
    D[SQL Validation]
    E[Business-Focused SQL Analysis]
    F[Tableau Dashboard]
    G[GitHub Documentation]

    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
