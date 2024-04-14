import UIKit


struct HistoryEntry {
    enum EntryType {
        case news
        case weather
        case direction
    }
    
    let type: EntryType
    let data: Any
}

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var historyEntries: [HistoryEntry] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the data source
        tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "NewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "newsCell")
        let weatherNib = UINib(nibName: "WeatherCell", bundle: nil)
        tableView.register(weatherNib, forCellReuseIdentifier: "weatherCell")
        let directionNib = UINib(nibName: "DirectionCell", bundle: nil)
        tableView.register(directionNib, forCellReuseIdentifier: "directionCell")
        
        addSampleHistoryEntries()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.cornerRadius = 8.0
    }
    
    func addSampleHistoryEntries() {
        
        let newsEntry = HistoryEntry(type: .news, data: ("News", "Toronto", "From Home", "Headline", "Once again, it\'s time to cue the melancholy piano... but as always, there are one or two silver linings along the way.", "CNN", "John Doe"))
        historyEntries.append(newsEntry)
        
        let weatherEntry = HistoryEntry(type: .weather, data: ("Weather", "London", "From Home", "2024-04-13", "7:22 PM", "25°C", "10%", "20km/h"))
        historyEntries.append(weatherEntry)
        let directionEntry = HistoryEntry(type: .direction, data: ("Directions", "Waterloo", "From News", "Waterloo", "Cambridge", "Car", "20 km"))
        historyEntries.append(directionEntry)
        let weatherEntry2 = HistoryEntry(type: .weather, data: ("Weather", "New York", "From News", "2024-04-13", "10:22 PM", "21°C", "10%", "20km/h"))
        historyEntries.append(weatherEntry2)
        let directionEntry2 = HistoryEntry(type: .direction, data: ("Directions", "Waterloo", "From Direction", "Waterloo", "Toronto", "Car", "120 km"))
        historyEntries.append(directionEntry2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = historyEntries[indexPath.row]
        
        switch entry.type {
        case .news:
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
            let newsData = entry.data as? (String, String, String, String, String, String, String)
            cell.configureCell(with: newsData!)
            return cell
        case .weather:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
            let weatherData = entry.data as? (String, String, String, String, String, String, String, String)
            cell.configureCell(with: weatherData!)
            return cell
        case .direction:
            let cell = tableView.dequeueReusableCell(withIdentifier: "directionCell", for: indexPath) as! DirectionTableViewCell
            if let directionData = entry.data as? (String, String, String, String, String, String, String) {
                cell.configureCell(with: directionData)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               historyEntries.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
    
    
}
