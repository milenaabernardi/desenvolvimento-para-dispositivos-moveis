import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller/coin_controller.dart';
import 'controller/coin_detail_controller.dart';
import 'view/coin_search_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Aviso: Arquivo .env não encontrado ou erro ao ler.");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CoinController()),
        ChangeNotifierProvider(create: (context) => CoinDetailController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoHunter',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, 

      // TEMA DARK MODERNO 
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0B12), 
        
        // Definição de Cores
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFBB86FC),  
          secondary: Color(0xFF03DAC6), 
          surface: Color(0xFF1E1E2C),   
          onSurface: Colors.white,
        ),

        // Tipografia Moderna (Inter)
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        
        // AppBar Transparente
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      
      home: const CoinSearchPage(),
    );
  }
}