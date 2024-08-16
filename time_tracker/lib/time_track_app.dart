import 'package:flutter/widgets.dart';

class TimeTrackApp extends StatefulWidget {
  const TimeTrackApp({super.key});

  @override
  State<TimeTrackApp> createState() => _TimeTrackAppState();
}

class _TimeTrackAppState extends State<TimeTrackApp> {

  @override
  Widget build(BuildContext context) {
    return Column(
                children: [
                            Container(
                    width: 282,
                    height: 62,
                    decoration:     BoxDecoration(
                color: Color(0xffd9d9d9))
                    ),
        Text(
                    "Project: Learning",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "Timeslots:",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Container(
                    width: 282,
                    height: 19,
                    decoration:     BoxDecoration(
                color: Color(0xffd9d9d9))
                    ),
        Container(
                    width: 282,
                    height: 19,
                    decoration:     BoxDecoration(
                color: Color(0xffd9d9d9))
                    ),
        Text(
                    "user",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "duration",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "related commit msg",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Container(
                width: 107,
                height: 0,
                ),
        Container(
                width: 107,
                height: 0,
                ),
        Text(
                    "New Project",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "3:00 ",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "3:00:00 ",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "Most recent",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "Jason",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Text(
                    "Finished Timetracker ui",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                    )
                ),
        Image.asset(
                    "assets/Menu.png",
                    width: 16,
                    height: 16,
                    ),
        Image.asset(
                    "assets/Menu.png",
                    width: 16,
                    height: 16,
                    ),
        Container(
                    width: 13,
                    height: 19,
                    decoration:     BoxDecoration(
                color: Color(0xfff60000))
                    ),
        Container(
                    width: 46,
                    height: 15,
                    decoration:     BoxDecoration(
                borderRadius: BorderRadius.circular(2), 
                color: Color(0xff9d8a8a))
                    ),
        Container(
                    width: 13,
                    height: 19,
                    decoration:     BoxDecoration(
                color: Color(0xfff6cf00))
                    ),
        Image.asset(
                    "assets/Pause Squared.png",
                    width: 14,
                    height: 19,
                    ),
        Image.asset(
                    "assets/Link.png",
                    width: 12,
                    height: 19,
                    )
                ],
            );
  }
}



































































