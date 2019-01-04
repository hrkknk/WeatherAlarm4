////
////  AlarmTableViewController.swift
////  WeatherAlarm
////
////  Created by 金子宏樹 on 2018/10/26.
////  Copyright © 2018年 金子宏樹. All rights reserved.
////
//
//import UIKit
//import os.log
//import CoreLocation
//import Alamofire
//import SwiftyJSON
//
//class AlarmTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    //MARK: - Properties
//    //アラームモデル
//    var alarms = [Alarm]()
//
//    //Sunny/Rainyどっちのアラームリストを表示するか
//    var selectedWeather: String?
//
//    // 位置情報取得用オブジェクト
//    let locationManager = CLLocationManager()
//
//    // 天気予報API
//    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
//    let APP_ID = "3486f122e589efd3e860f3a10775ce47"
//
//    @IBOutlet weak var addButton: UIBarButtonItem!
//    @IBOutlet weak var alarmList: UITableView!
//
//
//    //MARK: - Actions
//
//    @IBAction func selectSunny(_ sender: UIButton) {
//        self.selectedWeather = "Sunny"
//    }
//
//    @IBAction func selectRainy(_ sender: UIButton) {
//        self.selectedWeather = "Rainy"
//    }
//
//    //AlarmViewController画面のsaveButtonを押して戻ってきた時の処理
//    @IBAction func unwindToAlarmList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.source as? AlarmViewController, let alarm = sourceViewController.alarm {
//            if let selectedIndexPath = alarmList.indexPathForSelectedRow {
//                // Update an existing alarm.
//                alarms[selectedIndexPath.row] = alarm
//                alarmList.reloadRows(at: [selectedIndexPath], with: .none)
//            } else {
//                // Add a new alarm.
//                let newIndexPath = IndexPath(row: alarms.count, section: 0)
//
//                alarms.append(alarm)
//                alarmList.insertRows(at: [newIndexPath], with: .automatic)
//            }
//            saveAlarms()
//            //画面遷移する前に編集モード解除
//            setEditing(false, animated: false)
//        }
//    }
//
//    //MARK: - Methods
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //TODO: 前回アプリを閉じた時にSunny/Rainyどっちを選択していたか記憶しておく
//        self.selectedWeather = "Sunny"
//
//        // 位置情報取得のためのデリゲート
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//
//        //selectedWeatherと一致するアラームだけモデルに追加
//        addAlarmsOfSelectedWeather(alarms)
//
//        //ナビゲーションバーの左上にeditボタンを表示
//        navigationItem.leftBarButtonItem = editButtonItem
//
//        //保存データがある場合、それを読み込む
//        if let savedAlarms = loadAlarms() {
//            alarms += savedAlarms
//        } else {
//            // Load the sample data.
//            alarms += loadSampleAlarms()
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        //アラーム未登録の場合、Editボタンは無効化
//        if alarms.count <= 0 {
//            editButtonItem.isEnabled = false
//        } else {
//            editButtonItem.isEnabled = true
//        }
//
//        //アラーム再表示
//        for cell in getAllCells() {
//            cell.timeLabel.text = alarms[cell.getRow()].getDateAsString()
//        }
//    }
//
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//
//        //Edit中はAddボタンを無効化(その逆は逆)
//        addButton.isEnabled = !editing
//
//        //Edit中はON/OFFスイッチを無効化(その逆は逆)
//        //        if (editing) {
//        for cell in getAllCells() {
//            cell.isOnSwitch.isHidden = editing
//        }
//        //        }
//        alarmList.isEditing = editing
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // Networking
//    func getWeatherData(url: String, geoCoordinatesInfo: [String : String]) {
//        Alamofire.request(url, method: .get, parameters: geoCoordinatesInfo).responseJSON {
//            response in
//            if response.result.isSuccess {
//                print("Success! Got the weather data")
//
//                // response.result.valueはオプショナル型だが、if文で結果を確認しているのでforce unwrappedしてよい
//                let weatherJSON: JSON = JSON(response.result.value!)
//                print(weatherJSON)
//
//                // クロージャの中でメソッドを呼び出すにはself句を呼び出すメソッドの前につける必要あり
//                self.parsingJSON(json: weatherJSON)
//
//            } else {
//                print("Error \(String(describing: response.result.error))")
//            }
//        }
//    }
//
//    func parsingJSON(json: JSON) {
//        print(json["weather"][0]["main"].stringValue)
//        print(json["name"].stringValue)
//    }
//
//
//    // MARK: - Table view data source
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        //TODO: あとで変えるかも？
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return alarms.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as? AlarmTableViewCell else {
//            fatalError("AlarmTableViewCell型じゃないよ！")
//        }
//
//        let alarm = alarms[indexPath.row]
//
//        cell.timeLabel.text = alarm.getDateAsString()
//        cell.delegate = self
//
//        //自分のRowが何番目かCell側に記憶しておく
//        cell.setRow(row: indexPath.row)
//
//        return cell
//    }
//
//    //編集モード
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            //アラームを削除
//            alarms.remove(at: indexPath.row)
//            saveAlarms()
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        //編集モードでない時はEditAlarmのsegueをOFFにする
//        if !alarmList.isEditing && identifier == "EditAlarm" {
//            return false
//        }
//
//        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
//    }
//
//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        switch(segue.identifier ?? "") {
//        case "AddAlarm": //"Add"ボタンによる画面遷移の場合
//            //UINavigationControllerを取得
//            guard let navigationController = segue.destination as? UINavigationController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            //UINavigationControllerの次の画面(WeatherViewController)を取得
//            guard let alarmViewController = navigationController.topViewController as? AlarmViewController else {
//                fatalError("Unexpected topViewController: \(String(describing: navigationController.topViewController))")
//            }
//
//            //次の画面(AlarmViewController)のデフォルトWeatherにSunny/Rainyをセット
//            alarmViewController.weatherOfPreviousView = self.selectedWeather!
//
//        case "EditAlarm": //編集モードでアラームセルをタップして画面遷移する場合
//            guard let alarmViewController = segue.destination as? AlarmViewController else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//
//            //タップしたアラームセルを取得
//            guard let selectedAlarmCell = sender as? AlarmTableViewCell else {
//                fatalError("Unexpected sender: \(String(describing: sender))")
//            }
//
//            //アラームセルのindexPathを取得
//            guard let indexPath = alarmList.indexPath(for: selectedAlarmCell) else {
//                fatalError("The selected cell is not being displayed by the table")
//            }
//
//            //indexPathを元に、対象のモデルを取得してセット
//            alarmViewController.alarm = alarms[indexPath.row]
//
//        default:
//            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
//        }
//    }
//
//
//    //MARK: - Private Methods
//
//    fileprivate func addAlarmsOfSelectedWeather(_ alarms: [Alarm]) {
//        for alarm in alarms {
//            if alarm.weather == self.selectedWeather {
//                self.alarms += [alarm]
//            }
//        }
//    }
//
//    //全てのセルを取得する
//    private func getAllCells() -> [AlarmTableViewCell] {
//        var cells = [AlarmTableViewCell]()
//
//        //TODO: 煩雑だからなんとかする
//        for i in 0...alarmList.numberOfSections - 1 {
//            for j in 0...alarmList.numberOfRows(inSection: i) {
//                if let cell = alarmList.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath) {
//                    cells.append(cell as! AlarmTableViewCell)
//                }
//            }
//        }
//        return cells
//    }
//
//
//    private func saveAlarms() {
//        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(alarms, toFile: Alarm.ArchiveURL.path)
//        if isSuccessfulSave {
//            os_log("Alarms successfully saved.", log: OSLog.default, type: .debug)
//        } else {
//            os_log("Failed to save alarms...", log: OSLog.default, type: .error)
//        }
//    }
//
//    private func loadAlarms() -> [Alarm]?  {
//        return NSKeyedUnarchiver.unarchiveObject(withFile: Alarm.ArchiveURL.path) as? [Alarm]
//    }
//
//    //TODO: テスト用。あとで消すこと
//    private func loadSampleAlarms() -> [Alarm] {
//
//        guard let sampleAlarm1 = Alarm(time: Date(), weather: "Sunny") else {
//            fatalError("Unable to instantiate alarm2")
//        }
//
//        guard let sampleAlarm2 = Alarm(time: Date(), weather: "Rainy") else {
//            fatalError("Unable to instantiate alarm2")
//        }
//
//        guard let sampleAlarm3 = Alarm(time: Date(), weather: "Rainy") else {
//            fatalError("Unable to instantiate alarm3")
//        }
//
//        return [sampleAlarm1, sampleAlarm2, sampleAlarm3]
//    }
//}
//
