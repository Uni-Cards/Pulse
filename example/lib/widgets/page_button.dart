import '../service/events_service.dart';
import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final Widget widget;
  final String text;

  const PageButton({
    super.key,
    required this.widget,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      child: Text(text),
      onPressed: () {
        EventsService.instance.trackButtonTapEvent(
          payload: {
            'source': 'Page Button',
            'label': text,
          },
        );

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => widget,
          ),
        );
      },
    );
  }
}
