import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var news: UILabel!
    
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var source: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureCell(with newsData: (String, String, String, String, String, String, String)) {
        
        news.text = newsData.0
        city.text = newsData.1
        from.text = newsData.2
        title.text = newsData.3
        content.text = newsData.4
        source.text = newsData.5
        author.text = newsData.6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

