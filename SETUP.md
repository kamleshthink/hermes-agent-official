# Hermes Agent (Nous Research) — Complete Setup Guide

DeepSeek + Telegram + GitHub + Render — sab kuch ek jagah.

---

## 1. Installation (Local Test Ke Liye)

**Windows (PowerShell):**
```powershell
iwr -useb https://hermes-agent.nousresearch.com/install.sh | iex
```
> Install hota hai `%LOCALAPPDATA%\hermes` me. Python 3.13 + uv + Node 26 auto-install hote hain.

**Linux/macOS:**
```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

---

## 2. DeepSeek Setup

```bash
hermes setup
```

Wizard me:
| Prompt | Answer |
|---|---|
| Setup mode | Quick Setup |
| Model provider | **DeepSeek** |
| API key | `sk-41f726bff6e54684928acc3b25f6d359` |
| Base URL | `https://api.deepseek.com` |
| Model | `deepseek-v4-pro` |

Ya manually (config.yaml):
```yaml
model:
  default: "deepseek/deepseek-v4-pro"
```

---

## 3. Telegram Setup (.env)

`.env` file me (maine bana diya hai):
```
TELEGRAM_BOT_TOKEN=8615025338:AAGA9Jidz4IivKIXK2DXs9QwSHnxjQ-axSc
TELEGRAM_ALLOWED_USERS=5843051109
DEEPSEEK_API_KEY=sk-41f726bff6e54684928acc3b25f6d359
```

Gateway start karo:
```bash
hermes gateway
```

Pehli baar DM karo bot ko — pairing approve hota hai automatically (allowlist se).

---

## 4. GitHub Integration

Hermes Agent ka `github` skill use karta hai `gh` CLI:
```bash
# GitHub CLI install
winget install --id GitHub.cli

# Login (token se)
gh auth login
# → GitHub.com → HTTPS → Paste token: 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
```

Ab agent GitHub issues/PRs/commits kar sakta hai.

---

## 5. Render Deployment

### Docker Web Service
| Setting | Value |
|---|---|
| Runtime | Docker |
| Docker Command | `hermes gateway` |
| Disk | 2GB mount `/root/.hermes` |
| Env vars | DEEPSEEK_API_KEY, TELEGRAM_BOT_TOKEN, TELEGRAM_ALLOWED_USERS |

### Telegram Webhook Mode (cloud ke liye)
```
TELEGRAM_WEBHOOK_URL=https://your-app.onrender.com/telegram
TELEGRAM_WEBHOOK_PORT=8443
TELEGRAM_WEBHOOK_SECRET=<random>
```

---

## 6. App Building (Kaise Banega)

```
Tu (Telegram): "Zomato app banao, restaurant listing se shuru karo"
        ↓
Hermes Agent (DeepSeek V4 Pro): samajhta hai
        ↓
Skills + Tools use karta hai (file create, edit, terminal)
        ↓
Persistent Memory me project yaad rakhta hai
        ↓
GitHub pe commit karta hai (github skill)
```

**DeepSeek V4 Pro khud code likhta hai** — koi Claude/Codex nahi chahiye.

---

## Commands Cheatsheet

| Command | Kaam |
|---|---|
| `hermes` | CLI chat |
| `hermes setup` | Setup wizard |
| `hermes model` | Model change |
| `hermes gateway` | Telegram gateway |
| `hermes dashboard` | Web UI |
| `hermes tools` | Tools enable/disable |
| `hermes doctor` | Diagnose issues |
| `hermes update` | Update |
