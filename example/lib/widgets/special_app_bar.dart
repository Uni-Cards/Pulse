import '../service/events_service.dart';

import '../service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SpecialAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar _appBar;

  SpecialAppBar({
    super.key,
    required String text,
  }) : _appBar = AppBar(
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
          actions: [
            ListenableBuilder(
              listenable: AuthService.instance,
              builder: (_, __) {
                return InkWell(
                  onTap: () {
                    EventsService.instance.trackButtonTapEvent(
                      payload: {
                        'source': 'Special App Bar',
                        'isLoggedIn': AuthService.instance.isLoggedIn,
                        'who': AuthService.instance.userId,
                      },
                    );

                    AuthService.instance.isLoggedIn ? AuthService.instance.logout() : AuthService.instance.login();
                  },
                  child: Row(
                    children: [
                      // icon
                      AuthService.instance.isLoggedIn
                          ? const Icon(
                              Icons.person_2,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.person_2,
                              color: Colors.red,
                            ),

                      // gap
                      const Gap(4.0),

                      // text
                      Text(
                        AuthService.instance.isLoggedIn
                            ? '(User Id: ${AuthService.instance.userId})'
                            : '(Not logged in)',
                        // style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),

            // gap
            const Gap(12.0),
          ],
        );

  @override
  Widget build(BuildContext context) => _appBar;

  @override
  Size get preferredSize => _appBar.preferredSize;
}
