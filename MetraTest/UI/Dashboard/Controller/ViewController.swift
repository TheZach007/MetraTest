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
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: TEXTFIELD
    
    
    //MARK: NETWORK SERVICE
    func getCurrentWeather() {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        AF.request("", method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in switch response.result {
        case .success(let data):
            print(data)
        case .failure(let error):
            print(error)
            }
        }
    }

    func refineView() {
        
    }
}

