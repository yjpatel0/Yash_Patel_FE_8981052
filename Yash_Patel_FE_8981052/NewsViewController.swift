import UIKit
import CoreLocation


class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var newsArticles: [NewsArticle] = []
    private let newsViewModel = NewsViewModel()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.rowHeight = 170
        fetchNews(for: "Waterloo")
        newsViewModel.articlesHandler = { [weak self] articles in
            self?.newsArticles = articles
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
    
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Where would you like to go", message: "Enter your new destination here", preferredStyle: .alert)
    
        alertController.addTextField { textField in
            textField.placeholder = "City"
        }
    
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, let city = textField.text else { return }
            self?.fetchNews(for: city)
        }
        alertController.addAction(confirmAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTabTableViewCell
        let article = newsArticles[indexPath.row]
        
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.gray.cgColor
            cell.contentView.layer.cornerRadius = 8.0

        cell.title.text = article.title
        cell.news.text = article.description
        cell.author.text = "Author: \(article.author)"
        cell.source.text = "Source: \(article.source)"
        
        return cell
    }
    
    func fetchNews(for city: String) {
        newsViewModel.fetchNews(for: city)
    }
    
}

