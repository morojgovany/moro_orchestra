Config = {}
Config.PropSearchRadius = 2.0
Config.ActivationDistance = 60.0
Config.PromptDistance = 1.5
Config.DefaultMusicians = {
    ['group1'] = 1,
}
Config.PromptKey = 0x760A9C6F -- G
Config.LoadTimeout = 5000
Config.SpawnCheckInterval = 1000
Config.ToggleCooldown = 300
Config.Texts = {
    start = 'Start playing',
    stop = 'Stop playing',
}
Config.Musicians = {
    ['group1'] = {
        {
            label = 'Piano',
            model = 'u_m_m_galastringquartet_01',
            scenario = 'PROP_HUMAN_PIANO',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_benchpiano02x', offset = vector4(0.0, 0.0, 0.5, 0.0) },
            }
        },
        {
            label = 'Guitar',
            model = 'u_m_m_nbxmusician_01', -- males only
            scenario = 'PROP_HUMAN_SEAT_CHAIR_GUITAR',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair24x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        },
        {
            label = 'Fiddle',
            model = 'msp_saintdenis1_females_01', --females only
            scenario = 'PROP_HUMAN_SEAT_BENCH_FIDDLE',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair26x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        },
        {
            label = 'Jawharp',
            model = 'a_m_m_valfarmer_01', --males only
            scenario = 'PROP_HUMAN_SEAT_BENCH_JAW_HARP',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair16x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        },
        {
            label = 'Trumpet',
            model = 'a_m_m_nbxupperclass_01', --males only
            scenario = 'WORLD_HUMAN_TRUMPET',
            idleScenario = 'WORLD_HUMAN_SMOKE_CIGAR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
        },
        {
            label = 'Mandolin',
            model = 'CS_BRONTE',
            scenario = 'PROP_HUMAN_SEAT_BENCH_MANDOLIN',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair11x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        },
        {
            label = 'Concertina',
            model = 'CS_MARSHALL_THURWELL',
            scenario = 'PROP_HUMAN_SEAT_BENCH_CONCERTINA',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair09x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        },
        {
            label = 'Banjo',
            model = 'CS_MP_MOONSHINER',
            scenario = 'PROP_HUMAN_SEAT_CHAIR_BANJO',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair18x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        },
        {
            label = 'Harmonica',
            model = 'cs_baptiste',
            scenario = 'PROP_HUMAN_SEAT_BENCH_HARMONICA',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_chair15x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
            }
        }
    },
    ['group2'] = {
        {
            label = 'Piano',
            model = 'CS_LUCANAPOLI',
            scenario = 'PROP_HUMAN_PIANO',
            idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
            position = vector4(0.0, 0.0, 0.0, 0.0),
            props = {
                { model = 'p_benchpiano02x', offset = vector4(0.0, 0.0, 0.5, 0.0) },
            }
        },
    },
}
