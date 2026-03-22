-- ═══════════════════════════════════════════════════════════════
--  SEQ Appearance Watcher — grandMA3 v2.x
--  Surveille la séquence sélectionnée dans le pool et applique
--  automatiquement l'apparence "SEQ_ACTIVE".
--  Restaure l'apparence d'origine lors de la désélection.
--
--  Prérequis : une apparence nommée exactement "SEQ_ACTIVE"
--              doit exister dans l'Appearance Pool.
-- ═══════════════════════════════════════════════════════════════

return function()

    -- ── Configuration ──────────────────────────────────────────
    local ACTIVE_APP_NAME = "SEQ_ACTIVE"   -- Nom de l'apparence active
    local POLL_INTERVAL   = 0.5            -- Intervalle de polling en secondes
    -- ───────────────────────────────────────────────────────────

    -- Vérifie que l'apparence "SEQ_ACTIVE" existe dans le pool
    local activeApp = ShowData().Appearances[ACTIVE_APP_NAME]
    if not activeApp then
        ErrEcho("SEQ Watcher : Apparence '" .. ACTIVE_APP_NAME .. "' introuvable !")
        ErrEcho("SEQ Watcher : Crée-la dans l'Appearance Pool puis relance le plugin.")
        return
    end

    Echo("SEQ Watcher : Démarré — apparence '" .. ACTIVE_APP_NAME .. "' prête.")

    -- ── État interne ────────────────────────────────────────────
    local prevSeq        = nil   -- Handle de la séquence précédente
    local prevAppearance = nil   -- Son apparence d'origine sauvegardée
    -- ───────────────────────────────────────────────────────────

    -- Boucle principale
    while true do

        -- Récupère la séquence actuellement sélectionnée (nil si aucune)
        local ok, currSeq = pcall(SelectedSequence)
        if not ok then currSeq = nil end

        -- Agit uniquement si la sélection a changé
        if currSeq ~= prevSeq then

            -- 1) Restaure l'apparence d'origine sur l'ancienne séquence
            if prevSeq ~= nil then
                pcall(function()
                    prevSeq.Appearance = prevAppearance
                end)
            end

            -- 2) Sauvegarde l'apparence d'origine de la nouvelle séquence
            --    puis applique "SEQ_ACTIVE"
            if currSeq ~= nil then
                local savedOk, savedApp = pcall(function()
                    return currSeq.Appearance
                end)
                prevAppearance = savedOk and savedApp or nil
                pcall(function()
                    currSeq.Appearance = activeApp
                end)
            else
                -- Aucune séquence sélectionnée → on remet à zéro
                prevAppearance = nil
            end

            -- Met à jour la référence de la séquence précédente
            prevSeq = currSeq
        end

        -- Attend avant la prochaine vérification
        coroutine.yield(POLL_INTERVAL)
    end

end
```

---

### Comment l'installer

**1. Créer le plugin**
Dans le Plugin Pool, édite un objet vide → donne-lui un nom (ex. `SEQ Watcher`) → crée un composant Lua → colle le code ci-dessus → `Save`.

**2. Créer l'apparence "SEQ_ACTIVE"**
Dans l'Appearance Pool, crée une apparence nommée **exactement** `SEQ_ACTIVE` (couleur vive, fond jaune, etc. — ce que tu veux).

**3. Lancer le plugin**
Tape dans la command line :
```
Plugin "SEQ Watcher"
```
Il tourne en arrière-plan. Pour l'arrêter :
```
Plugin "SEQ Watcher" /Kill