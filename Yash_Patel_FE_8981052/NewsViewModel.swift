import Foundation
import Combine

class NewsViewModel: ObservableObject {
    var newsArticles: [NewsArticle] = [] {
            didSet {
                articlesHandler?(newsArticles)
            }
        }
    var articlesHandler: (([NewsArticle]) -> Void)?
    private let apiKey = "3ce7b5a503c54fcd997d21c17ca77bcf"
    
    func fetchNews(for city: String) {
            guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Failed to encode city name")
                return
            }

            guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(encodedCity)&apiKey=\(apiKey)")
        else {
                print("Invalid URL")
                return
            }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching news data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewsAPIResponse.self, from: data)
                print("Response received:", response) // Debug print
                let articles = response.articles.map {
                    NewsArticle(title: $0.title,
                                description: $0.description ?? "",
                                author: $0.author ?? "",
                                source: $0.source.name)
                }
                DispatchQueue.main.async {
                    self.newsArticles = articles
                }
            } catch {
                print("Error decoding news data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct NewsAPIResponse: Decodable {
    let articles: [Article]
    
    struct Article: Decodable {
        let title: String
        let description: String?
        let author: String?
        let source: Source
        
        struct Source: Decodable {
            let name: String
        }
    }
}

