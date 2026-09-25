Config = {}
Config.PropSearchRadius = 2.0
Config.ActivationDistance = 60.0
Config.PromptDistance = 1.5
Config.DefaultMusician = 1
Config.PromptKey = 0x760A9C6F -- G
Config.LoadTimeout = 5000
Config.SpawnCheckInterval = 1000
Config.ToggleCooldown = 300
Config.Texts = {
    start = 'Commencer à jouer',
    stop = 'Arrêter de jouer',
}
Config.Musicians = {
    {
        label = 'Pianiste',
        model = 'u_m_m_galastringquartet_01',
        scenario = 'PROP_HUMAN_PIANO',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(1456.9078369140625, -7124.01123046875, 77.23350524902344, 150.0),
        props = {
            { model = 'p_benchpiano02x', offset = vector4(0.0, 0.0, 0.5, 0.0) },
        }
    },
    {
        label = 'Guitariste',
        model = 'u_m_m_nbxmusician_01', -- males only
        scenario = 'PROP_HUMAN_SEAT_CHAIR_GUITAR',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(1460.082275390625, -7119.07421875, 77.23394012451172, 40.0),
        props = {
            { model = 'p_chair24x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
        }
    },
    {
        label = 'Violoniste',
        model = 'msp_saintdenis1_females_01', --females only
        scenario = 'PROP_HUMAN_SEAT_BENCH_FIDDLE',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(1454.1, -7121.06, 78.15, 300.97),
        props = {
            { model = 'p_chair26x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
        }
    },
    {
        label = 'Guimbarde',
        model = 'a_m_m_valfarmer_01', --males only
        scenario = 'PROP_HUMAN_SEAT_BENCH_JAW_HARP',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(1464.37, -7121.77, 78.15, 40.0),
        props = {
            { model = 'p_chair16x', offset = vector4(0.0, 0.0, 0.5, 180.0) },
        }
    },
    {
        label = 'Trompette',
        model = 'a_m_m_nbxupperclass_01', --males only
        scenario = 'WORLD_HUMAN_TRUMPET',
        idleScenario = 'WORLD_HUMAN_SMOKE_CIGAR',
        position = vector4(1462.1256103515625, -7122.29296875, 77.2328872680664, 40.0),
    },
    {
        label = 'Mandoline',
        model = 'u_m_m_nbxmusician_01',
        scenario = 'PROP_HUMAN_SEAT_BENCH_MANDOLIN',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(0.0, 0.0, 0.0, 0.0),
    },
    {
        label = 'Concertina',
        model = 'u_m_m_nbxmusician_01',
        scenario = 'PROP_HUMAN_SEAT_BENCH_CONCERTINA',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(0.0, 0.0, 0.0, 0.0),
    },
    {
        label = 'Banjo',
        model = 'u_m_m_nbxmusician_01',
        scenario = 'PROP_HUMAN_SEAT_CHAIR_BANJO',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(0.0, 0.0, 0.0, 0.0),
    },
    {
        label = 'Harmonica',
        model = 'u_m_m_nbxmusician_01',
        scenario = 'PROP_HUMAN_SEAT_BENCH_HARMONICA',
        idleScenario = 'PROP_HUMAN_SEAT_CHAIR',
        position = vector4(0.0, 0.0, 0.0, 0.0),
    },
}
