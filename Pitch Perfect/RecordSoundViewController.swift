//
//  RecordSoundViewController.swift
//  Pitch Perfect
//
//  Created by Tomas Henriquez on 5/19/15.
//  Copyright (c) 2015 Tomas Henriquez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

  @IBOutlet var recordingLabel: UILabel!
  @IBOutlet var stopButton: UIButton!
  @IBOutlet var recordButton: UIButton!
  @IBOutlet weak var tapRecordLabel: UILabel!
  
  var audioRecorder: AVAudioRecorder!
  var recordedAudio: RecordedAudio!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(animated: Bool) {
    stopButton.hidden = true
    recordButton.enabled = true
    tapRecordLabel.hidden = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func recordAudio(sender: UIButton) {
    recordButton.enabled = false
    recordingLabel.hidden = false
    stopButton.hidden = false
    tapRecordLabel.hidden = true

    //Inside func recordAudio(sender: UIButton)
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }
  
  @IBAction func stopAudio(sender: UIButton) {
    recordingLabel.hidden = true
    audioRecorder.stop()
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }
  
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
    if (flag) {
      recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
      self.performSegueWithIdentifier("stopSound", sender: recordedAudio)
      
    } else {
      println("Something happened with the recording")
      recordButton.enabled = true
      stopButton.hidden = true
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopSound"){
      let playSoundVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      
      playSoundVC.recordedAudio = sender as! RecordedAudio
    }
  }

}