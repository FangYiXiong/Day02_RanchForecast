
import Foundation

class ScheduleFetcher {
    
    enum FetchCoursesResult {
        case Success([Course])
        case Failure(NSError)
    }
    
    let session: NSURLSession
    
    init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: config)
    }

    func fetchCoursesUsingCompletionHandler(completionHandler: (FetchCoursesResult) -> (Void)) {
        let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.json")!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            var result: FetchCoursesResult
            if data == nil {
                result = .Failure(error)
            }
            else if let response = response as? NSHTTPURLResponse {
                println("Received \(data.length) bytes with status code \(response.statusCode).")
                if response.statusCode == 200 {
                    result = self.resultFromData(data)
                }
                else {
                    let error = self.errorWithCode(1, localizedDescription: "Bad status code \(response.statusCode)")
                    result = .Failure(error)
                }
            }
            else {
                let error = self.errorWithCode(1, localizedDescription: "Unexpected response object.")
                result = .Failure(error)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({
                completionHandler(result)
            })
        })
        task.resume()
    }
    
    func resultFromData(data: NSData) -> FetchCoursesResult {
        var error: NSError?
        let topLevelDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as! NSDictionary?
        if let topLevelDict = topLevelDict {
            let courseDicts = topLevelDict["courses"] as! [NSDictionary]
            var courses:[Course] = []
            for courseDict in courseDicts {
                if let course = courseFromDictionary(courseDict) {
                    courses.append(course)
                }
            }
            return .Success(courses)
        }
        else {
            return .Failure(error!)
        }
    }
    
    func courseFromDictionary(courseDict: NSDictionary) -> Course? {
        let title = courseDict["title"] as! String
        let urlString = courseDict["url"] as! String
        let upcomingArray = courseDict["upcoming"] as! [NSDictionary]
        let nextUpcomingDict = upcomingArray.first!
        let nextStartDateString = nextUpcomingDict["start_date"] as! String
        
        let url = NSURL(string: urlString)!
        
        var df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let nextStartDate = df.dateFromString(nextStartDateString)!
        
        return Course(title: title, url: url, nextStartDate: nextStartDate)
    }
    
    func errorWithCode(code: Int, localizedDescription: String) -> NSError {
        return NSError(domain: "ScheduleFetcher", code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
    
}


