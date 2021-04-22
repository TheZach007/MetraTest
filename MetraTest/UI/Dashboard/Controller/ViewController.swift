//
//  ViewController.swift
//  MetraTest
//
//  Created by Kevin Fachal on 19/04/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cloudTitle: UILabel!
    @IBOutlet weak var windTitle: UILabel!
    
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    
    
    var productArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
        
        refineView()
        
        locationField.text = "Indonesia"
        getCurrentWeather(location: "Indonesia")
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view?.endEditing(true)
        return false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.endEditing(true)
    }
    
    //MARK: TEXTFIELD
    @IBAction func locationEnd(_ sender: Any) {
        getCurrentWeather(location: locationField.text!)
    }
    
    //MARK: NETWORK SERVICE
    func getCurrentWeather(location: String) {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
        
        AF.request("http://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=0c3056177f0143c68f277c9f08a4a8f1", method: .get, encoding: JSONEncoding.default).responseJSON {
            response in switch response.result {
        case .success(let data):
            
            let json = JSON(data)
            print(json)
            
            if json["cod"].int == 200 {
                if let data = response.data {
                guard let json = try? JSON(data: data) else { return }
                self.productArray = json.arrayValue
                    for (_, subJson) in json["weather"] {
                        if let icon = subJson["icon"].string {
                            let url = URL(string:  "http://openweathermap.org/img/wn/\(icon)@2x.png")
                            let data = try? Data(contentsOf: url!)

                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                self.weatherImageView.image = image
                            }
                        }
                        if let weather = subJson["main"].string {
                            self.weatherLabel.text = "\(weather)"
                        }
                        if let desc = subJson["description"].string {
                            self.descLabel.text = "\(desc)"
                        }
                    }
                }
                
                if let temp = json["main"]["temp"].double {
                    let celc = Double(round(1000*(temp - 273.15))/1000)
                    self.temperatureLabel.text = "\(celc)° C"
                }
                
                if let cloud = json["clouds"]["all"].int {
                    self.cloudLabel.text = "\(cloud)%"
                }
                
                if let wind = json["wind"]["speed"].double {
                    self.windLabel.text = "\(wind) m/s"
                }
                
                self.showLabel()
                
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            } else {
                self.warningLabel.text = "Location not found"
                self.hideLabel()
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        case .failure(let error):
            print(error)
            }
        }
    }

    func refineView() {
        locationField.attributedPlaceholder = NSAttributedString(string: "Type Country, City, or Suburubs",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        locationField.setUnderLineEmpty()
    }
    
    func showLabel() {
        weatherImageView.isHidden = false
        weatherLabel.isHidden = false
        descLabel.isHidden = false
        temperatureLabel.isHidden = false
        cloudTitle.isHidden = false
        cloudLabel.isHidden = false
        windTitle.isHidden = false
        windLabel.isHidden = false
        warningLabel.isHidden = true
    }
    
    func hideLabel() {
        weatherImageView.isHidden = true
        weatherLabel.isHidden = true
        descLabel.isHidden = true
        temperatureLabel.isHidden = true
        cloudTitle.isHidden = true
        cloudLabel.isHidden = true
        windTitle.isHidden = true
        windLabel.isHidden = true
        warningLabel.isHidden = false
    }
}

