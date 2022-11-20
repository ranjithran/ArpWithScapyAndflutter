import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Core/Services/socket_client.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'Views/routerg.dart';
import 'locator.dart';

void main() {
  setupLocators();
  SocketClientForMe().initSocket();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(
        scheme: FlexScheme.mallardGreen,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        colors: FlexColor.schemes[FlexScheme.mallardGreen]!.light.defaultError.toDark(10, false),
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) => ResponsiveWrapper.builder(child,
          maxWidth: 1920,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
          ],
          background: Container(color: const Color(0xFFF5F5F5))),
      initialRoute: "/",
      onGenerateRoute: RouterG.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
