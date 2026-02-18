import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_state.dart';
import '../../../auth/domain/auth_user.dart';
import '../../../patients/presentation/screens/patients_screen.dart';
import '../../../users/presentation/screens/users_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final role = auth.user?.role ?? UserRole.asistente;

    return DefaultTabController(
      length: role == UserRole.asistente ? 1 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido, ${auth.user?.name ?? ''}'),
          actions: [
            IconButton(
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
            ),
          ],
          bottom: TabBar(
            tabs: [
              if (role == UserRole.admin) const Tab(text: 'Usuarios'),
              const Tab(text: 'Pacientes'),
              if (role == UserRole.medico) const Tab(text: 'Mi agenda'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            if (role == UserRole.admin) const UsersScreen(),
            const PatientsScreen(),
            if (role == UserRole.medico)
              const Center(child: Text('Módulo agenda habilitado para médico')),
          ],
        ),
      ),
    );
  }
}
