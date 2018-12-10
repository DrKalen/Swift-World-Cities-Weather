//
//  ViewController.swift
//  World Cities Weather
//
//  Created by Kalen Hammann on 12/10/18.
//  Copyright © 2018 Human Family. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBAction func getWeatherButton(_ sender: UIButton) {
        let desiredCity = NSString(string: cityTextField.text ?? "X").replacingOccurrences(of: " ", with: "-")
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + desiredCity + "/forecasts/latest") {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                if let error = error {
                    print(error)
                    DispatchQueue.main.sync {
                        print("The weather there couldn't be found. Please try again")
                    }
                } else {
                    if let unwrappedData = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        print(dataString ?? "Didn't work!")
                        DispatchQueue.main.sync {
                            print("You want the weather for \(desiredCity), is that right?")
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

