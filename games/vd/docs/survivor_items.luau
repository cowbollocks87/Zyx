--[[
    Violence District — Survivor Items Reference
    Source: VD Discord + Wealthy District Wiki, patches through Nov 7 2026

    12 survivor items. Each survivor equips one per match.
    Patch changes: Oct 31 (ToF rework, Flashlight, Holy Water, Parrying Dagger,
    Monkey Paw), Nov 1 (ToF ranked hotfix), Nov 7 (Parrying Dagger nerf).


    ═══════════════════════════════════════════════════════════════════════
    OFFENSIVE
    ═══════════════════════════════════════════════════════════════════════

    Twist of Fate
        Hold to charge shot. Fire chance scales with hold time:
            Loaded:   60% at 0.75s, 80% at 1.8s, 100% at 3s
            Unloaded: 20% at 0.75s, 35% at 1.8s,  50% at 3s
        Hit → stun killer. Jam → injured + Anti-Heal 30s.
        Unloaded: CD ends early on bullet gain.
        Start 1 bullet. Gain by: gen complete, unhook, heal 2 survivors.
        Ranked: no stun, instead 50% Slowness 4s, 2s charge time.

    Flashlight
        Shine on killer face → blind + drop carried survivor.
        Full blind: +10% slow 5s (45s CD per flashlight).
        Min blind: 0.8s. No longer muffles killer hearing.

    Parrying Dagger
        Flick to guard stance. Parry window: 0.8s.
        Success: stun killer 2.5s. Stays on CD until killer hits you, then 60s CD.
        Miss: 60s CD. Dagger returns 60s after hit.

    Holy Water
        Throw → 16 stud fiery circle 10s.
        Slows killer 5% per 0.5s, stacking to 15%.
        Killer recovers 5%/sec after leaving.
        Thrower slowed half killer's amount. 60s CD.

    Riot Shield
        Ramp from walk speed to 18 sps over 4s. Lasts 35s or until impact.
        3+ seconds of charge = stun on killer impact. 50s CD.


    ═══════════════════════════════════════════════════════════════════════
    DEFENSIVE / MOBILITY
    ═══════════════════════════════════════════════════════════════════════

    Gate
        Spawn teleport to random map location. 3s windup (no running).
        Teleport lasts 5s. 60s CD. Interrupted: 5s CD.

    Shadow Clone
        Hand signs → smoke cloud → clone runs forward.
        60s CD. Interrupted: 5s CD.

    Adrenaline Shot
        5% speed 12s. If downed with ≥15% recovery: self-pickup 12s + same boost.
        Recovery progress retained. 60s CD.

    Monkey Paw
        Healthy: self-injure + on-hit speed boost. Anti-Heal 45s.
        If not downed when Anti-Heal expires: heal to full.
        Healing healthy survivor: instant complete + steal 1 chain stage.
        Steal: injured + Anti-Heal 60s.
        Once per game per TEAM. 90s CD.


    ═══════════════════════════════════════════════════════════════════════
    INFORMATION
    ═══════════════════════════════════════════════════════════════════════

    Motion Tracker
        Hold to activate. Beeps faster as killer nears.
        Reveals running teammate auras within 100 studs.

    Waxbound Candle
        Rapid killer aura flashes 5s. 6 uses. 30s CD.


    ═══════════════════════════════════════════════════════════════════════
    HEALING
    ═══════════════════════════════════════════════════════════════════════

    Bandage
        Self-heal 2 health states. 24s per state.


    ═══════════════════════════════════════════════════════════════════════
    EXPLOIT NOTES
    ═══════════════════════════════════════════════════════════════════════
    - ToF fire chance is server-rolled — charge time is client-tracked
      Ranked vs casual may differ (stun vs slowness). Check game mode.
    - Flashlight blind requires face LOS — angle calc is server-side
      45s slow CD is per flashlight instance, not per blind
    - Parrying Dagger 0.8s window is tight — knowing exact attack windup
      timings per killer is critical (Slasher fastest, Abysswalker long)
      Post-parry state (waiting for hit vs 60s CD) is trackable
    - Holy Water slow stacking is incremental — circle position ESP-markable
    - Riot Shield 3s threshold for stun — proximity alert must account
    - Gate 3s windup interruptible, destination random (not predictable)
    - Shadow Clone runs straight — distinguish clone from player
      (clone has no player tag / different instance type)
    - Adrenaline Shot self-pickup at 15% recovery = ~3.6s of recovery
      Strongest anti-slug item
    - Monkey Paw chain steal once per TEAM — if any teammate uses, gone
      Anti-Heal after steal (60s) is longest item-applied
    - Motion Tracker beep rate = precise killer distance if audio processed
      Only reveals running teammates, not crouching/walking
    - Waxbound Candle 6 uses = most info-dense item over a match
      Rapid aura = pulsing, not continuous
    - Bandage 24s per state is slower than teammate healing
      Mainly for solo builds (NPNG, Built Different)
]]

return nil
