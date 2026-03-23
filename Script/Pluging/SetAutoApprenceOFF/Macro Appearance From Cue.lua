-- ═══════════════════════════════════════════════════════════════
--  Macro Appearance From Cue — grandMA3 v2.x
--  Surveille un Cue spécifique d'une séquence.
--  Cue ON  → copie l'apparence du Cue ON  sur la Macro.
--  Cue OFF → copie l'apparence du Cue OFF sur la Macro.
-- ═══════════════════════════════════════════════════════════════

local function main()

    -- ── Configuration ──────────────────────────────────────────
    local SEQ_NUMBER     = 1    -- Numéro de la séquence à surveiller
    local CUE_ON_NUMBER  = 1    -- Numéro du Cue "ON"  à surveiller
    local CUE_OFF_NUMBER = 0    -- Numéro du Cue "OFF" (son apparence est appliquée quand inactif)
    local MACRO_NUMBER   = 1    -- Numéro de la Macro cible
    local POLL_INTERVAL  = 0.2  -- Intervalle de scrutation en secondes
    -- ───────────────────────────────────────────────────────────

    -- Récupère la séquence
    local seq = ShowData().DataPools.Default.Sequences[SEQ_NUMBER]
    if not seq then
        ErrEcho("MacroApp : Sequence " .. tostring(SEQ_NUMBER) .. " introuvable !")
        return
    end

    -- Récupère la macro
    local macro = ShowData().DataPools.Default.Macros[MACRO_NUMBER]
    if not macro then
        ErrEcho("MacroApp : Macro " .. tostring(MACRO_NUMBER) .. " introuvable !")
        return
    end

    -- ── Trouve un Cue par son numéro dans la séquence ───────────
    -- Les numéros de Cue sont stockés ×1000 en interne (Cue 1 = 1000)
    local function findCue(cueNo)
        local cues = seq.Cues
        if not cues then return nil end
        for i = 0, Obj.count(cues) - 1 do
            local cue = cues[i]
            if cue and cue.No == cueNo * 1000 then
                return cue
            end
        end
        return nil
    end
    -- ───────────────────────────────────────────────────────────

    -- Vérifie que les deux Cues existent
    local cueOn = findCue(CUE_ON_NUMBER)
    if not cueOn then
        ErrEcho("MacroApp : Cue ON " .. tostring(CUE_ON_NUMBER) .. " introuvable dans la Sequence " .. tostring(SEQ_NUMBER) .. " !")
        return
    end

    local cueOff = findCue(CUE_OFF_NUMBER)
    if not cueOff then
        ErrEcho("MacroApp : Cue OFF " .. tostring(CUE_OFF_NUMBER) .. " introuvable dans la Sequence " .. tostring(SEQ_NUMBER) .. " !")
        return
    end

    Echo("MacroApp : Demarre — Seq " .. tostring(SEQ_NUMBER) ..
         "  Cue ON=" .. tostring(CUE_ON_NUMBER) ..
         "  Cue OFF=" .. tostring(CUE_OFF_NUMBER) ..
         "  → Macro " .. tostring(MACRO_NUMBER))

    -- ── État interne ────────────────────────────────────────────
    local prevActive = nil
    -- ───────────────────────────────────────────────────────────

    while true do

        local ok, currCueNo = pcall(function() return seq.CueNo end)
        if not ok then currCueNo = nil end

        local isActive = (currCueNo ~= nil and currCueNo == CUE_ON_NUMBER * 1000)

        if isActive ~= prevActive then

            if isActive then
                -- Cue ON actif → applique son apparence à la Macro
                pcall(function()
                    macro.Appearance = cueOn.Appearance
                end)
                Echo("MacroApp : Cue " .. tostring(CUE_ON_NUMBER) .. " ON  → apparence ON  appliquee a la Macro " .. tostring(MACRO_NUMBER))
            else
                -- Cue passé OFF → applique l'apparence du Cue OFF à la Macro
                pcall(function()
                    macro.Appearance = cueOff.Appearance
                end)
                Echo("MacroApp : Cue " .. tostring(CUE_ON_NUMBER) .. " OFF → apparence OFF appliquee a la Macro " .. tostring(MACRO_NUMBER))
            end

            prevActive = isActive
        end

        coroutine.yield(POLL_INTERVAL)
    end

end

return main
