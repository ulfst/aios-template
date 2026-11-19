# Productbench AIOS: Starter Kit (Google Antigravity Edition)

A free, MIT-licensed starter kit that turns **Google Antigravity** into your personal **AI Operating System (AIOS)**. Originally built by [Productbench](https://www.productbench.co/) for product managers, senior PMs, and heads of product, and adapted for the **Antigravity Desktop App**, **Antigravity IDE**, **Antigravity CLI (`agy`)**, **Cloud conversations (Remote Agents)**, and Google AI models (**Hydrogen, Argon, Carbon, and Neon**).

The kit sets itself up through a short `/onboard` conversation. Then it grows in two ways: **skills** for the recurring work in your role, and **expansions** (from `EXPANSIONS.md`) when your knowledge base outgrows the basics.

---

## What's inside

| Piece | What it is |
|---|---|
| Antigravity Plugin (`.agents/plugins/aios/`) | Packages the 5 starter skills and the `SessionStart` hook into a native Antigravity plugin (`plugin.json` + `hooks.json` + `skills/`). |
| Working rules (`GEMINI.md`) | Root operating manual automatically loaded by Antigravity. Holds 8 concrete rules for how the AI works with you: answer first, say it once, plain English, push back early, and more. When you correct it, it offers to save the correction as a new rule. |
| `knowledge/` | The knowledge base: a daily log, raw sources, and cited pages. Rules in `knowledge/RULES.md`. |
| Session-start hook | Antigravity `SessionStart` hook (`hooks.json` → `hooks/catch-up-nudge.sh`) that injects a reminder to run `/catching-up` when the last one is over 4 hours old, or to resume `/onboard` if you stopped halfway. |
| `EXPANSIONS.md` | One catalog of everything to add later, and when. |

---

## Skills

| Skill | What it does | Use it when | Setup |
|---|---|---|---|
| [`/onboard`](.agents/plugins/aios/skills/onboard/SKILL.md) | Sets up your AIOS: your name, writing style, company and role, how you work together, optional goals. Skip anything. | You just got the kit, or your role changed | None |
| [`/catching-up`](.agents/plugins/aios/skills/catching-up/SKILL.md) | Reads what changed in your connected tools since you last looked: what needs you, what's out of date, with fixes for a yes | You start a work session and want to know what you missed | One connected tool |
| [`/meetings-to-issues`](.agents/plugins/aios/skills/meetings-to-issues/SKILL.md) | Turns meeting notes into tracker issues, logged decisions and parked ideas. Checks for duplicates and creates nothing until you say yes | A meeting just ended and its next steps need to land in Linear, Jira or Asana | A connected tracker plugin/MCP. Walks you through the rest on first run |
| [`/decision-review`](.agents/plugins/aios/skills/decision-review/SKILL.md) | Reviews a decision before you commit: the assumptions you haven't said out loud, checked against your evidence via an independent read-only subagent, with the cheapest test for each. Logs your verdict and a date to check back | You're about to commit to a decision that feels obvious, and being wrong would cost you | None |
| [`/go-deeper`](.agents/plugins/aios/skills/go-deeper/SKILL.md) | Rewrites a task into the version a top professional would do: their raw material, their methods, and an outside check that the result is right | Your AI gives you the obvious answer and you want the expert one | None |

You can invoke any skill explicitly in chat by typing `/skill-name` (e.g., `/decision-review`), or let Antigravity load it automatically via progressive disclosure when your prompt matches its description.

---

## Quick start (Antigravity Desktop App, CLI, & Cloud)

1. **Get your own copy.** Create a private repository from this template (or clone it locally into a private repo). Your answers and content stay in your copy.
2. **Open it and run `/onboard`.**
   - **Antigravity Desktop App:** Open **Projects**, add or select this folder, start a **New Conversation**, pick a Google AI model (**Hydrogen**, **Argon**, **Carbon**, or **Neon**) in **Settings > Model Selection**, and run `/onboard`.
   - **Antigravity CLI (`agy`):** `cd` into the folder, run `agy`, and type `/onboard`.
   - **Antigravity Cloud conversations (Remote Agents):** Connect your private GitHub repository as a Remote Project in the Antigravity Desktop App or at `antigravity.google` (or launch `agy --remote-agent`). Antigravity automatically discovers `GEMINI.md` and `.agents/plugins/aios/` in the repo.
   It asks one short thing at a time, and you can skip anything.
3. **Connect tools via Antigravity Plugins or MCP.**
   - In the Antigravity Desktop App, open **Customizations > Marketplace** (e.g., Gmail, Google Drive, Google Sheets, Google Slides) or **Customizations > Installed** to authorize tools, or configure custom MCP servers in `~/.gemini/config/mcp_config.json`.
   - Ask your agent: *"help me connect my calendar"* or *"help me connect Linear"*, then add a row to `context/connections.md`.
   - Once wired, say **"catch me up"** or run `/catching-up`.
4. **Use it for a week.** Bring real questions and decisions; your agent logs them to `knowledge/log/` as you go. Hand over material (transcripts, docs) and it compiles cited pages in `knowledge/pages/`. When an answer feels off, correct it—your agent will fix it and offer to save a rule in `GEMINI.md`. Note that `knowledge/sources/` is gitignored by default, so back it up separately (or attach files via Google Drive / upload in Cloud conversations).
5. **Grow it.** A task repeats 3+ times → save a new skill in `.agents/skills/<name>/SKILL.md` using `references/what-a-good-skill-looks-like.md`. Need more structure → add an expansion from `EXPANSIONS.md`.

### Using the `aios` plugin across other workspaces or Cloud conversations

- **Install locally into global Antigravity config:**
  ```bash
  agy plugin install ./.agents/plugins/aios
  ```
- **Install from your GitHub repository (for other workspaces or Remote Agents):**
  ```bash
  agy plugin install https://github.com/<owner>/<repo>/tree/main/.agents/plugins/aios
  ```
- **Validate the plugin anytime:**
  ```bash
  agy plugin validate --strict ./.agents/plugins/aios
  ```

### Model guidance (Hydrogen, Argon, Carbon, Neon)

- **Hydrogen / Argon:** Great for deep synthesis, `/decision-review`, `/go-deeper`, and complex multi-step planning.
- **Carbon / Neon:** Fast and responsive for routine `/catching-up` scans, daily logging, and quick `/meetings-to-issues` runs.

---

## Repo layout

```
├── README.md
├── GEMINI.md                ← Root operating manual and working rules (filled by /onboard)
├── EXPANSIONS.md            ← Everything to add later, and when
├── LICENSE
├── .agents/
│   └── plugins/
│       └── aios/            ← Antigravity plugin (auto-discovered in workspace)
│           ├── plugin.json
│           ├── hooks.json   ← SessionStart catch-up / onboarding nudge
│           ├── hooks/
│           │   └── catch-up-nudge.sh
│           └── skills/      ← /onboard, /catching-up, /meetings-to-issues, /decision-review, /go-deeper
├── context/                 ← About you and your world: connections.md, intake.md (/onboard progress log)
│                                + about-me, about-business, priorities, voice (created by /onboard)
├── knowledge/               ← The knowledge base: read its RULES.md first
│   ├── log/                 ← Ground truth: what happened, daily files, append-only
│   ├── sources/             ← Ground truth: raw material, never edited
│   ├── pages/               ← Compiled synthesis, cited back to sources/log
│   └── index.md             ← One line per page and source
├── references/              ← Read on demand: API guides, SOPs, skill guides
│   └── what-a-good-skill-looks-like.md  ← How to build a skill: principles, skeleton, checklist
└── archive/                 ← Old material and /onboard backups. Don't delete, move here.
```

The design premise in one line: **you keep the synthesis, not the pile of transcripts.** Every claim in `pages/` cites its evidence in `log/` or `sources/`. Full rules in `knowledge/RULES.md`.

---

## License

MIT License. See `LICENSE`. Fork it, rebrand it, make it yours.
