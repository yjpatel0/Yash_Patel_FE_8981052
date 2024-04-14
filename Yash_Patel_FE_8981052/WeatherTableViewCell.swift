import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var weather: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with data: (String, String, String, String, String, String, String, String)) {
            weather.text = data.0
            city.text = data.1
            source.text = data.2
            date.text = data.3
            time.text = data.4
            temp.text = data.5
            humidity.text = data.6
            wind.text = data.7
        }

}

