import Foundation

extension String {
    var year: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            let year = Calendar.current.component(.year, from: date)
            return String(year)
        }
        return nil
    }
}
