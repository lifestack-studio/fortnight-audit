# The Fortnight Audit — package (v2)

A free, LLM-agnostic prompt that runs a two-week time audit for business owners — then reads what the same fortnight says across the **eight domains of the lifestack** — and outputs a branded, downloadable report. A gift to lifestack prospects (Lap 1 — Awareness, entered through Vocation).

**v2 supersedes The Time Audit (v1, `../time-audit/`).** What changed: the tool is renamed **The Fortnight Audit**; a "Beyond the calendar" phase (five short, skippable questions) plus session-wide *emergence harvesting* feeds an eight-domain reading; the report gains a whole-life radar, eight evidence-anchored domain cards on a five-level scale (Unseen · Strained · Holding · Steady · Integrated — each level answering to a lap of the method), a "Where to begin — your first lap" recommendation, and a campaign-configurable masthead/CTA; the LinkedIn line is gone; hosted pages are fully self-contained (local fonts).

## What's in here

| File | What it is |
|---|---|
| `fortnight-audit-master-prompt.md` | **The product.** The full copy-paste prompt. Self-contained: carries the report's HTML/CSS template + the official logo SVG + the legal footer. LLM-agnostic (recommends Claude). |
| `fortnight-audit-prompt-pack.html` | **The distribution page.** Branded page with a one-click **Copy prompt** button, a 4-step guide, and CTAs to lifestack.studio. This is the page you host. |
| `sample-report.html` | A worked example of the output (fictional "Sarah Chen"), for reference/marketing. Uses the local fonts, so it can be hosted alongside the pack. |
| `assets/report-template.html` | The parametrised report template (`{{PLACEHOLDERS}}`) that lives inside the master prompt. 39 placeholders. |
| `assets/brand/lifestack-logo.svg` | The official logo (used inline in all outputs). |
| `assets/fonts/*.woff2` | Inter 300–700 (latin + latin-ext), self-hosted — the hosted pages make **no external font requests** (and avoid the Google-Fonts GDPR wrinkle). |
| `Dockerfile`, `.dockerignore`, `deploy/nginx.conf` | Drop-in container to serve this folder from a subdomain of lifestack.studio. |
| `proofs/` | Rendered PNG/PDF proofs of the report and the prompt-pack page. |

## How a prospect uses it

1. Opens the prompt-pack page → **Copy prompt**.
2. Pastes it into Claude (recommended), ChatGPT, Gemini, or Copilot.
3. Uploads a calendar screenshot / export, or describes their fortnight; confirms the auto-suggested categories (batched, low-effort); answers five short reflection questions (each skippable).
4. Reviews the readings in plain text — and can correct any that feel wrong — before the report is generated.
5. Receives the branded report and downloads it as a PDF (button + print stylesheet).

## Reusing this tool for a new campaign

The prompt is parameterised at the top: a **CAMPAIGN CONFIGURATION** table holds `TOOL_NAME`, `TOOL_BADGE`, `REPORT_TITLE`, `REPORT_SUB`, and the four CTA values (`CTA_HEADLINE/BODY/BUTTON_LABEL/URL` + `CTA_FOOTNOTE`). To spin a campaign variant: edit that table (and, if you want, the *Begin* message at the end of the prompt) — the report inherits everything automatically.

⚠️ **The prompt lives in two places.** `fortnight-audit-master-prompt.md` is the source of truth, and the prompt-pack page embeds a copy inside `<script type="text/plain" id="promptSrc">…</script>`. If you edit the prompt, update both — paste the new .md content into that script block (it contains no `</script>`, so a straight paste is safe).

## Fonts — one deliberate asymmetry

The **hosted pages** (prompt-pack, sample report) use the local woff2 files via `@font-face` — fully self-contained for the Docker deployment. The **report template inside the master prompt** keeps the Google Fonts `<link>` with a system-font fallback stack, because that HTML is generated inside the prospect's own AI session and saved anywhere on their machine — relative font paths would 404 there. Offline it degrades gracefully to system fonts.

## To publish (Docker)

**Production (Hostinger VPS + Traefik, tools.lifestack.studio):** deploy `docker-compose.yml` with Hostinger Docker Manager under the project name `tools`. The compose builds the image straight from GitHub (`#main`) and attaches it to the external `root_traefik-net` network with the two-router Traefik pattern (HTTP→HTTPS redirect, Let's Encrypt via `mytlschallenge`); no host ports are published. **To ship an update:** push to `main`, then rebuild/redeploy the `tools` project in Docker Manager — or, from the VPS shell: `docker compose -p tools up -d --build`.

**Local test:**

```bash
docker build -t fortnight-audit . && docker run --rm -p 8080:80 fortnight-audit
# → http://localhost:8080/  (lands on the prompt-pack page)
```

`/` lands on the prompt-pack page; keep `fortnight-audit-master-prompt.md` in the web root next to it — the **Download .md** link is relative. `.dockerignore` keeps README, proofs and compose files out of the image; `deploy/` is copied for the nginx config and then removed from the served web root by the Dockerfile.

## The five-level domain scale (for reference)

Unseen (no real picture) · Strained (visible depletion) · Holding (effortful) · Steady (genuinely well) · Integrated (holds itself). Levels 1–4 answer to Laps 1–4 (Awareness → Understanding → Intervention → Integration); Integrated is the destination. Readings carry confidence marks: ●●● said directly · ●●○ answered when asked · ●○○ read between the lines. Vocation is read from the audit data itself; **Identity is never asked — only read** (the synthesis domain).

## Still open (your call)

- **Booking link:** CTAs point to `https://lifestack.studio` (per campaign config). Swap in a dedicated booking URL when one exists — one edit in the CAMPAIGN CONFIGURATION table (+ the page CTA button).
- **Legal wording:** footer language carried over from v1 — adviser sign-off still pending.

## Notes

- Colours, fonts, logo, and tone follow the 2026 brand guidelines (Teal `#004F5C`, Orange `#FF4500`, Inter).
- Legal entity in footers: **lifestack Consulting Limited**. Tagline lowercase: *full presence. full performance.*
- The radar is pure SVG with a pre-computed coordinate lookup (8 domains × 5 levels) in the prompt's fill rules — no trigonometry for the generating LLM, same trick as the donut's `pathLength="100"`.
