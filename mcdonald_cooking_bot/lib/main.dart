import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules/orders/view/orders_page.dart';
import 'modules/bots/view/bots_page.dart';
import 'modules/orders/view_model/orders_view_model.dart';
import 'modules/bots/view_model/bots_view_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => OrdersViewModel()),
        ChangeNotifierProxyProvider<OrdersViewModel, BotsViewModel>(
          lazy: false,
          create: (ctx) => BotsViewModel(ctx.read<OrdersViewModel>()),
          update: (ctx, ordersVm, botsVm) {
            botsVm ??= BotsViewModel(ordersVm);
            botsVm.attach(ordersVm);
            return botsVm;
          },
        ),
      ],
      child: MaterialApp(
        title: 'McDonalds Cooking Bot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: const MainTabPage(),
      ),
    );
  }
}

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [OrdersPage(), BotsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('McDonald Cooking Bot')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'Bots'),
        ],
      ),
    );
  }
}
