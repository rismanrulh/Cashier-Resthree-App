import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/core.dart';
import 'package:flutter_posresto_app/data/datasource/auth_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_posresto_app/presentation/auth/login_page.dart';

import '../../data/models/response/auth_response_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? user;
  @override
  void initState() {
    AuthLocalDatasource().getAuthData().then((value) {
      setState(() {
        user = value.user;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
      body: Center(
        child: Text('Welcome ${user?.name ?? 'to dashboard!'}'),
      ),
    );
  }
}
