//
//  HelperFunctions.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import AVFoundation

let speech = Speech()

var instruments: [Instrument.Kind: Instrument] = [:]

var audioController = AudioController()

@objc
class AudioController: NSObject, AVAudioPlayerDelegate {

    var activeAudioPlayers = Set<AVAudioPlayer>()
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        activeAudioPlayers.remove(player)
    }
    
    func register(_ player: AVAudioPlayer) {
        activeAudioPlayers.insert(player)
        player.delegate = self
    }
}

var audioEngine: AudioPlayerEngine = {
    let audioPlayerEngine = AudioPlayerEngine()
    audioPlayerEngine.start()
    return audioPlayerEngine
}()

/// Generates a random Int (whole number) in the given range.
///
/// - Parameter from: The lowest value that the random number can have.
/// - Parameter to: The highest value that the random number can have.
///
/// - localizationKey: randomInt(from:to:)
public func randomInt(from: Int, to: Int) -> Int {
    return Int.random(in: from...to)
}

/// Generates a random Double (decimal number) in the given range.
///
/// - Parameter from: The lowest value that the random number can have.
/// - Parameter to: The highest value that the random number can have.
///
/// - localizationKey: randomDouble(from:to:)
public func randomDouble(from: Double, to: Double) -> Double {
    let maxValue = max(from.double, to.double)
    let minValue = min(from.double, to.double)
    if minValue == maxValue {
        return minValue
    } else {
        // Between 0.0 and 1.0
        let randomScaler = Double.random(in: 0.0...1.0)
        return (randomScaler * (maxValue-minValue)) + minValue
    }
}


/// Speaks the given text.
///
/// - Parameter text: The text to be spoken.
/// - Parameter voice: The voice in which to speak the text. Leave out to use the default voice.
///
/// - localizationKey: speak(_:voice:)
public func speak(_ text: String, voice: SpeechVoice = SpeechVoice()) {
    speech.speak(text, voice: voice)
}

/// Stops any speech that’s currently being spoken.
///
/// - localizationKey: stopSpeaking()
public func stopSpeaking() {
    speech.stopSpeaking()
}

/// Plays the given sound.
/// Optionally specify a volume from 0 (silent) to 100 (loudest), with 80 being the default.
///
/// - Parameter sound: The sound to be played.
/// - Parameter volume: The volume at which the sound is to be played (0 to 100).
///
/// - localizationKey: playSound(_:volume:)
public func playSound(_ sound: Sound, volume: Number = 80) {
    
    guard let url = sound.url else { return }
    
    do {
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.volume = Float(max(min(volume.int, 100), 0)) / 100.0
        audioController.register(audioPlayer)
        audioPlayer.play()
    } catch {}
    assessmentController?.append(.playSound(sound: sound, volume: volume))
    
}

func createInstrument(_ kind: Instrument.Kind) -> Instrument {
    
    let instrument = Instrument(kind: kind)
    instrument.connect(audioEngine)
    instrument.defaultVelocity = 64
    return instrument
}

/// Plays a note (from 0 to 23) with the given instrument.
/// Optionally specify a volume from 0 (silent) to 100 (loudest), with 75 being the default.
///
/// - Parameter instrumentKind: The kind of instrument with which to play the note.
/// - Parameter note: The note to be played (0 to 23).
/// - Parameter volume: The volume at which the note is to be played (0 to 100).
///
/// - localizationKey: playInstrument(_:note:volume:)
public func playInstrument(_ instrumentKind: Instrument.Kind, note: Number, volume: Number = 75) {
    
    if instruments[instrumentKind] == nil {
        instruments[instrumentKind] = createInstrument(instrumentKind)
    }
    guard let instrument = instruments[instrumentKind] else { return }
    
    // Get corresponding midi note value
    let noteIndex = min(max(note.int, 0), instrument.availableNotes.count - 1)
    
    let velocity = Double(max(min(volume.int, 100), 0)) / 100.0 * 127.0
    
    instrument.startPlaying(noteValue: instrument.availableNotes[noteIndex], withVelocity: UInt8(velocity), onChannel: 0)
    assessmentController?.append(.playInstrument(instrumentKind: instrumentKind, note: note, volume: volume))

}

