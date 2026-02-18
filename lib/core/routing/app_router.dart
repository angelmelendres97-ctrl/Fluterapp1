import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/patients/presentation/screens/patients_screen.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../constants/user_roles.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLogin = state.matchedLocation == '/login';
      if (!authState.isAuthenticated && !isLogin) {
        return '/login';
      }
      if (authState.isAuthenticated && isLogin) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeShell()),
      GoRoute(path: '/users', builder: (_, __) => const UsersScreen()),
      GoRoute(path: '/patients', builder: (_, __) => const PatientsScreen()),
    ],
  );
});

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final role = user?.role ?? UserRole.assistant;

    final modules = <({String label, String route, IconData icon})>[
      (label: 'Pacientes', route: '/patients', icon: Icons.personal_injury),
      if (role == UserRole.admin)
        (label: 'Usuarios', route: '/users', icon: Icons.manage_accounts),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${user?.name ?? ''} (${role.value})'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: modules
            .map(
              (module) => Card(
                child: ListTile(
                  leading: Icon(module.icon),
                  title: Text(module.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(module.route),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
