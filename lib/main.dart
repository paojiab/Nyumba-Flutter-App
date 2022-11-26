import 'package:nyumba/LanguageChangeProvider.dart';
import 'package:nyumba/account.dart';
import 'package:nyumba/favorite.dart';
import 'package:nyumba/home_page.dart';
import 'package:nyumba/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(builder: (context) {
        return MaterialApp(
          locale: Provider.of<LanguageChangeProvider>(context, listen: true)
              .currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primarySwatch: Colors.brown,
            appBarTheme: const AppBarTheme(color: Colors.white),
          ),
          home: const RootPage(),
        );
      }),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  List<Widget> pages = const [
    HomePage(),
    Favorite(),
    Wallet(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home), label: S.of(context).home),
          NavigationDestination(
              icon: const Icon(Icons.favorite), label: S.of(context).favorites),
          NavigationDestination(
              icon: const Icon(Icons.wallet), label: S.of(context).wallet),
          NavigationDestination(
              icon: const Icon(Icons.person), label: S.of(context).account),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
