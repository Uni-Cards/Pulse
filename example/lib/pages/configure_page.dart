import '../service/storage_service.dart';

import 'home_page.dart';
import '../service/events_service.dart';

import '../service/auth_service.dart';
import '../widgets/special_app_bar.dart';

import '../widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConfigurePage extends StatelessWidget {
  final TextEditingController baseUrlTextEditingController;
  final TextEditingController configureEndpointTextEditingController;

  ConfigurePage({super.key})
      : baseUrlTextEditingController = TextEditingController(
          text: StorageService.instance.baseUrl,
        ),
        configureEndpointTextEditingController = TextEditingController(
          text: StorageService.instance.configureEndPoint,
        );

  final debugModeValueNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpecialAppBar(
        text: 'Configuration Page',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // base url
              const Text('Base Url'),
              TextField(
                controller: baseUrlTextEditingController,
                decoration: const InputDecoration(
                  hintText: 'https://www.my-events-server.com',
                ),
              ),

              // configure endpoint
              const Gap(24.0),
              const Text('Configure Endpoint'),
              TextField(
                controller: configureEndpointTextEditingController,
                decoration: const InputDecoration(
                  hintText: '/configure',
                ),
              ),

              // user info
              const Gap(24.0),
              const Text('User Info'),
              ListenableBuilder(
                listenable: AuthService.instance,
                builder: (_, __) {
                  final userId = AuthService.instance.userId;

                  if (userId == null) {
                    return Button(
                      text: 'Login',
                      onPressed: () {
                        AuthService.instance.login();
                      },
                    );
                  }

                  return Row(
                    children: [
                      Text('Logged in as user: ${AuthService.instance.userId}'),
                      const Spacer(),
                      Button(
                        text: 'Logout',
                        onPressed: () {
                          AuthService.instance.logout();
                        },
                      ),
                    ],
                  );
                },
              ),

              // debug mode
              const Gap(24.0),
              Row(
                children: [
                  const Text('Enable debug mode'),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: debugModeValueNotifier,
                    builder: (_, debugMode, __) {
                      return CupertinoSwitch(
                        value: debugMode,
                        onChanged: (debugModeValue) {
                          debugModeValueNotifier.value = debugModeValue;
                        },
                      );
                    },
                  ),
                ],
              ),

              const Gap(24.0),

              Builder(
                builder: (context) {
                  return Button(
                    text: 'Configure',
                    onPressed: () async {
                      final baseUrl = baseUrlTextEditingController.text;
                      final configureEndpoint = configureEndpointTextEditingController.text;

                      if (baseUrl.isEmpty || configureEndpoint.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Empty configurations',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // store the baseUrl & configureEndpoint values
                      StorageService.instance.baseUrl = baseUrl;
                      StorageService.instance.configureEndPoint = configureEndpoint;

                      final configured = await EventsService.instance.configure(
                        baseUrl: baseUrlTextEditingController.text,
                        configureEndpoint: configureEndpointTextEditingController.text,
                        debugMode: debugModeValueNotifier.value,
                      );

                      // if configuration failed
                      if (!configured && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Configuration Failed',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // if user is logged in set the user id
                      if (configured && AuthService.instance.isLoggedIn) {
                        EventsService.instance.setUserId(AuthService.instance.userId!);
                      }

                      // move to next screen
                      if (configured && context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) {
                              return const HomePage();
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
