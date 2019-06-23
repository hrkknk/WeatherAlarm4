//
//  SoundTableViewController.swift
//  WeatherAlarm
//
//  Created by nagasawa on 2019/05/11.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit

class SoundTableViewController: UITableViewController {
    
    let soundlist=["学校のチャイム01"]
    var givedata: String = ""
    var setsound = AlarmUseCase.createAlarm(date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundlist.count
    }
    
    // セルが選択された時に呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        givedata = soundlist[indexPath.row]
        AlarmUseCase.setsound(alarm: &setsound, soundName: givedata)
        AlarmUseCase.ringAlarmForcibly(alarm: setsound)
    }
    
    // セルの選択が外れた時に呼び出される
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"SoundTableViewCell", for: indexPath) as? SoundTableViewCell else{fatalError("UAAAAAAAAA")}
        cell.SoundLabel.text = soundlist[indexPath.row]
        return cell
    }
}
