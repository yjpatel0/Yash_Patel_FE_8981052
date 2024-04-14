import UIKit
import CoreLocation

class WeatherViewController: UIViewController , CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @IBOutlet weak var plusButton: UIBarButtonItem!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelWeather: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelWind: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentLocation = manager.location else {
            print("Error: Unable to retrieve current location.")
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found.")
                return
            }
            if let city = placemark.locality {
                print("Current city: \(city)")
                self.makeAPICalltoGetData(for: city)
            } else {
                print("City name not found.")
            }
        }

    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter City Name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "City Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let textField = alertController.textFields?.first, let cityName = textField.text {
                self?.makeAPICalltoGetData(for: cityName)
            }
        }
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func makeAPICalltoGetData(for cityName: String) {

        guard let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName)&appid=d3f0956caa7ad29a06e029f9a9cb7c0e") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) ?? "No data")
                    
                    let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.updateLabels(weather: jsonData)
                    }
                } catch {
                    print("Error decoding data.")
                }
            } else {
                print("Error getting data from server.")
            }
        }
        task.resume()
    }
    func getImage(icon: String) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
        
            if let data = data {
                DispatchQueue.main.async {
                    self.imageIcon.image = UIImage(data: data)
                }
            } else {
                print("Error getting icon from server.")
            }
        }
        task.resume()
    }
    func updateLabels(weather: Weather) {
        let name = weather.name
        let weatherText = weather.weather[0].main
        let icon = weather.weather[0].icon
        let temp = Int(weather.main.temp - 273.15)
        let humidity = weather.main.humidity
        let wind = weather.wind.speed
        labelLocation.text = name
        labelWeather.text = weatherText
        labelTemp.text = "\(temp)°"
        labelHumidity.text = "Humidity: \(humidity)%"
        labelWind.text = "Wind: \(wind) km/h"
        getImage(icon: icon)
    }
}
