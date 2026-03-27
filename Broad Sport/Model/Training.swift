import Foundation

struct Training: Identifiable, Codable {
    let id: UUID
    let date: Date
    let startTime: Date
    let endTime: Date
    let sportName: String
    let location: String
    let repeatType: String

    init(
        id: UUID = UUID(),
        date: Date,
        startTime: Date,
        endTime: Date,
        sportName: String,
        location: String,
        repeatType: String
    ) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.sportName = sportName
        self.location = location
        self.repeatType = repeatType
    }
}
