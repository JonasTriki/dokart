import 'package:dokart/models/opening_hour.dart';
import 'package:dokart/models/toilet.dart';
import 'package:meta/meta.dart';

@immutable
class Filter {
  final bool free, open, accessible, babycare, pissoir;

  const Filter(
      {this.free = false,
      this.open = false,
      this.accessible = false,
      this.babycare = false,
      this.pissoir = false});

  Filter copyWith(
          {bool free,
          bool open,
          bool accessible,
          bool babycare,
          bool pissoir}) =>
      Filter(
          free: free ?? this.free,
          open: open ?? this.open,
          accessible: accessible ?? this.accessible,
          babycare: babycare ?? this.babycare,
          pissoir: pissoir ?? this.pissoir);

  Filter setFree(bool free) => copyWith(free: free);

  Filter setOpen(bool open) => copyWith(open: open);

  Filter setAccessible(bool accessible) => copyWith(accessible: accessible);

  Filter setBabycare(bool babycare) => copyWith(babycare: babycare);

  Filter setPissoir(bool pissoir) => copyWith(pissoir: pissoir);

  bool get _isFilterActive => free || open || accessible || babycare || pissoir;

  String _fixTimeStamp(String time) {
    return time.replaceAll("24:00", "00:00") + ":00";
  }

  List<Toilet> filterToilets(List<Toilet> toilets) {
    if (!_isFilterActive) return toilets;
    DateTime now = DateTime.now();

    return toilets.where((Toilet t) {
      bool keepToilet = free ? t.price == 0 : t.price > 0;

      // Check if toilet is open right now.
      if (open) {
        OpeningHour openingHour = t.getCurrentOpeningHour(now);
        if (openingHour.isAlwaysOpen) {
          keepToilet &= true;
        } else if (openingHour.isClosed) {
          keepToilet &= false;
        } else {

          // We check if the toilet is still open.
          List<String> from =
              _fixTimeStamp(openingHour.from).split(":"); // HH:mm:ss
          DateTime fromDT = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(from[0]),
            int.parse(from[1]),
            int.parse(from[2]),
          );
          List<String> to = _fixTimeStamp(openingHour.to).split(":"); // HH:mm:ss
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
      if (accessible) {
        keepToilet &= t.accessible;
      }

      // Baby changing room.
      if (babycare) {
        keepToilet &= t.babycare;
      }

      // Pissoir only.
      if (pissoir) {
        keepToilet &= t.pissoir;
      }

      return keepToilet;
    }).toList(growable: false);
  }

  @override
  String toString() {
    return 'Filter{free: $free, open: $open, accessible: $accessible, babycare: $babycare, pissoir: $pissoir}';
  }
}
