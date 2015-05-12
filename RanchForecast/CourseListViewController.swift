
import UIKit

class CourseListViewController: UITableViewController {

    let fetcher = ScheduleFetcher()
    var courses:[Course] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: Selector("refreshControlPulled:"), forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshCourses()
    }
    
    // MARK: - Actions
    
    func refreshControlPulled(sender: UIRefreshControl) {
        refreshCourses()
    }
    
    // MARK: - Data Fetching
    
    func refreshCourses() {
        refreshControl?.beginRefreshing()
        
        fetcher.fetchCoursesUsingCompletionHandler { [weak self](result) in
            if let strongSelf = self {
                switch result {
                case .Success(let courses):
                    println("Got courses: \(courses)")
                    strongSelf.courses = courses
                case .Failure(let error):
                    println("Got error: \(error)")
                    strongSelf.courses = []
                }
                
                strongSelf.refreshControl?.endRefreshing()
                strongSelf.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! UITableViewCell
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.nextStartDateString
        cell.detailTextLabel?.text = course.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let course = courses[indexPath.row]
        UIApplication.sharedApplication().openURL(course.url)
    }
}
