import Foundation

struct SportEntry: Identifiable, Equatable {
    let id: UUID
    let sport: Sport
    var cost: String
    var timePerWeek: String
    var load: String
    var availability: String
    var equipment: String
    var trainer: String

    init(
        id: UUID = UUID(),
        sport: Sport,
        cost: String,
        timePerWeek: String,
        load: String,
        availability: String,
        equipment: String,
        trainer: String
    ) {
        self.id = id
        self.sport = sport
        self.cost = cost
        self.timePerWeek = timePerWeek
        self.load = load
        self.availability = availability
        self.equipment = equipment
        self.trainer = trainer
    }
}
