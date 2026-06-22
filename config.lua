Config = {}

Config.command = "car"

Config.spawnPoints = {
    vector4(441.2, -1018.7, 28.7, 90.0),
    vector4(450.3, -1025.1, 28.6, 90.0),
    vector4(460.1, -1032.5, 28.6, 90.0),
}

Config.categories = {

    POL = {
        label = "Politie",
        vehicles = {
            { label = "Police Cruiser", model = "police" },
            { label = "Sultan Patrol", model = "sultan" },
        }
    },

    BRW = {
        label = "Brandweer",
        vehicles = {
            { label = "Fire Truck", model = "firetruk" },
        }
    },

    AMB = {
        label = "Ambulance",
        vehicles = {
            { label = "Ambulance", model = "ambulance" },
        }
    },

    BUR = {
        label = "Burger",
        vehicles = {
            { label = "Adder", model = "adder" },
            { label = "BMX", model = "bmx" },
        }
    }
}