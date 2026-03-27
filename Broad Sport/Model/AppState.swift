import Foundation

private struct SportEntryDTO: Codable {
    let sportName: String
    let cost: String
    let timePerWeek: String
    let load: String
    let availability: String
    let equipment: String
    let trainer: String
}

class AppState: ObservableObject {
    @Published var mySports: [SportEntry] = []
    @Published var comparisonSelection: [SportEntry] = []
    @Published var trainings: [Training] = []

    init() {
        loadMySports()
        loadTrainings()
    }

    func add(_ entry: SportEntry) {
        guard !isAdded(entry.sport) else { return }
        mySports.append(entry)
        saveMySports()
    }

    func remove(_ sport: Sport) {
        mySports.removeAll { $0.sport.id == sport.id }
        comparisonSelection.removeAll { $0.sport.id == sport.id }
        saveMySports()
    }

    func update(_ entry: SportEntry) {
        if let index = mySports.firstIndex(where: { $0.id == entry.id }) {
            mySports[index] = entry
            saveMySports()
        }
    }

    func isAdded(_ sport: Sport) -> Bool {
        mySports.contains { $0.sport.id == sport.id }
    }

    func toggleComparison(_ entry: SportEntry) {
        if let index = comparisonSelection.firstIndex(where: { $0.id == entry.id }) {
            comparisonSelection.remove(at: index)
        } else if comparisonSelection.count < 2 {
            comparisonSelection.append(entry)
        }
    }

    func isSelectedForComparison(_ entry: SportEntry) -> Bool {
        comparisonSelection.contains(where: { $0.id == entry.id })
    }

    func addTraining(_ training: Training) {
        trainings.append(training)
        saveTrainings()
    }

    func removeTraining(_ training: Training) {
        trainings.removeAll { $0.id == training.id }
        saveTrainings()
    }

    func trainings(for date: Date?) -> [Training] {
        guard let date else { return [] }
        let cal = Calendar.current
        return trainings.filter { cal.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.startTime < $1.startTime }
    }

    func hasTrainings(on date: Date) -> Bool {
        !trainings(for: date).isEmpty
    }

    private func saveTrainings() {
        if let data = try? JSONEncoder().encode(trainings) {
            UserDefaults.standard.set(data, forKey: "trainings")
        }
    }

    private func loadTrainings() {
        guard
            let data = UserDefaults.standard.data(forKey: "trainings"),
            let decoded = try? JSONDecoder().decode([Training].self, from: data)
        else { return }
        trainings = decoded
    }

    private func saveMySports() {
        let dtos = mySports.map { e in
            SportEntryDTO(
                sportName: e.sport.name,
                cost: e.cost,
                timePerWeek: e.timePerWeek,
                load: e.load,
                availability: e.availability,
                equipment: e.equipment,
                trainer: e.trainer
            )
        }
        if let data = try? JSONEncoder().encode(dtos) {
            UserDefaults.standard.set(data, forKey: "mySports")
        }
    }

    private func loadMySports() {
        guard
            let data = UserDefaults.standard.data(forKey: "mySports"),
            let dtos = try? JSONDecoder().decode([SportEntryDTO].self, from: data)
        else { return }

        mySports = dtos.compactMap { dto in
            guard let sport = Sport.all.first(where: { $0.name == dto.sportName }) else { return nil }
            return SportEntry(
                sport: sport,
                cost: dto.cost,
                timePerWeek: dto.timePerWeek,
                load: dto.load,
                availability: dto.availability,
                equipment: dto.equipment,
                trainer: dto.trainer
            )
        }
    }
}
