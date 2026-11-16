--[[
    Violence District — Killer Perk Shop Reference
    Source: VD Discord + Wealthy District Wiki, patches through Nov 7 2026

    17 universal killer perks from the shop.
    Separate from the 27 killer-specific perks (3 per killer at Lvl 15/30/45).
    All usable on any killer once purchased.

    Nov 7: aura perks no longer target chained survivors.
    Affected: Cold Blooded, Stage Fright.


    ═══════════════════════════════════════════════════════════════════════
    CHASE
    ═══════════════════════════════════════════════════════════════════════

    Cold Blooded
        Down a survivor (not camping) → healthy survivors within 60 studs:
        9/12/15% Slowness 10s, aura 4s, nearest emits sound cue.
        No longer targets chained (Nov 7).

    Murderous Acrobatics
        In chase: vault windows 30% faster (60s CD).
        After vault: 3/4/5% Haste 4s.

    Surge of Power
        Within 50/60/70 studs of a gen:
        Completed gen = 6% speed. Regressing gen = 3% speed.
        Lingers 3s. Doesn't stack.


    ═══════════════════════════════════════════════════════════════════════
    SLOWDOWN
    ═══════════════════════════════════════════════════════════════════════

    Diminishing Returns
        Survivor takes damage → 1 token (cap starts at 2).
        Chain: spend all tokens → 3% repair slow per token on ALL survivors 60/70/80s.
        Raises cap by 1. Scales harder as match progresses.

    Veiled Corruption
        Match start: 3 farthest gens blocked 45/60/75s.
        Damage gen → see aura while regressing.
        Nov 7: highlights EVERY regressing gen.

    Visceral Drive
        After chain, 45s window: damage gen → explodes, -10/13/16% progress (capped).
        Survivors within 120 studs: aura 5s.

    King's Scourge
        Once per gen: at 90% → aura + loud notification.
        Repairers get 9/12/15 skill checks. Progress paused until all hit.
        Fail → Vulnerable + 10% repair penalty 5/10/15s, -15 charges, 2x regression.

    Dread Harvest
        While survivor on chain (not anti-camp range):
        1/2/3% speed per survivor repairing.
        Unrepaired gens regress 100/150/200%.


    ═══════════════════════════════════════════════════════════════════════
    AURA / INFO
    ═══════════════════════════════════════════════════════════════════════

    All Seeing Eye
        2+ survivors on same gen 5s → noise notification + gen aura 3s.
        CD: 60/50/40s.

    Eyes of Hell
        See pallets, dropped pallets, vaults within 80/90/100 studs.
        Survivor vaults → 4% Slowness 5s. CD: 60/50/40s.

    Stage Fright
        Your aura revealed → 5/6/7% speed for reveal duration.
        Nov 7: reveals aura to nearest non-chained survivor.

    Exposure Therapy
        Damage survivor → 1 token (max 8).
        Survivor finishes healing another in TR → both Vulnerable 10s
        + 3/4/5s per token consumed (max 4) + 1s aura per token.
        CD: 30s.


    ═══════════════════════════════════════════════════════════════════════
    STEALTH
    ═══════════════════════════════════════════════════════════════════════

    Silent Shadow
        Leave chase without downing → readies perk.
        Next chase escape without downing → Undetectable 20/30/40s. CD: 45s.


    ═══════════════════════════════════════════════════════════════════════
    UTILITY
    ═══════════════════════════════════════════════════════════════════════

    Touch of Death
        Vault window → apply ToD (white aura, max 2 windows). You vault 20% faster.
        Survivor vaults ToD window → Vulnerable 15/20/25s + aura 2s. Removes effect.

    Deep Wound
        3 cursed chains. Freed from cursed → Anti-Heal 20/30/40s + 100% more blood.

    Trade Off
        Trial start: 2 random chains cursed (aura to killer).
        Normal chain save → chain becomes cursed.
        Cursed chain → highest gen aura 4/8/12s.

    Containment
        Vault window as killer → 5/10/15% faster + block window 16s.


    ═══════════════════════════════════════════════════════════════════════
    EXPLOIT NOTES
    ═══════════════════════════════════════════════════════════════════════
    - Diminishing Returns token cap scales infinitely — server tracks state
    - Veiled Corruption blocked gens likely tagged (FlaggedGenerator or similar)
    - Visceral Drive 45s timer trackable — know when enhanced kicks expire
    - King's Scourge skill checks are server-validated
    - Dread Harvest regression speed is per-tier attribute
    - Deep Wound + Trade Off spawn cursed chains — ESP can tag special hooks
    - Touch of Death windows have white aura — track via killer attribute state
    - Silent Shadow Undetectable = no TR — proximity alert must account
    - Stage Fright + Desire For The Living = aura feedback loop
    - Exposure Therapy tokens trackable — healing near killer punished harder
]]

return nil
