-- ═══════════════════════════════════════════════════════════════
--  SEQ Appearance Watcher — grandMA3 v2.x
-- ═══════════════════════════════════════════════════════════════

local function main()

    -- ── Configuration ──────────────────────────────────────────
    local ACTIVE_APP_NAME = "SEQ_ACTIVE"
    local POLL_INTERVAL   = 0.5
    -- ───────────────────────────────────────────────────────────

    -- Vérifie que l'apparence "SEQ_ACTIVE" existe
    local activeApp = ShowData().Appearances[ACTIVE_APP_NAME]
    if not activeApp then
        ErrEcho("SEQ Watcher : Apparence '" .. ACTIVE_APP_NAME .. "' introuvable !")
        ErrEcho("SEQ Watcher : Crée-la dans l'Appearance Pool puis relance le plugin.")
        return
    end

    Echo("SEQ Watcher : Démarré — apparence '" .. ACTIVE_APP_NAME .. "' prête.")

    -- ── État interne ────────────────────────────────────────────
    local prevSeq        = nil
    local prevAppearance = nil
    -- ───────────────────────────────────────────────────────────

    -- ── Trouve la séquence avec un Cue actif ────────────────────
    local function findRunningSequence()
        local sequences = ShowData().DataPools.Default.Sequences
        if not sequences then return nil end
        for i = 0, sequences.Count - 1 do
            local seq = sequences[i]
            if seq and asActivePlayback(seq) then
                return seq
            end
        end
        return nil
    end
    -- ───────────────────────────────────────────────────────────

    while true do

        local ok, currSeq = pcall(findRunningSequence)
        if not ok then currSeq = nil end

        if currSeq ~= prevSeq then

            -- Restaure l'apparence d'origine sur l'ancienne séquence
            if prevSeq ~= nil then
                pcall(function()
                    prevSeq.Appearance = prevAppearance
                end)
            end

            -- Sauvegarde et applique "SEQ_ACTIVE" sur la nouvelle
            if currSeq ~= nil then
                local savedOk, savedApp = pcall(function()
                    return currSeq.Appearance
                end)
                prevAppearance = savedOk and savedApp or nil
                pcall(function()
                    currSeq.Appearance = activeApp
                end)
            else
                prevAppearance = nil
            end

            prevSeq = currSeq
        end

        coroutine.yield(POLL_INTERVAL)
    end

end

return main