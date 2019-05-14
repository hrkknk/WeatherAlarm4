//
//  LocationAgreementViewController.swift
//  WeatherAlarm
//
//  Created by Ryo Fujimoto on 2019/05/12.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit

class LocationAgreementViewController: UIViewController {

    @IBOutlet weak var locationAgreementModal: UIView!
    @IBAction func openSettings(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    @IBAction func closeLocationAgreement(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        locationAgreementModal.layer.cornerRadius = 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
