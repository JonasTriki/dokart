import 'package:dokart/models/toilet.dart';

class Filter {
  bool _free, _open, _handicap, _stellerom, _pissoirOnly;

  bool get free => _free;

  set free(bool value) {
    _free = value;
  }

  get open => _open;

  set open(value) {
    _open = value;
  }

  get handicap => _handicap;

  set handicap(value) {
    _handicap = value;
  }

  get stellerom => _stellerom;

  set stellerom(value) {
    _stellerom = value;
  }

  get pissoirOnly => _pissoirOnly;

  set pissoirOnly(value) {
    _pissoirOnly = value;
  }

  bool get _isFilterActive =>
      _free || _open || _handicap || _stellerom || _pissoirOnly;

  List<Toilet> filterToilets(List<Toilet> toilets) {
    if (!_isFilterActive) return toilets;
    DateTime now = DateTime.now();
    bool weekday = now.weekday >= 1 && now.weekday <= 5;
    bool saturday = now.weekday == 6;
    bool sunday = now.weekday == 7;

    return toilets.where((Toilet t) {

      // TODO: Implement filter

      return true;
    }).toList(growable: false);
  }
}

/*
    Old java code:
    --------------

    @Override
    protected FilterResults performFiltering(CharSequence charSequence) {

        // Parse toilet filters
        List<ToiletItem> filteredList = null;
        if (charSequence.length() > 0) {
            String[] filters = charSequence.toString().split("\\|");
            boolean free = false, open = false, handicap = false, stellerom = false, pissoirOnly = false;

            if (free || open || handicap || stellerom || pissoirOnly) {

                // Filter original data.
                filteredList = new ArrayList<>(originalData.size());
                Calendar cal = Calendar.getInstance();
                boolean weekday, saturday, sunday;
                int day = cal.get(Calendar.DAY_OF_WEEK);
                weekday = day == Calendar.MONDAY ||
                        day == Calendar.TUESDAY ||
                        day == Calendar.WEDNESDAY ||
                        day == Calendar.THURSDAY ||
                        day == Calendar.FRIDAY;
                saturday = day == Calendar.SATURDAY;
                sunday = day == Calendar.SUNDAY;
                String now = GlobalUtils.getCurrentTimeStamp();
                for (int i = 0; i < originalData.size(); i++) {
                    ToiletItem toiletItem = originalData.get(i);

                    // Check if toilet is free.
                    boolean add = free ? toiletItem.getToilet().getPris() == 0 : toiletItem.getToilet().getPris() > 0;

                    // Check if toilet is open right now.
                    if (open) {
                        String time = "";
                        if (weekday) {
                            time = toiletItem.getToilet().getTidHverdag();
                        } else if (saturday) {
                            time = toiletItem.getToilet().getTidLordag();
                        } else if (sunday) {
                            time = toiletItem.getToilet().getTidSondag();
                        }

                        if (time.equals("ALL") || time.equals("Døgnåpent")) {
                            add &= true;
                        } else if (time.equals("Ukjent") || time.equals("Stengt")) {
                            add &= false;
                        } else {
                            String[] timeSplit = time.split(" – ");
                            String from = GlobalUtils.fixTimeStamp(timeSplit[0]);
                            String to = GlobalUtils.fixTimeStamp(timeSplit[1]);
                            try {
                                add &= GlobalUtils.isTimeBetweenTwoTime(from, to, now);
                            } catch (ParseException e) {
                                e.printStackTrace();
                            }
                        }
                    }

                    // Handicap only toilet.
                    add &= handicap == toiletItem.getToilet().isRullestol();

                    // Baby changing room.
                    add &= stellerom == toiletItem.getToilet().isStellerom();

                    // Pissoir only.
                    add &= pissoirOnly == toiletItem.getToilet().isPissoir();

                    // Only add toilet to filtered list if we meet the criteria.
                    if (add) filteredList.add(toiletItem);
                }
            }
        }
        if (filteredList == null) filteredList = originalData;

        // Return results.
        FilterResults results = new FilterResults();
        results.values = filteredList;
        results.count = filteredList.size();
        return results;
    }

 */
