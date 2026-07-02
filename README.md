# SOC Cheat Sheet – Junior Analyst Edition

**One-page A4 printable cheat sheet for your first SOC shift.**

Designed for a small Kenyan SaaS (≤200 users, on-prem VMs + Nginx). No SIEM dependencies – works with raw logs.

---

## 📋 What's Inside

| Log Source | Fields | Baseline | Misuse Signatures |
|------------|--------|----------|-------------------|
| **Linux auth.log** | 5 fields | Nairobi office IP, <10 failed logins/day | SSH brute-force, root sudo from dev, after-hours logins |
| **Windows Security** | 6 fields | 2 jumpboxes, <5 failed logons/day | RDP from non-jumpbox, privilege escalation, lockout storm |
| **HTTP access log** | 7 fields | 95% GET /api/*, 500 req/min | Path traversal, 404 scanning, POST to static folders |

---

## 🚀 Quick Start

1. **Print the cheat sheet** → [`CHEAT-SHEET.md`](CHEAT-SHEET.md) (A4-ready)
2. **Run detection scripts** → [`/detection-scripts/`](/detection-scripts)
3. **Practice with samples** → [`/sample-logs/`](/sample-logs)

---

## 📊 Detection Scripts (One-liners)

### Linux (SSH Brute-Force)
```bash
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | awk '$1>20'
