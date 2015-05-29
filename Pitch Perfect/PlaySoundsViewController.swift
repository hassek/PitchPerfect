//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Tomas Henriquez on 5/21/15.
//  Copyright (c) 2015 Tomas Henriquez. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  @IBOutlet weak var stopButton: UIButton!
  var engine: AVAudioEngine!
  var recordedAudio: RecordedAudio!
  var audioFile: AVAudioFile!
  var audioPlayer: AVAudioPlayerNode!

  override func viewDidLoad() {
    super.viewDidLoad()
    stopButton.hidden = true
//    if var filePath = NSBundle.mainBundle().pathForResource("UGH", ofType: "mp3") {
//      var fileUrl = NSURL.fileURLWithPath(filePath)
//
//    } else {
//      println("file path not found")
//    }

    engine = AVAudioEngine()
    audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
    audioPlayer = AVAudioPlayerNode()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func audioPlay(rate: Float = 1.0, pitch: Float = 1.0, reverb: Float = 0.0, echo: Double = 0.0) {
    audioPlayer = AVAudioPlayerNode()

    audioPlayer.stop()
    engine.stop()
    engine.reset()
    engine.attachNode(audioPlayer)

    var timePitch = AVAudioUnitTimePitch()
    timePitch.pitch = pitch
    timePitch.rate = rate
    engine.attachNode(timePitch)
    
    var reverbEffect = AVAudioUnitReverb()
    reverbEffect.wetDryMix = reverb
    engine.attachNode(reverbEffect)
    
    var delay = AVAudioUnitDelay()
    delay.delayTime = NSTimeInterval(echo)
    engine.attachNode(delay)
    
    engine.connect(audioPlayer, to: delay, format: nil)
    engine.connect(delay, to: reverbEffect, format: nil)
    engine.connect(reverbEffect, to:timePitch, format: nil)
    engine.connect(timePitch, to: engine.outputNode, format: nil)

    audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    engine.startAndReturnError(nil)
    audioPlayer.play()
    stopButton.hidden = false
  }


  @IBAction func playFastSound(sender: UIButton) {
    audioPlay(rate: 1.8)
  }

  @IBAction func playSlowSound(sender: UIButton) {
    audioPlay(rate: 0.5)
  }

  @IBAction func playChipmunkSound(sender: UIButton) {
    audioPlay(pitch: 1200.0)
  }

  @IBAction func playDarthVaderSound(sender: UIButton) {
    audioPlay(pitch: -600.0)
  }

  @IBAction func playEchoSound(sender: AnyObject) {
    audioPlay(echo: 0.1)
  }

  @IBAction func playReverbSound(sender: UIButton) {
    audioPlay(reverb: 100)
  }
  
  @IBAction func stopAudio(sender: AnyObject) {
    audioPlayer.stop()
//    audioPlayer.currentTime = 0
    stopButton.hidden = true
  }
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
}
