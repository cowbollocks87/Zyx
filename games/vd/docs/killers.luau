--[[
    Violence District — Killer Reference
    Source: VD Discord, patches through Nov 7 2026

    9 killers. Each has unique power(s) and 3 unlockable perks (Lvl 15/30/45).
    Perks are universal once unlocked. Separate perk shop in killer_perk_shop.luau.

    Speed reference: survivor base = 17 sps (100%)
    All speeds listed as studs/sec and % of survivor base.


    ═══════════════════════════════════════════════════════════════════════
    1. THE STALKER  (Michael Myers)
    ═══════════════════════════════════════════════════════════════════════
    Terror Radius: 100 (Hunter only; Stalker = Undetectable)
    Speed: 18.7 sps / 110% (Stalker) → 20.4 sps / 120% (Hunter)

    Powers
        Stalk (passive)
            Starts in Stalker Mode: permanent Undetectable, 18.7 sps.
            Stalk survivors to fill meter: 1 charge/sec, 5.0 total needed.
            Move speed while stalking: 12 sps. Distance affects charge rate.
            Chaining a survivor in Stalker Mode fills 40% of meter.

        Evil's Grasp (M2 — unlocked when meter full)
            Lunge forward in grab animation. Cannot be stunned during.
            Hit: picks up survivor, slams down → anti-heal 40s → enters Hunter Mode.
            Miss: stays Stalker, meter resets.

        Hunter Mode (state after Evil's Grasp hit)
            Duration: 70s. Speed: 20.4 sps / 120%.
            Terror Radius: 100. Vault/break 20% faster.
            Each chain in Hunter saves 20% meter for return to Stalker.

    Perks
        Predator (Lvl 15)
            Survivor escapes chase → aura revealed 6s + 5% speed for duration.
            No longer targets chained survivors. CD: 40/35/30s.

        Eternal Torment (Lvl 30)
            Stunned by survivor → Vulnerable 20/25/30s (40s CD).
            Survivor drops pallet → 5% slow 4s (no CD).

        Play With Your Food (Lvl 45)
            Survivor escapes chase → 1 token (max 3). Each = 2/3/4% speed.
            Basic/special attack removes 1 token.


    ═══════════════════════════════════════════════════════════════════════
    2. THE SLASHER  (Jason Voorhees)
    ═══════════════════════════════════════════════════════════════════════
    Terror Radius: 100
    Speed: 19.125 sps / 112.5%

    Powers
        Lake Mist (M2)
            Invisibility + heavy speed boost.
            Cannot activate if survivors nearby or have LOS. CD: 30s.

        Pursuit (Q)
            Increased speed for 22s. Extra 4% first 3s after windup.
            Walks through pallets, smashing them → 50% slow 2s + attack lockout.
            Both halved if smashed within 1s of windup end. CD: 60s.

    Perks
        Excitement (Lvl 15)
            Pick up downed 25/33/50% faster. Carrying: 9/12/15% speed + 24 stud TR.
            Boost retained 3/7/10s after chaining.

        Brutal Strength (Lvl 30)
            Break pallets / kick gens 10/20/30% faster. Gen kick = +3% damage.

        Offscreen Scare (Lvl 45)
            Not in chase → 8/10/12% speed. Within 50 studs of unchained survivor →
            deactivates, gain 3/5/7s Undetectable. CD: 45s.


    ═══════════════════════════════════════════════════════════════════════
    3. THE KILLER  (Jeff The Killer)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Frenzy (M2)
            Activate frenzy buff: vault pallets, vault windows faster.
            Chain hits gain speed. Track survivors near TR (need ≥1 hit).
            Frenzy endlag speed: 10 sps.
            Hit chain: 1st → 2nd → 3rd → 4th (4th downs). Can't chain same survivor twice.
            Stun or whiff = lose frenzy + short stun.
            Token system: each hit grants tokens = chain position (1,2,3,4), max 4.
            Tokens carry between frenzies. ≥3 tokens: vault dropped pallet = break it (costs 3).

    Perks
        Terror Spread (Lvl 15)
            Gen completed → all survivors Winded + killer Undetectable 20/30/40s.

        Sloppy Mess (Lvl 30)
            Basic attack → 2x bleed + 15/20/25% healing slow.
            10% healing progress lost/sec if nobody healing them.

        Resentment Clinger (Lvl 45)
            Chain = 2 tokens (max 3). Stunned = +1.
            Swing consumes 1 → lunge +30/40/50%.


    ═══════════════════════════════════════════════════════════════════════
    4. THE HIDDEN  (Subject 617)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Mark (M2)
            Switch stance, lunge forward. Hit survivors marked 10s.

        Leap (Q)
            Launch in look direction. Jumps obstacles.

    Perks
        Echo Location (Lvl 15)
            Kick gen → reveal survivors within 100 studs 3/4/5s.
            No longer targets chained.

        Enhanced Senses (Lvl 30)
            Survivor fast/medium vaults or drops pallet in intent radius → aura 4/5/6s.
            +2s all aura reads. 30s CD.

        Next in Line (Lvl 45)
            Chain survivor → reveal all survivors >120 studs from chain 6/7/8s.
            No longer targets chained.


    ═══════════════════════════════════════════════════════════════════════
    5. THE ABYSSWALKER  (Knight Artorias)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Dark Severance (M2)
            Charge horizontal slash. Run speed: 38.5 sps. Reach: 8 studs.
            Hits multiple survivors. Survivors dodge by crouching.
            Breaks dropped pallets on contact if no survivor hit.
            Post-break: full speed in 1.5s.

        Abyssal Burst (Q)
            Long windup. Wave speed: 70. Map-wide corruption burst.
            Hit survivors: highlighted + 40% slow 5s.
            Breaking pallet reduces slow to 30% for all corrupted.

    Perks
        Corrupted Path (Lvl 15)
            Hit survivor → trail that slows anyone 7% for 20/25/30s.

        Abyssal Covenant (Lvl 30)
            4 cursed chains. Trapping on cursed → highest gen explodes:
            -5/6/7% progress, additional -5/6/7% per survivor repairing it.

        Shadow Trace (Lvl 45)
            Trial start → Undetectable 30/45/60s.
            Chain survivor → Undetectable 20s.


    ═══════════════════════════════════════════════════════════════════════
    6. THE VEIL  (La Llorona)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Pierced Vow (M2)
            Switch to spears. Hold to wind up (min 0.4s).
            Max speed: 165 sps after 1s charge. 7s auto-throw.
            Headshot → Silenced 15s. 2 spears, recharge 20s each.
            Normal hit removes 5s from recharging spear.

        Through the Veil (Q)
            Charge 2s → spear transfers to another world.
            Ignores collisions, passes through walls.
            Increased throw power/distance. CD: 45s.
            Normal hit removes 5s from TtV cooldown.

    Perks
        Piercing Reverie (Lvl 15)
            First chain per survivor → block highest gen 25s.
            Reveal blocked gen + regression +50% for 60/70/80s.

        Blood Between Worlds (Lvl 30)
            Every 2 health states lost → 2 highest gens regress 90/110/130%
            for 45s (even while worked). Max 2 gens. 45s CD.

        Echo Of The Void (Lvl 45)
            Spotted by survivor 1.5/1.2/0.9s → aura 4s + monochrome.
            Can't trigger on downed or while chained. 30s CD per survivor.


    ═══════════════════════════════════════════════════════════════════════
    7. THE MASKED  (Jacket — Hotline Miami)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Mask Up (M2)
            Random mask every 30s. Lasts 60s on activation. Masks:
            Richard (default)  — no buff
            Tony (tiger)       — lethal punches, instadown, no lunge
            Brandon (panther)  — +10% haste
            Graham (rabbit)    — faster window vaults
            Richter (rat)      — Undetectable
            Jake (cobra)       — increased lunge duration
            Alex (chainsaw)    — instadown sprint, breaks pallets on contact

    Perks
        Hard Swing (Lvl 15)
            Damage survivor → Winded 20/25/30s.
            Basic attack recovery 0.4s faster.

        Combo Streak (Lvl 30)
            Basic attack → 5% speed 11/12/13s.
            Another hit during → additional boost + refresh.

        Crackdown (Lvl 45)
            4 cursed chains. Chain = 2 tokens (max 5).
            Kick gen: consume 1 → +4/7/10% damage.


    ═══════════════════════════════════════════════════════════════════════
    8. THE CURE  (SCP-049)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Elucidation (M2)
            Throw flask → pestilence cloud.
            Slows survivors up to 30% + applies Pestilence. CD: 15s.
            Each infected = +5% break/vault speed for Cure.
            Pestilence auto-removes after 90s.

        I Am The Cure (Q — on downed/corpses)
            Inject downed survivors or corpses.
            Living survivor injection per chain stage:
                Before 1st chain: 4% move slow
                After 1 chain:    6% repair slow
                After 2 chains:   transforms into SCP-049-2
            049-2 (zombie):
                9 sps base, up to 15 sps chasing pestilence survivor.
                Roams map hunting. Prioritizes chased survivor within 100 studs.
                Attacks apply pestilence. Killed by certain stuns.
                Aura always revealed to Cure. Max 4 instances.
            Corpses spawn on map. Chain = 1 charge to transform → 049-2.
            First chain = 1 charge, subsequent = 2 per charge.
            Cure starts with up to 2 049-2s (scales with survivor count).

    Perks
        Foundation Staff (Lvl 15)
            Freed from chain/self-unhook → 10/20/30% healing reduction 60s.
            Freed survivor: 15% repair penalty until healed.

        Sustenance (Lvl 30)
            Chain = 1 token. Break pallet → consume 1:
            15% slow in TR 2/3/4s + aura for duration + Silenced 20/30/35s.

        Desire For The Living (Lvl 45)
            Survivor sees your aura → you see theirs.
            Break pallet or gain speed → aura to nearest non-chained 4s. CD: 40/30/20s.


    ═══════════════════════════════════════════════════════════════════════
    9. THE BUTCHER  (Original)
    ═══════════════════════════════════════════════════════════════════════

    Powers
        Your Heart Is Mine (M2)
            Windup: 0.1s. Cast chain that latches to survivor.
            Latched: Silenced, limited distance. Butcher speed: 17.34 sps / 102%.
            Chain wraps environment. Hits wall → stays live 0.2s (bounces).
            Breaking chain w/ pallet no longer slows Butcher.
            Silence lingers after break. Self-free: 7s.
            After 5s at high tension: recast to tug chain.
            Interrupts actions, pulls toward you. Up to 3 tugs, 3rd stuns + breaks.
            Vaulting during tug = longer stun. CD: 15s.

        Tendons (Q)
            Set steel bear trap (2.5s, armed on placement).
            2 traps held, recharge 45s. Max 7 placed (8th snaps oldest).
            Running catch: ~2.4 studs. Disarm: 5s.
            Trapped: injured + stuck + revealed to killer.
            Struggle: 20s skill checks. Great = -1s. Miss = cancel + re-reveal.
            Teammate free: 7s.

    Perks
        Split The Pain (Lvl 15)
            Stunned → stun responsible survivor 11/22/33% of duration.
            Silenced all in TR 10/20/30s. Reveal auras 3/4/5s.
            While equipped: Silenced pauses item recharge. 30s CD.

        Bloodhound (Lvl 30)
            Start 1 token (max 5). Every 55/50/45s if injured exists: consume → see furthest 5s.
            Gain: 1 per health state damaged, 1 per chain.
            Walk over blood pool → see that survivor 2s.

        Rotten Stench (Lvl 45)
            Damage → 10% repair penalty 30/45/60s.
            First good skill check during → sound + aura 6s.


    ═══════════════════════════════════════════════════════════════════════
    BASEKIT CHANGES  (Nov 7)
    ═══════════════════════════════════════════════════════════════════════
    - Survivors take 0.18s to reach full speed (was 0.13)
    - Ranked only: first 40s or until killer's first hit, survivors have 20% repair slow
    - Aura perks no longer target chained survivors (see individual perks)
    - Parrying Dagger stun reduced to 2.5s (was 4)


    ═══════════════════════════════════════════════════════════════════════
    STATUS EFFECTS
    ═══════════════════════════════════════════════════════════════════════
    Vulnerable      one-hit by M1 (unless Endurance)
    Winded          no speed perks, 50% slower recovery while running
    Silenced        no items; recharge paused (w/ Split The Pain)
    Undetectable    no TR, no red stain; black clouds on survivor screen
    Endurance       no hit damage for 1 hit; 8s after unhook
    Invulnerability no damage at all for duration
    Anti-heal       no healing from others for duration
    Pestilence      049-specific; enables 049-2 tracking + speed
    Haste           speed increase (variable %)
    Slowness        speed decrease (variable %)
    Hindered        repair speed decrease (variable %)
    Hastened        repair speed increase (variable %)


    ═══════════════════════════════════════════════════════════════════════
    EXPLOIT NOTES
    ═══════════════════════════════════════════════════════════════════════
    - Stalker stalk meter likely an attribute — spoof could force Hunter Mode
    - Stalker stalk speed (12 sps) is separate from base — modifiable value
    - Frenzy token count visible on icon — trackable for dodge timing
    - Frenzy hit chain count trackable — dodge the 4th
    - Veil spears are projectiles with collision; TtV disables collision
    - Masked mask rotation is random — knowing current mask = counter-play ESP
    - Cure 049-2 count and corpse locations = high value ESP
    - Butcher YHIM chain bounces off walls (0.2s) — trajectory predictable
    - Butcher traps are placed objects — ESP + auto-disarm potential
    - Trap catch radius differs running (2.4) vs walking (smaller)
    - Cursed chains (Abyssal Covenant, Crackdown) = 4 special hooks — tag in ESP
    - Dark Severance breaks pallets — avoid early drops vs Abysswalker
    - Multiple perks grant Undetectable — proximity alert must account
    - Aura-read perks fire remotes that could be intercepted
]]

return nil
