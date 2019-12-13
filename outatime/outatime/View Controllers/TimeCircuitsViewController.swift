//
//  TimeCircuitsViewController.swift
//  outatime
//
//  Created by patelpra on 12/11/19.
//  Copyright © 2019 Crus Technologies. All rights reserved.
//

import UIKit

class TimeCircuitsViewController: UIViewController {
    
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var presentTimeLabel: UILabel!
    @IBOutlet weak var lastTimeDepartedLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss:SS"
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return dateFormatter
    }()
    
    var currentSpeed = 0
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ModalDestinationDatePickerSegue" {
            if let datePickerVC = segue.destination as? DatePickerViewController {
                datePickerVC.delegate = self
            }
        }
    }
    
    @IBAction func travelBackButtonTapped(_ sender: Any) {
        if destinationTimeLabel.text != presentTimeLabel.text {
            startTimer()
        } else {
            let alert = UIAlertController(title: "Time Travel Failed", message: "You are already in \(destinationTimeLabel.text!)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: updateSpeed(time:))
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateSpeed(time: Timer) {
        if currentSpeed >= 88 {
            resetTimer()
            lastTimeDepartedLabel.text = presentTimeLabel.text
            presentTimeLabel.text = destinationTimeLabel.text
            currentSpeed = 0
            speedLabel.text = "\(currentSpeed) MPH"
            showAlert()
        } else {
            currentSpeed += 1
            speedLabel.text = "\(currentSpeed) MPH"
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Time Travel Successful", message: "You are now in \(presentTimeLabel.text!)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    

}

extension TimeCircuitsViewController: DatePickerDelegate {
    func destinationDateWasChosen(date: Date) {
        destinationTimeLabel.text = dateFormatter.string(from: date)
    }
}
