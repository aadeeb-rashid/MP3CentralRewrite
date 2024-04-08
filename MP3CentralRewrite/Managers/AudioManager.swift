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
class AudioManager : NSObject, AVAudioPlayerDelegate
{
  @Published var library : [LocalFile] = []
  private var cancellables: Set<AnyCancellable> = []
  
  private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
  
  
  @Published var isPlaying : Bool = false
  @Published var shuffleMode : Bool = true {
    didSet {
      if shuffleMode {
        self.buildShuffleQueue()
      }
    }
  }
  @Published var repeatMode : Bool = true
  
  @Published var songIndex : Int = 0
  @Published var songCurrentPosition : Double = 0.5
  
  var shuffleQueue : [Int]? = nil
  
  override init() {
    super.init()
    self.loadLibrary()
    self.setupSubscriptions()
    self.setupForAudioPlayOutsideOfApp()
  }
  
  private func loadLibrary() {
    let fetchRequest: NSFetchRequest<LocalFile> = LocalFile.fetchRequest()
    
    do {
      self.library = try PersistenceController.shared.getContext().fetch(fetchRequest)
    } catch {
      //TODO: Handle Error
    }
  }
  
  private func setupSubscriptions() {
    let context = PersistenceController.shared.getContext()
    
    NotificationCenter.default.publisher(for: NSManagedObjectContext.didChangeObjectsNotification, object: context)
      .sink { [weak self] _ in
        self?.loadLibrary()
      }
      .store(in: &cancellables)
  }
  
  func prepareToPlay() {
    audioPlayer.prepareToPlay()
  }
  
  func getAudioPlayerTime() -> TimeInterval {
    return audioPlayer.currentTime
  }
  
  func setVolume(value: Float) {
    audioPlayer.setVolume(value, fadeDuration: 0.5);
  }
  
  func stopPlaying() {
    if(audioPlayer.isPlaying) {
      audioPlayer.stop()
    }
  }
  
  func playAudioFromIndex(index: Int) {
    self.songIndex = index;
    if(index >= library.count) {
      self.songIndex = 0;
    }
    let fileName : String = library[songIndex].name ?? ""
    
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let audioUrl = documentsDirectoryURL.appendingPathComponent(fileName)
    DispatchQueue.main.async {
      self.playAudioFromUrl(url: audioUrl)
    }
  }
  
  func playAudioFromUrl(url : URL) {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
      self.play()
      self.updateMetaData()
      self.audioPlayer.delegate = self
      self.setVolume(value: 1)
      self.audioPlayer.numberOfLoops = self.repeatMode ? -1 : 0
    }
    catch let error as NSError{
      //TODO: Handle Error
    }
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
      self.pause()
      return .success
    }
  }
  
  private func addPauseButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.pauseCommand.addTarget
    {
      [unowned self] event in
      self.play()
      return.success
    }
  }
  
  func playPause() {
    audioPlayer.isPlaying ? self.pause() : self.play()
  }
  
  private func pause() {
    self.audioPlayer.pause()
    self.isPlaying = false
    self.updateMetaData()
  }
  
  private func play() {
    self.audioPlayer.play()
    self.isPlaying = true
    self.updateMetaData()
  }
  
  private func addRewindButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.previousTrackCommand.addTarget {
      [unowned self] event in
      self.rewind()
      return .success
    }
  }
  
  func rewind() {
    audioPlayer.currentTime > 2.0 ? self.playAudioFromIndex(index: self.songIndex) : self.playPrevSong()
  }
  
  private func playPrevSong() {
    self.songIndex == 0 ? self.playAudioFromIndex(index: library.count - 1) : self.playAudioFromIndex(index: self.songIndex - 1)
  }
  
  private func addForwardButtonToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.nextTrackCommand.addTarget {
      [unowned self] event in
      self.forward()
      return .success
    }
  }
  
  func forward() {
    self.playNextSong();
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    self.playNextSong()
  }
  
  private func playNextSong()
  {
    if repeatMode {
      self.playAudioFromIndex(index: self.songIndex)
    } else if shuffleMode {
      self.playNextSongFromShuffleQueue()
    } else {
      self.playAudioFromIndex(index: self.songIndex + 1 & self.library.count)
    }
  }
  
  private func playNextSongFromShuffleQueue()
  {
    guard let shuffleQueue = self.shuffleQueue else {
      self.buildShuffleQueue()
      self.playNextSongFromShuffleQueue()
      return
    }
    let shuffleQueueIndex : Int = shuffleQueue.firstIndex(of: self.songIndex) ?? 0
    let newSongIndex = shuffleQueue[(shuffleQueueIndex+1) % (self.shuffleQueue?.count ?? 1)]
    self.playAudioFromIndex(index: newSongIndex)
  }
  
  func shuffleButtonPressed() {
    self.shuffleMode.toggle()
  }
  
  func buildShuffleQueue() {
    shuffleQueue = Array(library.indices)
    shuffleQueue?.shuffle()
  }
  
  func clearShuffleQueue() {
    self.shuffleQueue = nil
  }
  
  private func addSeekingToCommandCenter(commandCenter: MPRemoteCommandCenter) {
    commandCenter.changePlaybackPositionCommand.addTarget {
      [unowned self] event in
      let time = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime ?? 0
      self.seekToTime(time: time)
      return .success
    }
  }
  
  func seekToTime(time : TimeInterval) {
    if(time >= self.audioPlayer.duration) {
      self.audioPlayer.currentTime = self.audioPlayer.duration - 1;
      return
    }
    self.audioPlayer.currentTime = time
    self.updateMetaData()
  }
  
  func repeatButtonPressed() {
    repeatMode.toggle()
    self.audioPlayer.numberOfLoops = repeatMode ? -1 : 0
  }
  
  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    if let error = error {
      //TODO: Handle Error
    }
  }
  
  func updateMetaData() {
    var nowPlayingInfo = [String : Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = self.library[self.songIndex].name;
    nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
}
