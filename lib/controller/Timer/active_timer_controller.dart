import 'dart:async';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/music/ModelOfMusic.dart';

class ActiveTimerController extends GetxController {
  List<ModelOfMusic> musicsList = [
    ModelOfMusic(
        audio:
            "https://media.githubusercontent.com/media/ehsanNazari145/Interval_music_timer_V2/master/assets/audio/ViralMix.mp3?token=AXRLJC3LQX7PZUSJX4YPBVDD56BMU",
        id: "1",
        image: "assets/images/covers/cover1.jpg"),
    ModelOfMusic(
        audio:
            "https://media.githubusercontent.com/media/ehsanNazari145/Interval_music_timer_V2/master/assets/audio/mainMusics/mix1.mp3?token=AXRLJCYMVFMJG6O433OUDPTD56CRG",
        id: "2",
        image: "assets/images/covers/cover2.jpg"),
    ModelOfMusic(
        audio:
            "https://media.githubusercontent.com/media/ehsanNazari145/Interval_music_timer_V2/master/assets/audio/mainMusics/mix2.mp3?token=AXRLJC3I4TLLR2UOFHZKKFTD56CYK",
        id: "3",
        image: "assets/images/covers/cover3.jpg"),
    ModelOfMusic(
        audio:
            "https://media.githubusercontent.com/media/ehsanNazari145/Interval_music_timer_V2/master/assets/audio/mainMusics/mix3.mp3?token=AXRLJC7N6AHEKZZPBOM7CBLD56C4C",
        id: "4",
        image: "assets/images/covers/cover4.jpg"),
    ModelOfMusic(
        audio:
            "https://media.githubusercontent.com/media/ehsanNazari145/Interval_music_timer_V2/master/assets/audio/mainMusics/mix4.mp3?token=AXRLJC5HPGX5T2IHQDCFBUTD56C6S",
        id: "5",
        image: "assets/images/covers/cover5.jpg"),
  ];

  var mainMusic =
      "https://media.githubusercontent.com/media/ehsanNazari145/Interval_music_timer_V2/master/assets/audio/ViralMix.mp3?token=AXRLJC3LQX7PZUSJX4YPBVDD56BMU"
          .obs;
  var backgroundPhoto = "assets/images/covers/cover1.jpg".obs;
  final player1 = AudioPlayer();
  final playerStart = AudioPlayer();
  final playerMix = AudioPlayer();
  final playerMidel = AudioPlayer();
  var playEndMusic = true.obs;
  late Timer timerMusic;
  late Timer starttimerMusic;

  // this bool is for avoid of 2 times execution timer
  var handlePlayButton = true.obs;
  // this bool is for mute or unmute music icon
  var mixPlayerVolume = false.obs;

  var percent = 0.0.obs;
  var timeOnCenter = 0.0.obs;
  var activMillisecond = 5.0.obs;
  var loop = 1.obs;
  var loopequal = 0.obs;
  late Timer timerActive;
  var loopOnScreen = 0.obs;
  ///////////////////////////////////
  ///////////////////
  //.
  var percentRest = 0.0.obs;
  var timeOnCenterRest = 0.0.obs;
  var restMillisecond = 5.0.obs;
  late Timer timerRest;

  /////////////////////////.
  ///
  ///.
  startReatTimer() {
    endMusicFunc();

    timerRest = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      timeOnCenterRest.value += 0.001;
      percentRest.value += 1 / restMillisecond.value;

      // print(
      //     "here+ ${(restMillisecond.value.round()) - ((percentRest.value) * restMillisecond.value).round()}");
      if (percentRest.value >= 1) {
        percentRest.value = 0.0;
        timeOnCenterRest.value = 0.0;
        timerRest.cancel();

        if (loopequal.value < loop.value - 1) {
          loopequal.value += 1;
          startActivitiTimer();
        } else {
          loopequal.value = 0;
          playerMix.stop();
          handlePlayButton.value = true;

          mixPlayerVolume.value = false;
        }
      }
    });
  }

  startActivitiTimer() {
    startMusicFunc();
    timerActive = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      timeOnCenter.value += 0.001;
      percent.value += 1 / activMillisecond.value;
      // print(
      //     "here+ ${(activMillisecond.value.round()) - ((percent.value) * activMillisecond.value).round()}");

      if (percent.value >= 1) {
        percent.value = 0.0;
        timeOnCenter.value = 0.0;
        timerActive.cancel();
        startReatTimer();

        if (loopequal.value < loop.value) {
          loopOnScreen.value += 1;
        }
      }
    });
  }

  Timer endMusicFunc() {
    return timerMusic = Timer.periodic(const Duration(milliseconds: 500), (_) {
      print(
          "Hereeeeezzzzzzzzzzzzzzzzzzzz${loopOnScreen.value - (loop.value - 1)}");
      if ((activMillisecond.value.round()) -
              ((percent.value) * activMillisecond.value).round() <
          4) {
        getAudioEnd();

        timerMusic.cancel();
      }
    });
  }

  Timer startMusicFunc() {
    return starttimerMusic =
        Timer.periodic(const Duration(milliseconds: 500), (_) {
      if ((restMillisecond.value.round()) -
              ((percentRest.value) * restMillisecond.value).round() <
          5) {
        getAudioStart();
        if (loop.value - loopOnScreen.value == 1) {
          Future.delayed(const Duration(milliseconds: 5000), () {
            getAudioMidel();
          });
        }
        starttimerMusic.cancel();
      }
    });
  }

  getAudioEnd() async {
    await player1.setAsset("assets/audio/Stop.m4a");
    player1.play();
  }

  getAudioStart() async {
    await playerStart.setAsset("assets/audio/Start.wav");
    playerStart.play();
  }

  getMixMusic() async {
    await playerMix.setUrl(mainMusic.value);
    await playerMix.load();
    playerMix.play();
  }

  getAudioMidel() async {
    await playerMidel.setAsset("assets/audio/midSet.wav");
    playerMidel.play();
  }
}
