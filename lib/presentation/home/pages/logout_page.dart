import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/core.dart';
import 'package:flutter_posresto_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_posresto_app/presentation/auth/login_page.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
        actions: [
          BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                error: (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
                success: (value) {
                  AuthLocalDatasource().removeAuthData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logout success'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }), (route) => false);
                },
              );
            },
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<LogoutBloc>().add(const LogoutEvent.logout());
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('logout page'),
      ),
    );
  }
}
