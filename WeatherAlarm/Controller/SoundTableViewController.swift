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
    
    let soundList=["学校のチャイム01"]
    var soundName: String = ""
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundList.count
    }
    
    // セルが選択された時に呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        soundName = soundList[indexPath.row]
        let soundFilePath = Bundle.main.path(forResource: soundName, ofType: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFilePath), fileTypeHint:nil)
        } catch {
            print("Failed to create alarm; \(error)")
            return
        }
        player?.play()
    }
    
    // セルの選択が外れた時に呼び出される
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"SoundTableViewCell", for: indexPath) as? SoundTableViewCell else{fatalError("UAAAAAAAAA")}
        cell.soundLabel.text = soundList[indexPath.row]
        return cell
    }
}
