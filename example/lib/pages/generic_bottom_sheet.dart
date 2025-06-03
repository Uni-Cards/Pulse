import '../widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../service/events_service.dart';

class GenericBottomSheet extends StatefulWidget {
  final String title;
  final String description;

  const GenericBottomSheet({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<GenericBottomSheet> createState() => _GenericBottomSheetState();
}

class _GenericBottomSheetState extends State<GenericBottomSheet> {
  @override
  void initState() {
    super.initState();

    EventsService.instance.trackScreenLoadEvent(payload: {
      'pageType': 'Generic Bottom Sheet',
      'pageTitle': widget.title,
      'pageDescription': widget.description,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18.0),
            ),
            const Gap(8.0),
            Text(widget.description),
            const Gap(24.0),
            Button(
              text: 'Close',
              onPressed: () {
                EventsService.instance.trackButtonTapEvent(payload: {
                  'source': 'Generic Bottom Sheet',
                  'buttonLabel': 'Close',
                });

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
