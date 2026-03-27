import Foundation

struct Sport: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let category: String
    let description: String
    let imageName: String
    let cost: String
    let timePerWeek: String
    let load: String
    let availability: String
    let equipment: String
    let trainer: String

    static let all: [Sport] = [
        Sport(name: "Boxing",              category: "Combat Sports", description: "Strike techniques, defense, high cardio load",    imageName: "img_boxing",        cost: "Medium", timePerWeek: "2-3x", load: "High",   availability: "Medium", equipment: "Low",    trainer: "Yes"),
        Sport(name: "Swimming",            category: "Water",         description: "Full body workout, low injury risk",              imageName: "img_swimming",      cost: "Low",    timePerWeek: "3-4x", load: "Medium", availability: "High",   equipment: "Low",    trainer: "No"),
        Sport(name: "Yoga",                category: "Flexibility",   description: "Stretching, balance, mental clarity",            imageName: "img_yoga",          cost: "Low",    timePerWeek: "3-5x", load: "Low",    availability: "High",   equipment: "Low",    trainer: "No"),
        Sport(name: "Running",             category: "Cardio",        description: "Accessibility, endurance development, outdoors", imageName: "img_running",       cost: "Low",    timePerWeek: "4-5x", load: "Medium", availability: "High",   equipment: "Low",    trainer: "No"),
        Sport(name: "Football",            category: "Team Sports",   description: "Teamwork, running, tactics",                    imageName: "img_football",      cost: "Low",    timePerWeek: "3-4x", load: "High",   availability: "Medium", equipment: "Low",    trainer: "No"),
        Sport(name: "Tennis",              category: "Team Sports",   description: "Coordination, reaction, singles or doubles",    imageName: "img_tennis",        cost: "Medium", timePerWeek: "2-3x", load: "Medium", availability: "Medium", equipment: "Medium", trainer: "Optional"),
        Sport(name: "Cycling",             category: "Cyclical",      description: "Leg endurance, rides or tracks",                imageName: "img_cycling",       cost: "High",   timePerWeek: "3-4x", load: "Medium", availability: "High",   equipment: "High",   trainer: "No"),
        Sport(name: "Gym",                 category: "Strength",      description: "Weight training, muscle hypertrophy",           imageName: "img_gym",           cost: "Medium", timePerWeek: "4-5x", load: "High",   availability: "High",   equipment: "High",   trainer: "Optional"),
        Sport(name: "CrossFit",            category: "Functional",    description: "High intensity, mix of disciplines",            imageName: "img_crossfit",      cost: "High",   timePerWeek: "3-5x", load: "High",   availability: "Medium", equipment: "High",   trainer: "Yes"),
        Sport(name: "Muay Thai",           category: "Combat Sports", description: "Thai boxing, elbows and knees",                 imageName: "img_muaythai",      cost: "Medium", timePerWeek: "2-3x", load: "High",   availability: "Medium", equipment: "Medium", trainer: "Yes"),
        Sport(name: "Brazilian Jiu-Jitsu", category: "Combat Sports", description: "Ground fighting, submissions, technique",       imageName: "img_bjj",           cost: "Medium", timePerWeek: "2-4x", load: "High",   availability: "Medium", equipment: "Low",    trainer: "Yes"),
        Sport(name: "Volleyball",          category: "Team Sports",   description: "Jumping, teamwork, ball",                      imageName: "img_volleyball",    cost: "Low",    timePerWeek: "2-3x", load: "Medium", availability: "Medium", equipment: "Low",    trainer: "No"),
        Sport(name: "Basketball",          category: "Team Sports",   description: "Running, shooting, coordination, team",         imageName: "img_basketball",    cost: "Low",    timePerWeek: "3-4x", load: "High",   availability: "High",   equipment: "Low",    trainer: "No"),
        Sport(name: "Skiing",              category: "Winter",        description: "Endurance, fresh air, seasonal",               imageName: "img_skiing",        cost: "High",   timePerWeek: "1-2x", load: "High",   availability: "Low",    equipment: "High",   trainer: "Optional"),
        Sport(name: "Snowboarding",        category: "Winter",        description: "Balance, speed, mountain slopes",              imageName: "img_snowboarding",  cost: "High",   timePerWeek: "1-2x", load: "High",   availability: "Low",    equipment: "High",   trainer: "Optional"),
        Sport(name: "Rock Climbing",       category: "Extreme",       description: "Grip strength, route logic, walls",            imageName: "img_climbing",      cost: "Medium", timePerWeek: "2-3x", load: "High",   availability: "Medium", equipment: "Medium", trainer: "Optional"),
        Sport(name: "Rowing",              category: "Water",         description: "Back, arms, endurance, boat",                  imageName: "img_rowing",        cost: "High",   timePerWeek: "3-4x", load: "High",   availability: "Low",    equipment: "High",   trainer: "Yes"),
        Sport(name: "Equestrian",          category: "Contact",       description: "Animal interaction, posture",                  imageName: "img_equestrian",    cost: "High",   timePerWeek: "2-3x", load: "Medium", availability: "Low",    equipment: "High",   trainer: "Yes"),
        Sport(name: "Golf",                category: "Precision",     description: "Walking, focus, club strikes",                 imageName: "img_golf",          cost: "High",   timePerWeek: "2-3x", load: "Low",    availability: "Medium", equipment: "High",   trainer: "Optional"),
        Sport(name: "Rugby",               category: "Contact",       description: "Physical struggle, team, oval ball",           imageName: "img_rugby",         cost: "Low",    timePerWeek: "3-4x", load: "High",   availability: "Medium", equipment: "Medium", trainer: "No"),
        Sport(name: "Fencing",             category: "Speed",         description: "Reaction, tactics, weapon duels",              imageName: "img_fencing",       cost: "Medium", timePerWeek: "2-3x", load: "Medium", availability: "Low",    equipment: "High",   trainer: "Yes"),
        Sport(name: "Archery",             category: "Precision",     description: "Focus, breathing, statics",                   imageName: "img_archery",       cost: "Medium", timePerWeek: "2-3x", load: "Low",    availability: "Low",    equipment: "High",   trainer: "Yes"),
        Sport(name: "Surfing",             category: "Water",         description: "Balance, wave, ocean, seasonal",              imageName: "img_surfing",       cost: "High",   timePerWeek: "2-3x", load: "Medium", availability: "Low",    equipment: "High",   trainer: "Optional"),
        Sport(name: "Skateboarding",       category: "Street",        description: "Balance, tricks, urban environment",           imageName: "img_skateboarding", cost: "Medium", timePerWeek: "3-4x", load: "Medium", availability: "High",   equipment: "Medium", trainer: "No"),
        Sport(name: "Triathlon",           category: "Multi-sport",   description: "Swim + bike + run, ultra endurance",           imageName: "img_triathlon",     cost: "High",   timePerWeek: "5-6x", load: "High",   availability: "Medium", equipment: "High",   trainer: "Optional"),
        Sport(name: "Weightlifting",       category: "Strength",      description: "Snatch, clean & jerk, max weights",            imageName: "img_weightlifting", cost: "Medium", timePerWeek: "3-4x", load: "High",   availability: "Medium", equipment: "High",   trainer: "Yes"),
        Sport(name: "Pilates",             category: "Recovery",      description: "Core, deep muscles, rehabilitation",           imageName: "img_pilates",       cost: "Medium", timePerWeek: "2-3x", load: "Low",    availability: "High",   equipment: "Low",    trainer: "Yes"),
        Sport(name: "Zumba",               category: "Dance",         description: "Cardio, rhythm, fun group",                   imageName: "img_zumba",         cost: "Low",    timePerWeek: "2-3x", load: "Medium", availability: "High",   equipment: "Low",    trainer: "No"),
        Sport(name: "Badminton",           category: "Speed",         description: "Reaction, racket, shuttlecock, court",         imageName: "img_badminton",     cost: "Low",    timePerWeek: "2-3x", load: "Medium", availability: "High",   equipment: "Low",    trainer: "No"),
        Sport(name: "Hockey",              category: "Winter/Ice",    description: "Skating, stick, team, contact",               imageName: "img_hockey",        cost: "High",   timePerWeek: "3-4x", load: "High",   availability: "Low",    equipment: "High",   trainer: "Yes"),
    ]
}
