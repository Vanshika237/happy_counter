import 'package:happy_counter/constants.dart';
import 'package:hive/hive.dart';

final HiveUtility hiveUtility = HiveUtility();

class HiveUtility {
  open() async {
    await Hive.openBox(AppConstants.hiveBoxName);
  }

  add(String? day) {
    if (day == null) {
      return;
    }
    var box = Hive.box(AppConstants.hiveBoxName);
    int count = box.get(day, defaultValue: 0);
    count++;
    box.put(day, count);
  }

  getDayCount(String? day) {
    if (day == null) {
      return 0;
    }
    var box = Hive.box(AppConstants.hiveBoxName);
    return box.get(day, defaultValue: 0);
  }

  getTotalCount() {
    int count = 0;
    var box = Hive.box(AppConstants.hiveBoxName);
    for (int element in box.values) {
      count += element;
    }
    return count;
  }
}
