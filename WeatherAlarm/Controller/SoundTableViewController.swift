//
//  SoundTableViewController.swift
//  WeatherAlarm
//
//  Created by nagasawa on 2019/05/11.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit
import AVFoundation

class SoundTableViewController: UITableViewController {
    private let soundSelectUseCase: SoundSelectUseCase
        = SoundSelectUseCase(soundRepository: SoundRepository.sharedInstance,
                             soundPlayer: SoundPlayer.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの個数を指定するメソッド
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundSelectUseCase.getAvailableSoundNames().count
    }
    
    // セルに値を設定するメソッド
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SoundTableViewCell", for: indexPath)
        cell.textLabel!.text = soundSelectUseCase.getSoundNameByIndex(index: indexPath.row)
        return cell
    }
    
    // セルが選択された時に呼び出されるメソッド
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        soundSelectUseCase.playSoundByIndex(index: indexPath.row)
    }
    
    // セルの選択が外れた時に呼び出されるメソッド
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
}
