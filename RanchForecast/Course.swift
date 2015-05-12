
import Foundation

public class Course: NSObject, Equatable {
    public let title: String
    public let url: NSURL
    public let nextStartDate: NSDate
    private let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    public var nextStartDateString: String {
        return dateFormatter.stringFromDate(nextStartDate)
    }
    
    public init(title: String, url: NSURL, nextStartDate: NSDate) {
        self.title = title
        self.url = url
        self.nextStartDate = nextStartDate
        super.init()
    }
}

extension Course: Printable {
    override public var description: String {
        return "<Course: \"\(title)\" on \(nextStartDateString) via \(url.lastPathComponent)>"
    }
}

public func ==(lhs: Course, rhs: Course) -> Bool {
    let equalTitles = lhs.title == rhs.title
    let equalURLs = lhs.url == rhs.url
    let equalStartDates = lhs.nextStartDate == rhs.nextStartDate
    let result = equalTitles && equalURLs && equalStartDates
    return result
}
