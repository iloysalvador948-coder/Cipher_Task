import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:cypher_task_app/services/database_service.dart';
import 'package:cypher_task_app/services/encryption_service.dart';
import 'package:cypher_task_app/services/key_storage_service.dart';
import 'package:cypher_task_app/services/session_service.dart';
import 'package:cypher_task_app/viewmodels/auth_viewmodel.dart';
import 'package:cypher_task_app/viewmodels/todo_viewmodel.dart';
import 'package:cypher_task_app/views/login_view.dart';
import 'package:cypher_task_app/views/register_view.dart';
import 'package:cypher_task_app/views/todo_list_view.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Dependency Injection
  await _setupDependencies();

  runApp(const MyApp());
}

Future<void> _setupDependencies() async {
  // Initialize services
  final keyStorageService = KeyStorageService();
  final encryptionService = EncryptionService(keyStorageService: keyStorageService);
  final databaseService = DatabaseService(keyStorageService: keyStorageService);
  final sessionService = SessionService();

  // Initialize database
  await databaseService.initializeDatabase();

  // Initialize master encryption key
  await encryptionService.initializeMasterKey();

  // Register services
  getIt.registerSingleton<KeyStorageService>(keyStorageService);
  getIt.registerSingleton<EncryptionService>(encryptionService);
  getIt.registerSingleton<DatabaseService>(databaseService);
  getIt.registerSingleton<SessionService>(sessionService);

  // Register ViewModels
  getIt.registerSingleton<AuthViewModel>(
    AuthViewModel(
      databaseService: databaseService,
      encryptionService: encryptionService,
      keyStorageService: keyStorageService,
      sessionService: sessionService,
    ),
  );

  getIt.registerSingleton<TodoViewModel>(
    TodoViewModel(
      databaseService: databaseService,
      encryptionService: encryptionService,
      sessionService: sessionService,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: getIt<AuthViewModel>(),
        ),
        ChangeNotifierProvider.value(
          value: getIt<TodoViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'CipherTask - Secure To-Do System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/todo-list': (context) => const TodoListView(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final authVM = context.read<AuthViewModel>();
      await authVM.checkAuthStatus();

      if (authVM.isAuthenticated) {
        // User is logged in, go to todo list
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/todo-list',
          (route) => false,
        );
      } else {
        // User is not logged in, go to login
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.security,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'CipherTask',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Secure Encrypted To-Do System',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
