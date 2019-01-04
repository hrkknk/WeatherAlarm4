//
//  AlarmStandbyViewController.swift
//  WeatherAlarm
//
//  Created by 金子宏樹 on 2019/01/04.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit

class AlarmStandbyViewController: UIViewController {
    
    //TODO: Stringじゃなく、Alarm型で受け渡す(後でdate型が必要になるので、、)
    var sunnyAlarmTimeString: String?
    var rainyAlarmTimeString: String?
    @IBOutlet weak var sunnyAlarmTime: UILabel!
    @IBOutlet weak var rainyAlarmTime: UILabel!
    
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //前の画面(AlarmViewController)のprepare()で渡してもらったdate情報をラベルにセット
        sunnyAlarmTime.text = sunnyAlarmTimeString
        rainyAlarmTime.text = rainyAlarmTimeString

        // Do any additional setup after loading the view.
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
