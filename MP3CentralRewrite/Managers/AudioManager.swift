//
//  AudioManager.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 2/5/24.
//

import Foundation
import Combine
import AVFoundation
import CoreData
import MediaPlayer
import SwiftUI
class AudioManager : NSObject, ObservableObject, AVAudioPlayerDelegate
{
  var library : [LocalFile] {
    LibraryCache.shared.library
  }
  
  @Published var queueManager : QueueManager? = nil
  
  @Published private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
  @Published var isPlaying: Bool = false
  @Published var songCurrentPosition: Double = 0.0 
  
  @Published var currentTime: String = "0:00"
  @Published var timeRemaining: String = "0:00"
  var timer: Timer? = nil
  
  override init() {
    super.init()
    self.setupForAudioPlayOutsideOfApp()
  }
  
  func setFirstQueue(_ queueManager: QueueManager) {
    self.queueManager = queueManager
    self.audioPlayer.prepareToPlay()
    self.playAudioFile(file: self.queueManager!.currentSong())
    self.resetTimers()
  }
  
  private func playAudioFile(file: LocalFile) {
    let fileName : String = file.name ?? ""
    
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let audioUrl = documentsDirectoryURL.appendingPathComponent(fileName)
    DispatchQueue.main.async {
      self.playAudioFromUrl(url: audioUrl)
    }
  }
  
  private func playAudioFromUrl(url : URL) {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
      self.play()
      self.resetTimers()
      self.updateMetaData()
      self.audioPlayer.delegate = self
    }
    catch let error as NSError {
      AlertHandler.shared.handleError(error)
    }
  }
  
  func playPause() {
    audioPlayer.isPlaying ? self.pause() : self.play()
  }
  
  private func pause() {
    self.audioPlayer.pause()
    self.isPlaying = self.audioPlayer.isPlaying
    self.stopTimers()
    self.updateMetaData()
  }
  
  private func play() {
    self.audioPlayer.play()
    self.isPlaying = self.audioPlayer.isPlaying
    self.startTimers()
    self.updateMetaData()
  }
  
  func rewind() {
    guard let queueManager = queueManager else { return }
    audioPlayer.currentTime > 2.0 ? self.playAudioFile(file: queueManager.currentSong()) : self.playPrevSong()
  }
  
  private func playPrevSong() {
    guard let queueManager = queueManager else { return }
    self.playAudioFile(file: queueManager.previousSong())
  }
  
  func forward() {
    self.playNextSong()
  }
  
  internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.playNextSong()
  }
  
  private func playNextSong() {
    guard let queueManager = queueManager else { return }
    self.playAudioFile(file: queueManager.nextSong())
  }
  
  func shuffleButtonPressed() {
    self.queueManager?.shuffleTapped()
  }
  
  func repeatButtonPressed() {
    self.queueManager?.repeatTapped()
  }
  
  func seekToTime() {
    self.seekToTime(time: TimeInterval(songCurrentPosition * audioPlayer.duration))
  }
  
  private func seekToTime(time : TimeInterval) {
    if(time >= self.audioPlayer.duration) {
      self.audioPlayer.currentTime = self.audioPlayer.duration - 1;
      return
    }
    self.audioPlayer.currentTime = time
    self.updateMetaData()
  }
  
  
  
  func startTimers() {
    self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
      self?.updateSlider()
      self?.updateAudioPlayerTime()
      self?.updateAudioPlayerTimeRemaining()
    }
  }
  
  func stopTimers() {
    self.timer = nil
  }
  
  func resetTimers() {
    stopTimers()
    startTimers()
  }
  
  func updateAudioPlayerTime() {
    let timeInterval = audioPlayer.currentTime
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    self.currentTime = String(format: "%02d:%02d", minutes, seconds)
  }
  
  func updateAudioPlayerTimeRemaining() {
    let timeInterval = audioPlayer.duration - audioPlayer.currentTime
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    self.timeRemaining = String(format: "%02d:%02d", minutes, seconds)
  }
  
  func updateSlider() {
    self.songCurrentPosition = audioPlayer.currentTime / audioPlayer.duration
  }
  
  internal func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    guard let error = error else { return }
    
    AlertHandler.shared.handleError(error)
  }
  
  func updateMetaData() {
    var nowPlayingInfo = [String : Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.queueManager?.currentSong().name ?? "MP3Central";
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
  
  func setupForAudioPlayOutsideOfApp() {
    let commandCenter = MPRemoteCommandCenter.shared()
    
    self.addPlayButtonToCommandCenter(commandCenter: commandCenter)
    self.addPauseButtonToCommandCenter(commandCenter: commandCenter)
    self.addRewindButtonToCommandCenter(commandCenter: commandCenter)
    self.addForwardButtonToCommandCenter(commandCenter: commandCenter)
    self.addSeekingToCommandCenter(commandCenter: commandCenter)
  }
  
  private func addPlayButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.playCommand.addTarget
    {
      [unowned self] event in
      self.play()
      return .success
    }
  }
  
  private func addPauseButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.pauseCommand.addTarget
    {
      [unowned self] event in
      self.pause()
      return.success
    }
  }
  
  private func addRewindButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.previousTrackCommand.addTarget {
      [unowned self] event in
      self.rewind()
      return .success
    }
  }
  
  private func addForwardButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.nextTrackCommand.addTarget {
      [unowned self] event in
      self.forward()
      return .success
    }
  }
  
  private func addSeekingToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.changePlaybackPositionCommand.addTarget {
      [unowned self] event in
      let time = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime ?? 0
      self.seekToTime(time: time)
      return .success
    }
  }
}
