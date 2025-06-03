import '../service/events_service.dart';
import '../widgets/button.dart';
import '../widgets/special_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TestEventsPage extends StatefulWidget {
  const TestEventsPage({super.key});

  @override
  State<TestEventsPage> createState() => _TestEventsPageState();
}

class _TestEventsPageState extends State<TestEventsPage> {
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();

    dateTime = DateTime.now();

    EventsService.instance.trackScreenLoadEvent(
      payload: {
        'source': 'Test Events Page',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpecialAppBar(text: 'Test Events Page'),
      body: Center(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0),
          itemBuilder: (_, index) {
            return Button(
              text: 'Track event with priority: $index',
              onPressed: () {
                EventsService.instance.trackEvent(
                  eventName: 'TestEvent',
                  priority: index,
                  payload: {
                    'timeZone': dateTime.timeZoneName,
                  },
                );
              },
            );
          },
          separatorBuilder: (_, __) {
            return const Gap(12.0);
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
