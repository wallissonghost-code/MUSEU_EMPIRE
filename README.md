# MUSEU EMPIRE

Projeto oficial do jogo **Museu Empire** para Roblox.

## Roblox
- Universe ID: `10757803326`
- Root Place ID: `115967612388956`
- Visibilidade de desenvolvimento: privada

## Estrutura
- `scripts/current-place.rbxmk.lua` — gera o DataModel do jogo
- `scripts/prepare-place.sh` — gera `Museu-Empire.rbxl`
- `.github/workflows/publish-roblox.yml` — publicação via Roblox Open Cloud
- `.deploy/` — registros gerados automaticamente após publicação

## Deploy
O workflow usa o secret do GitHub Actions `MUSEU_EMPIRE_API_KEY`.
Commits com `[DEPLOY_ROBLOX]` disparam a publicação para o Place oficial.
