import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/BLoc/auth/current/current_user_bloc.dart';
import '../../application/BLoc/auth/current/current_user_event.dart';
import '../../application/BLoc/auth/current/current_user_state.dart';
import 'dialog_darken_window.dart';

class TokenLoginStateChecker extends StatefulWidget {
  const TokenLoginStateChecker({super.key});

  @override
  _TokenLoginStateCheckerState createState() => _TokenLoginStateCheckerState();
}

class _TokenLoginStateCheckerState extends State<TokenLoginStateChecker> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentUserBloc>().add(FetchCurrentUser());
  }

  //DEBUG ventanita para probar
  void showCurrentUserPopup(BuildContext context, CurrentUserLoaded user) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AnimatedSuccessDialog(
            title: "Usuario Encontrado!",
            message: "${user.phone}\n${user.name}\n${user.type}\n${user.email}",
            buttonText: 'Okey',
            onButtonPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icons.person,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentUserBloc, CurrentUserState>(
      listener: (context, state) {
        if (state is CurrentUserLoaded) {
          showCurrentUserPopup(context, state);
        }
      },
      builder: (context, state) {
        if (state is CurrentUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CurrentUserError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CurrentUserBloc>().add(FetchCurrentUser());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
