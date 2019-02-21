import 'package:dokart/models/meta_state.dart';
import 'package:dokart/models/toilet.dart';
import 'package:meta/meta.dart';

@immutable
class Filter {
  final bool free, open, handicap, stellerom, pissoirOnly;

  const Filter(
      {this.free = false,
      this.open = false,
      this.handicap = false,
      this.stellerom = false,
      this.pissoirOnly = false});

  Filter copyWith(
          {bool free,
          bool open,
          bool handicap,
          bool stellerom,
          bool pissoirOnly}) =>
      Filter(
          free: free ?? this.free,
          open: open ?? this.open,
          handicap: handicap ?? this.handicap,
          stellerom: stellerom ?? this.stellerom,
          pissoirOnly: pissoirOnly ?? this.pissoirOnly);

  Filter setFree(bool free) => copyWith(free: free);

  Filter setOpen(bool open) => copyWith(open: open);

  Filter setHandicap(bool handicap) => copyWith(handicap: handicap);

  Filter setStellerom(bool stellerom) => copyWith(stellerom: stellerom);

  Filter setPissoirOnly(bool pissoirOnly) => copyWith(pissoirOnly: pissoirOnly);

  bool get _isFilterActive =>
      free || open || handicap || stellerom || pissoirOnly;

  String _fixTimeStamp(String time) {
    return time.replaceAll("\.", ":").replaceAll("24:00", "00:00") + ":00";
  }

  List<Toilet> filterToilets(List<Toilet> toilets) {
    if (!_isFilterActive) return toilets;
    DateTime now = DateTime.now();

    return toilets.where((Toilet t) {
      bool keepToilet = free ? t.getPris == 0 : t.getPris > 0;

      // Check if toilet is open right now.
      if (open) {
        String time = t.getTidOfDay(now);
        if (time == "ALL" || time == "Døgnåpent" || time == "00:00 – 00:00") {
          keepToilet &= true;
        } else if (time == "Ukjent" || time == "Stengt") {
          keepToilet &= false;
        } else {
          // We check if the toilet is still open.
          List<String> timeSplit = time.split(" – ");
          List<String> from =
              _fixTimeStamp(timeSplit[0]).split(":"); // HH:mm:ss
          DateTime fromDT = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(from[0]),
            int.parse(from[1]),
            int.parse(from[2]),
          );
          List<String> to = _fixTimeStamp(timeSplit[1]).split(":"); // HH:mm:ss
          DateTime toDT = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(to[0]),
            int.parse(to[1]),
            int.parse(to[2]),
          );
          bool isOpen = now.isAfter(fromDT) && now.isBefore(toDT);

          // Keep toilet if open.
          keepToilet &= isOpen;
        }
      }

      // Handicap only toilet.
      if (handicap) {
        keepToilet &= t.isRullestol == MetaState.YES;
      }

      // Baby changing room.
      if (stellerom) {
        keepToilet &= t.isStellerom == MetaState.YES;
      }

      // Pissoir only.
      if (pissoirOnly) {
        keepToilet &= t.isPissoir == MetaState.YES;
      }

      return keepToilet;
    }).toList(growable: false);
  }

  @override
  String toString() {
    return 'Filter{free: $free, open: $open, handicap: $handicap, stellerom: $stellerom, pissoirOnly: $pissoirOnly}';
  }
}
