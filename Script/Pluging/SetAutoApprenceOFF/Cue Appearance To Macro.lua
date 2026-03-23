-- ═══════════════════════════════════════════════════════════════
--  Cue Appearance To Macro — grandMA3 v2.x
--  Surveille le Cue actif d'une séquence et applique son
--  apparence à une Macro cible.
-- ═══════════════════════════════════════════════════════════════

local function main()

    -- ── Configuration ──────────────────────────────────────────
    local SEQ_NUMBER    = 1     -- Numéro de la séquence à surveiller
    local MACRO_NUMBER  = 1     -- Numéro de la macro cible
    local POLL_INTERVAL = 0.5   -- Intervalle de scrutation en secondes
    -- ───────────────────────────────────────────────────────────

    -- Récupère la séquence cible
    local seq = ShowData().DataPools.Default.Sequences[SEQ_NUMBER]
    if not seq then
        ErrEcho("Cue->Macro : Sequence " .. tostring(SEQ_NUMBER) .. " introuvable !")
        return
    end

    -- Récupère la macro cible
    local macro = ShowData().DataPools.Default.Macros[MACRO_NUMBER]
    if not macro then
        ErrEcho("Cue->Macro : Macro " .. tostring(MACRO_NUMBER) .. " introuvable !")
        return
    end

    Echo("Cue->Macro : Demarre - Sequence " .. tostring(SEQ_NUMBER) .. " -> Macro " .. tostring(MACRO_NUMBER))

    -- ── État interne ────────────────────────────────────────────
    local prevCueNo = nil
    -- ───────────────────────────────────────────────────────────

    -- ── Trouve le Cue correspondant au numéro actif ─────────────
    local function findActiveCue(cueNo)
        local cues = seq.Cues
        if not cues then return nil end
        for i = 0, Obj.count(cues) - 1 do
            local cue = cues[i]
            if cue and cue.No == cueNo then
                return cue
            end
        end
        return nil
    end
    -- ───────────────────────────────────────────────────────────

    while true do

        local ok, currCueNo = pcall(function() return seq.CueNo end)
        if not ok then currCueNo = nil end

        if currCueNo ~= prevCueNo then

            if currCueNo ~= nil then
                local cue = findActiveCue(currCueNo)
                if cue then
                    local appOk, app = pcall(function() return cue.Appearance end)
                    if appOk then
                        pcall(function()
                            macro.Appearance = app
                        end)
                        Echo("Cue->Macro : Cue " .. tostring(currCueNo) .. " -> apparence appliquee a la Macro " .. tostring(MACRO_NUMBER))
                    end
                else
                    Echo("Cue->Macro : Cue " .. tostring(currCueNo) .. " introuvable dans la sequence.")
                end
            end

            prevCueNo = currCueNo
        end

        coroutine.yield(POLL_INTERVAL)
    end

end

return main
