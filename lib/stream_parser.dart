import 'package:fastotv/channels/istream.dart';

const String ALL_GROUP_TITLE = 'All';
const String FAVORITE_GROUP_TITLE = 'Favorite';
const String RECENT_GROUP_TITLE = 'Recent';

class StreamsParser<T extends IStream> {
  StreamsParser(this.channels);

  List<T> channels = [];

  Map<String, List<T>> _channelsMap = {};

  Map<String, List<T>> parseChannels() {
    _channelsMap[FAVORITE_GROUP_TITLE] = [];
    _channelsMap[RECENT_GROUP_TITLE] = [];
    channels.forEach((element) {
      _savePushFavorite(element);
      _savePushRecent(element);
      _savePushChannel(ALL_GROUP_TITLE, element);
      List<String> temp = _findsymbol(element.group());
      temp.forEach((singleGroup) => _savePushChannel(singleGroup, element));
    });
    _channelsMap[RECENT_GROUP_TITLE].sort((b, a) => a.recentTime().compareTo(b.recentTime()));
    return _channelsMap;
  }

  List<String> _findsymbol(String initial) {
    List<String> categ = [];
    initial.contains(";") ? categ = initial.split(";") : categ.add(initial);
    return categ;
  }

  void _savePushChannel(String category, T element) {
    if (category.isEmpty) {
      return;
    }

    if (!_channelsMap.containsKey(category)) {
      _channelsMap[category] = [];
    }
    _channelsMap[category].add(element);
  }

  void _savePushFavorite(T element) {
    if (element.favorite()) {
      _channelsMap[FAVORITE_GROUP_TITLE].add(element);
    }
  }

  void _savePushRecent(T element) {
    if (element.recentTime() > 0) {
      _channelsMap[RECENT_GROUP_TITLE].insert(0, element);
    }
  }
}
