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
  var engine: AVAudioEngine!
  var recordedAudio: RecordedAudio!
  var audioFile: AVAudioFile!
  var audioPlayer: AVAudioPlayerNode!

  override func viewDidLoad() {
    super.viewDidLoad()
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
    timePitch.pitch = -800.0
    audioPlay([timePitch])
  }

  @IBAction func playTurboChipmunkSound(sender: UIButton) {
    var delayEffect = AVAudioUnitDelay()
    delayEffect.delayTime = NSTimeInterval(0.6)
    var timePitch = AVAudioUnitTimePitch()
    timePitch.pitch = 1000.0
    timePitch.rate = 1.2
    audioPlay([delayEffect, timePitch])
  }

  @IBAction func playTombSound(sender: UIButton) {
    var reverbEffect = AVAudioUnitReverb()
    reverbEffect.wetDryMix = 50.0
    var timePitch = AVAudioUnitTimePitch()
    timePitch.pitch = -600.0
    timePitch.rate = 0.5
    audioPlay([reverbEffect, timePitch])
  }
}