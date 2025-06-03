import 'dart:developer';
import 'dart:math' as math;

import 'generic_bottom_sheet.dart';
import '../service/events_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../widgets/button.dart';
import '../widgets/special_app_bar.dart';

const kMaxChooseNumber = 42; // the answer to life universe & everything!

class GenericPage extends StatefulWidget {
  final String pageName;

  const GenericPage({
    super.key,
    required this.pageName,
  });

  @override
  State<GenericPage> createState() => _GenericPageState();
}

class _GenericPageState extends State<GenericPage> {
  final sliderValueNotifier = ValueNotifier<double>(0.0);
  final switchValueNotifier = ValueNotifier<bool>(true);

  int theChoosenNumber = 1;

  void _selectChoosenNumber() {
    theChoosenNumber = math.Random().nextInt(kMaxChooseNumber) + 1;
    log('The winning number is: $theChoosenNumber');
  }

  @override
  void initState() {
    super.initState();

    _selectChoosenNumber();

    EventsService.instance.trackScreenLoadEvent(payload: {
      'pageType': 'Generic Page',
      'pageName': widget.pageName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpecialAppBar(
        text: widget.pageName,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          // text
          const Text(
            'This is a generic page, contains couple of buttons, few sliders & toggle buttons.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),

          // gap
          const Gap(24.0),

          // buttons
          const Text('Do you agree? (Agree with me on anything)'),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button(
                text: 'Agree',
                onPressed: () {
                  // log event
                  EventsService.instance.trackButtonTapEvent(
                    payload: {
                      'source': 'Generic Page - ${widget.pageName}',
                      'title': 'Do you agree?',
                      'label': 'Agree',
                    },
                  );
                },
              ),
              Button(
                text: 'Deny',
                onPressed: () {
                  // log event
                  EventsService.instance.trackButtonTapEvent(
                    payload: {
                      'source': 'Generic Page - ${widget.pageName}',
                      'title': 'Do you agree?',
                      'label': 'Deny',
                    },
                  );
                },
              ),
            ],
          ),

          // gap
          const Gap(24.0),

          // slider
          ValueListenableBuilder(
            valueListenable: sliderValueNotifier,
            builder: (_, sliderValue, __) {
              return Text('Select a value which you think could be lucky. (${sliderValue.toStringAsFixed(2)})');
            },
          ),
          ValueListenableBuilder(
            valueListenable: sliderValueNotifier,
            builder: (_, sliderValue, __) {
              return Slider(
                min: 0.0,
                max: 100.0,
                divisions: 500,
                value: sliderValue,
                onChanged: (newValue) {
                  sliderValueNotifier.value = newValue;
                },
                onChangeEnd: (sliderValue) {
                  // log event
                  EventsService.instance.trackEvent(
                    eventName: 'OnSliderChangeEnd',
                    payload: {
                      'source': 'Generic Page',
                      'pageName': widget.pageName,
                      'sliderValue': sliderValue,
                    },
                    priority: 3,
                  );
                },
              );
            },
          ),

          const Gap(24.0),

          // switch
          Row(
            children: [
              const Text('Do you like this app?'),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: switchValueNotifier,
                builder: (_, switchValue, __) {
                  return CupertinoSwitch(
                    value: switchValue,
                    onChanged: (newValue) {
                      switchValueNotifier.value = newValue;

                      EventsService.instance.trackEvent(
                        eventName: 'OnSwitchToggled',
                        payload: {
                          'source': 'Generic Page',
                          'pageName': widget.pageName,
                          'switchValue': newValue,
                        },
                        priority: 3,
                      );
                    },
                  );
                },
              ),
            ],
          ),

          // gap
          const Gap(24.0),

          // button grid
          const Text('The grid game'),
          Wrap(
            children: List.generate(kMaxChooseNumber, (index) => index + 1)
                .map<Widget>(
                  (v) => Button(
                    text: v.toString(),
                    onPressed: () async {
                      EventsService.instance.trackButtonTapEvent(payload: {
                        'source': 'Generic Page - ${widget.pageName}',
                        'label': v,
                        'isTheWinningNumber': v == kMaxChooseNumber,
                      });

                      if (v == theChoosenNumber) {
                        await showModalBottomSheet(
                          context: context,
                          builder: (_) => GenericBottomSheet(
                            title: 'Yaay! You have won.',
                            description: 'What have you won? Well.. nothing! Anyway the winning number was $v',
                          ),
                        );

                        _selectChoosenNumber();
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
