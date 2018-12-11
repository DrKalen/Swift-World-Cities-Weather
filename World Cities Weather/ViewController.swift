//
//  ViewController.swift
//  World Cities Weather
//
//  Created by Kalen Hammann on 12/10/18.
//  Copyright © 2018 Human Family. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBAction func getWeatherButton(_ sender: UIButton) {
        cityTextField.resignFirstResponder()
        getTheWeather()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func getTheWeather() {
        self.weatherLabel.text = ""
        let desiredCity = NSString(string: cityTextField.text ?? "X").replacingOccurrences(of: " ", with: "-")
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + desiredCity + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if let error = error {
                    print(error)
                    DispatchQueue.main.sync {
                        self.weatherLabel.text = "The weather there couldn't be found. Please try again."
                    }
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        if let result = dataString {
                            if result.contains("mistyped the address") {
                                message = "The weather there couldn't be found. Please try again."
                            }
                        }
                        var stringSeparator = "Weather Today </h2>(1&ndash;3 days)</span><p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)     //should be the forecast we want!
                                }
                            }
                        } else {
                            if let result = dataString {
                                if result.contains("mistyped the address") {
                                    message = "The weather there couldn't be found. Please try again."
                                }
                            }
                        }
                        print(message)
                        print("You want the weather for \(desiredCity), is that right?")
                    }
                }
                DispatchQueue.main.sync(execute: {
                    
                    self.weatherLabel.text = message
                    
                })
            }
            task.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cityTextField.autocorrectionType = .no
    }


}

