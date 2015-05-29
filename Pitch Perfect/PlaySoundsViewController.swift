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
    engine = AVAudioEngine()
    audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
    audioPlayer = AVAudioPlayerNode()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func audioPlay(effects: [AVAudioNode!]) {
    // TODO: figure out how to let user send multiple effects to apply to sound.
    // Why on earth AVAudioPlayerNode doesn't have a delegate!
    audioPlayer = AVAudioPlayerNode()

    audioPlayer.stop()
    engine.stop()
    engine.reset()
    engine.attachNode(audioPlayer)

    // Attach all effect to the engine
    for effect in effects {
        engine.attachNode(effect)
    }

    // connect each effect to the audioPlayer
    engine.connect(audioPlayer, to: effects[0], format: nil)
    var i = 0;
    for (i; i < effects.count - 1; i++) {
      engine.connect(effects[i], to: effects[i + 1], format: nil)
    }
    engine.connect(effects[i], to: engine.outputNode, format: nil)

    audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    engine.startAndReturnError(nil)
    audioPlayer.play()
    stopButton.hidden = false
  }


  @IBAction func playFastSound(sender: UIButton) {
    var timePitch = AVAudioUnitTimePitch()
    timePitch.rate = 1.8
    audioPlay([timePitch])
  }

  @IBAction func playSlowSound(sender: UIButton) {
    var timePitch = AVAudioUnitTimePitch()
    timePitch.rate = 0.5
    audioPlay([timePitch])
  }

  @IBAction func playChipmunkSound(sender: UIButton) {
    var timePitch = AVAudioUnitTimePitch()
    timePitch.pitch = 1200.0
    audioPlay([timePitch])
  }

  @IBAction func playDarthVaderSound(sender: UIButton) {
    var timePitch = AVAudioUnitTimePitch()
    timePitch.pitch = -600.0
    audioPlay([timePitch])
  }

  @IBAction func playEchoSound(sender: AnyObject) {
    var delayEffect = AVAudioUnitDelay()
    delayEffect.delayTime = NSTimeInterval(0.1)
    audioPlay([delayEffect])
  }

  @IBAction func playReverbSound(sender: UIButton) {
    var reverbEffect = AVAudioUnitReverb()
    reverbEffect.wetDryMix = 100
    audioPlay([reverbEffect])
  }
  
  @IBAction func stopAudio(sender: AnyObject) {
    audioPlayer.stop()
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
