import 'package:volume/volume.dart';

class VolumeManager {
  static VolumeManager _instance;
  double _maxVol = 100.0;
  double _currentVol = 50.0;

  static Future<VolumeManager> getInstance() async {
    if (_instance == null) {
      _instance = VolumeManager();
      _instance._initPlatformState();
      _instance._initVolumes();
    }

    return _instance;
  }

  double maxVolume() {
    return _maxVol.toDouble();
  }

  double currentVolume() {
    return _currentVol.toDouble();
  }

  void setVolume(double volume) async {
    final curVolume = _instance._currentVol.round().toInt();
    _instance._currentVol = volume;
    final newVolume = _instance._currentVol.round().toInt();
    if (curVolume != newVolume) {
      await Volume.setVol(newVolume);
    }
  }

  // private:
  Future<void> _initPlatformState() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  void _initVolumes() async {
    _instance._maxVol = (await Volume.getMaxVol).toDouble();
    _instance._currentVol = (await Volume.getVol).toDouble();
  }
}
