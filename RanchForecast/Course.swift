
import Foundation

class Course: NSObject {
    let title: String
    let url: NSURL
    let nextStartDate: NSDate
    private let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    var nextStartDateString: String {
        return dateFormatter.stringFromDate(nextStartDate)
    }
    
    init(title: String, url: NSURL, nextStartDate: NSDate) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
}

extension Course: Printable {
    override var description: String {
        return "<Course: \"\(title)\" on \(nextStartDateString) via \(url.lastPathComponent)>"
    }
}
