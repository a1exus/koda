# Contributing

## Adding a Model Profile

1. Create `profiles/.env-<ModelName>.<Quant>` with these required fields:

   ```bash
   # https://huggingface.co/<original-model>
   HF_REPO=<gguf-repo>
   MODEL_DIR=~/models/<model-family>
   MODEL_FILE=<filename>.gguf
   DOWNLOAD_INCLUDE=<filename>.gguf          # space-separated if multiple files
   ALIAS=<clean-id>                          # e.g. gemma-4-31b-it
   ```

2. Verify the profile resolves correctly:

   ```bash
   make check-model ENV=profiles/.env-<ModelName>.<Quant>
   ```

3. Update all of the following (see the full checklist in [AGENTS.md](./AGENTS.md#adding-a-new-model-profile)):

   | File | What to add |
   | :--- | :--- |
   | `profiles/README.md` | Model subsection with variant table, ALIAS, and Sources |
   | `AGENTS.md` | Row in the Bundled Profiles table |
   | `OPENCODE.md` | Entry in the `models` block |
   | `VSCODE.md` | Entry in the `chatLanguageModels.json` snippet |
   | `CURSOR.md` | *(alias list links to profiles/README.md — no edit needed)* |
   | `CHANGELOG.md` | Entry under `[Unreleased] > Added` |
   | `~/.config/opencode/opencode.json` | Alias entry in the live config |
   | `~/Library/Application Support/Code - Insiders/User/chatLanguageModels.json` | Model entry |

## General Guidelines

- Keep profiles minimal — only set what differs from the defaults in `.env`.
- Always include the HuggingFace source URL as a comment on the first line.
- Use the same `ALIAS` across all quant variants of the same model so client configs don't need to change when you swap quants.
- Run `sh scripts/validate-profiles.sh` before opening a PR to catch missing fields.
- Run `lychee --exclude 'mailto:' --exclude 'localhost' '**/*.md'` before opening a PR to catch broken links (requires `brew install lychee`).

## Reporting Issues

Open an issue at [github.com/a1exus/koda/issues](https://github.com/a1exus/koda/issues).
