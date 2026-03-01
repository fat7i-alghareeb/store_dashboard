import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_dashboard/catigory_manager.dart';
import 'package:store_dashboard/controller/admin/admin_bloc.dart';
import 'package:store_dashboard/deals_manager.dart';
import 'package:store_dashboard/product_editor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // // 1️⃣ Read the persisted session
  // final session = Supabase.instance.client.auth.currentSession;
  // // 2️⃣ Determine if we already have a user
  // final bool loggedIn = session != null;
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AdminBloc())],
      child: StoreControlPanel(),
    ),
  );
}

class StoreControlPanel extends StatelessWidget {
  const StoreControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Wizard Control',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E2C),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF2D2D3A)),
      ),
      home: const WizardHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WizardHome extends StatefulWidget {
  const WizardHome({super.key});

  @override
  State<WizardHome> createState() => _WizardHomeState();
}

class _WizardHomeState extends State<WizardHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CategoryManager(),
    ProductEditor(),
    // DealsManagerScreen(),
    // Add other panels like OrderManager(), SettingsPanel(), etc.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store Management Wizard')),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.edit, color: Colors.white),
            label: 'Edit Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Deals',
          ),

          // NavigationDestination(icon: Icon(Icons.edit), label: 'Speichal Products'),
          // NavigationDestination(icon: Icon(Icons.edit), label: 'Admins'),
        ],
      ),
    );
  }
}
