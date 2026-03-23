-- ═══════════════════════════════════════════════════════════════
--  Cue Appearance → Macro Watcher — grandMA3 v2.x
--  Surveille le Cue actif d'une séquence et applique
--  son apparence à la Macro portant le même nom.
--  Si aucune apparence sur le Cue → apparence "OFF" appliquée.
-- ═══════════════════════════════════════════════════════════════

local function main()

    -- ── Configuration ──────────────────────────────────────────
    local SEQ_NAME      = "MA_SEQ"  -- nom de la séquence à surveiller
    local OFF_APP_NAME  = "OFF"     -- apparence appliquée quand inactif
    local POLL_INTERVAL = 0.5
    -- ───────────────────────────────────────────────────────────

    -- Vérifie que l'apparence "OFF" existe
    local offApp = ShowData().Appearances[OFF_APP_NAME]
    if not offApp then
        ErrEcho("Cue Watcher : Apparence '" .. OFF_APP_NAME .. "' introuvable !")
        ErrEcho("Cue Watcher : Crée-la dans l'Appearance Pool puis relance le plugin.")
        return
    end

    -- ── Trouve la séquence par son nom ──────────────────────────
    local function findSequence()
        local sequences = ShowData().DataPools.Default.Sequences
        if not sequences then return nil end
        for i = 0, sequences.Count - 1 do
            local seq = sequences[i]
            if seq and seq.Name == SEQ_NAME then
                return seq
            end
        end
        return nil
    end

    local seq = findSequence()
    if not seq then
        ErrEcho("Cue Watcher : Séquence '" .. SEQ_NAME .. "' introuvable !")
        return
    end

    Echo("Cue Watcher : Démarré — surveillance de '" .. SEQ_NAME .. "'.")

    -- ── Trouve le Cue actif par son numéro (seq.CueNO) ─────────
    -- Cue.No est stocké × 1000 (ex: Cue 3.000 = 3000)
    local function findActiveCue()
        local cueNo = seq.CueNO
        if not cueNo then return nil end
        local cueList = seq.CueList
        if not cueList then return nil end
        for i = 0, cueList.Count - 1 do
            local cue = cueList[i]
            if cue and cue.No == cueNo then
                return cue
            end
        end
        return nil
    end
    -- ───────────────────────────────────────────────────────────

    -- ── Trouve une Macro par son nom ────────────────────────────
    local function findMacro(name)
        local macros = ShowData().DataPools.Default.Macros
        if not macros then return nil end
        for i = 0, macros.Count - 1 do
            local macro = macros[i]
            if macro and macro.Name == name then
                return macro
            end
        end
        return nil
    end
    -- ───────────────────────────────────────────────────────────

    -- ── État interne ────────────────────────────────────────────
    local prevCue = nil
    -- ───────────────────────────────────────────────────────────

    while true do

        local ok, currCue = pcall(findActiveCue)
        if not ok then currCue = nil end

        if currCue ~= prevCue then

            -- Remet l'apparence "OFF" sur la Macro de l'ancien Cue
            if prevCue ~= nil then
                pcall(function()
                    local macro = findMacro(prevCue.Name)
                    if macro then
                        macro.Appearance = offApp
                    end
                end)
            end

            -- Applique l'apparence du nouveau Cue sur sa Macro
            if currCue ~= nil then
                pcall(function()
                    local macro = findMacro(currCue.Name)
                    if macro then
                        local cueApp = currCue.Appearance
                        macro.Appearance = cueApp or offApp
                    end
                end)
            end

            prevCue = currCue
        end

        coroutine.yield(POLL_INTERVAL)
    end

end

return main
