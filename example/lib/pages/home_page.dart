import 'package:flutter/material.dart';

import '../widgets/page_button.dart';
import '../widgets/special_app_bar.dart';
import 'generic_page.dart';
import '../pages/test_events_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpecialAppBar(
        text: 'Pulse Events SDK Example App',
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PageButton(
              text: 'Test Events Page',
              widget: TestEventsPage(),
            ),
            PageButton(
              text: 'Page 1',
              widget: GenericPage(pageName: 'Page 1'),
            ),
            PageButton(
              text: 'Page 2',
              widget: GenericPage(pageName: 'Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}
