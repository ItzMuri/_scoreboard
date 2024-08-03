Cfg = Cfg or {}

Cfg.Data = {
    Framework = {
        ['coreName'] = 'qb-core',
        ['triggerName'] = 'QBCore',
    },

    Settings = {
        serverName = 'Muri',
        maxPlayers = 64,

        openKey = 'HOME', -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        toggle = true
    },

    locales = {
        ['duty'] = 'Duty',
        ['job_title'] = 'Job Title',
        ['job_rank'] = 'Rank',
        ['robberies'] = 'Robberies',
        ['status'] = 'Status',
        ['city_activity'] = 'City Activity',
    },

    copLevel = {
        [1] = 1,
        [2] = 3,
        [3] = 5
    },

    illegalActions = {
        ['storerobbery'] = {minimumPolice = 2, busy = false, label = 'Store Robbery'},
        ['bankrobbery'] = {minimumPolice = 3, busy = false, label = 'Bank Robbery'},
        ['jewellery'] = {minimumPolice = 2, busy = false, label = 'Jewellery'},
        ['pacific'] = {minimumPolice = 5, busy = false, label = 'Pacific Bank'},
        ['paleto'] = {minimumPolice = 4, busy = false, label = 'Paleto Bay Bank'},
        ['atm'] = {minimumPolice = 1, busy = false, label = 'Atm Robbery'},
        ['yacht'] = {minimumPolice = 9, busy = false, label = 'Yacht Heist'}
    }
}
