//
//  SoundTableViewController.swift
//  WeatherAlarm
//
//  Created by nagasawa on 2019/05/11.
//  Copyright © 2019 金子宏樹. All rights reserved.
//

import UIKit

class SoundTableViewController: UITableViewController {
    private let soundSelectUseCase: SoundSelectUseCase
        = SoundSelectUseCase(alarmRepository: AlarmRepository.sharedInstance,
                             cacheDataAccessor: CacheDataAccessor.sharedInstance,
                             soundRepository: SoundRepository.sharedInstance,
                             soundPlayer: SoundPlayer.sharedInstance)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func backToPrevious(_ sender: UIBarButtonItem) {
        //音声選択画面から離れるときにまだ音声再生中だったら止めておく
        soundSelectUseCase.stopSound()
        dismiss(animated: true, completion: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier:"SoundTableViewCell", for: indexPath) as! SoundTableViewCell
        cell.soundLabel.text = soundSelectUseCase.getSoundNameByIndex(index: indexPath.row)
        return cell
    }
    
    // セルが選択された時に呼び出されるメソッド
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath) as? SoundTableViewCell
        // チェックマークをつける
        cell?.accessoryType = .checkmark
        // 文字色を黒くする（選択中は背景が白くなるので）
        cell?.soundLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        // 音を再生
        soundSelectUseCase.playSoundByIndex(index: indexPath.row)
        // TODO: rainy,sunny別々に音声設定できるようにする。とりあえず共通。
        soundSelectUseCase.setSound(weather: Weather.Condition.rainy, index: indexPath.row)
        soundSelectUseCase.setSound(weather: Weather.Condition.sunny, index: indexPath.row)
    }
    
    // セルの選択が外れた時に呼び出されるメソッド
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath) as? SoundTableViewCell
        // チェックマークを外す
        cell?.accessoryType = .none
        // 文字色を白に戻す
        cell?.soundLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
