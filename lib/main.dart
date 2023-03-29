import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:happy_counter/calendar_view.dart';
import 'package:happy_counter/constants.dart';
import 'package:happy_counter/hive_utility.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() async {
  await Hive.initFlutter();
  await hiveUtility.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Happy++',
      theme: ThemeData(
        scaffoldBackgroundColor: Palette.background,
        primarySwatch: Colors.yellow,
      ),
      home: const MyHomePage(title: "I'm Happy! :D"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentMonth = DateTime.now().month;
  String? today;
  int totalCount = 0;
  late ConfettiController confettiController;

  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    var now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day);
    today = DateFormat(AppConstants.dateFormat).format(date).toString();
    super.initState();
  }

  void _incrementCounter() {
    confettiController.play();
    hiveUtility.add(today);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    totalCount = hiveUtility.getTotalCount();
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                splashRadius: 16,
                tooltip: "Say Hi!",
                onPressed: () async {
                  var url = "https://vanshika237.github.io/";
                  try {
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      throw "Could not launch $url";
                    }
                    // ignore: empty_catches
                  } catch (e) {}
                },
                icon: Icon(Icons.waving_hand_outlined,
                    color: Colors.white.withOpacity(0.5))),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 56),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCalendar(
                    events: const {},
                    hideBottomBar: true,
                    isExpanded: true,
                    hideTodayIcon: true,
                    onDateSelected: null,
                    onMonthChanged: (selectedDate) {
                      currentMonth = selectedDate.month;
                    },
                    dayOfWeekStyle:
                        const TextStyle(color: Colors.transparent, fontSize: 1),
                    dayBuilder: (context, day) {
                      String date = DateFormat(AppConstants.dateFormat)
                          .format(day)
                          .toString();
                      int count = hiveUtility.getDayCount(date);
                      double opacity = (count / 10);
                      opacity = opacity > 1 ? 1 : opacity;
                      return Tooltip(
                        message:
                            '$date, $count ${count == 1 ? "happy" : "happies"}',
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: day.month == currentMonth
                                  ? Colors.yellow.withOpacity(opacity)
                                  : Palette.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: (day.month == currentMonth
                                          ? Palette.lightShadow
                                          : Palette.darkShadow) ??
                                      Theme.of(context)
                                          .scaffoldBackgroundColor)),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Text(
                "Such happy, much wow",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Text(
                  '$totalCount',
                  style: const TextStyle(color: Colors.white, fontSize: 34),
                ),
              ),
              const Expanded(
                child: Text(
                  "Press the button whenever you are happy!",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
            color: Palette.background,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Palette.lightShadow ?? Colors.black,
                offset: const Offset(-5, -5),
                blurRadius: 20,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Palette.darkShadow ?? Colors.black,
                offset: const Offset(5, 5),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ]),
        child: Stack(
          children: [
            Center(
              child: ConfettiWidget(
                confettiController: confettiController,
                emissionFrequency: 0.5,
                maxBlastForce: 100,
                numberOfParticles: 20,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: 0,
                colors: const [Colors.yellow],
                minimumSize: const Size(5, 5),
                maximumSize: const Size(10, 10),
              ),
            ),
            Center(
                child: IconButton(
                    splashRadius: 1,
                    splashColor: Colors.transparent,
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.tag_faces_outlined,
                        size: 32, color: Colors.yellow)))
          ],
        ),
      ),
    );
  }
}
