Request
   ↓
┌────────────────────── Gateway ──────────────────────┐
│                                                     │
│  1. Admission Control                              │
│     ├─ Rate Limit                                  │
│     ├─ Concurrency Limit                           │
│     └─ Request Size Limit                          │
│                                                     │
│  2. Traffic Policy                                 │
│     ├─ Timeout                                     │
│     ├─ Retry                                       │
│     └─ Circuit Breaker                             │
│                                                     │
│  3. Traffic Routing                                │
│     ├─ Load Balancing                              │
│     ├─ Weighted Routing                            │
│     ├─ Canary                                      │
│     └─ Version Routing                             │
│                                                     │
└────────────────────────┬────────────────────────────┘
                         ↓
                    Services