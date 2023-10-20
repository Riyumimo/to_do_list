import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/cubit/theme_cubit.dart';
import 'package:to_do_list/db/db_helper.dart';
import 'package:to_do_list/inject.dart' as it;
import 'package:to_do_list/screens/add_task/add_task_page.dart';
import 'package:to_do_list/screens/home/home_screen.dart';
import 'package:to_do_list/screens/notification_page.dart';
import 'package:to_do_list/service/navigation_service.dart';
import 'package:to_do_list/service/notifi_sercvice.dart';

import 'bloc/note_bloc.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDb();
  it.configureDependencies();
  NotifiService.notifiservice.initializeNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit()..initheme(),
        ),
        BlocProvider(
          create: (context) => it.getIt<NoteBloc>()
            ..add(NoteEvent.getNoteEvent(date: DateTime.now())),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: GoogleFonts.poppins().toString(),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark(
              useMaterial3: true,
            ),
            themeMode: state,
            onGenerateRoute: (setting) {
              switch (setting.name) {
                case '/':
                  return MaterialPageRoute(
                      builder: (context) => const MyHomePage());
                case '/add':
                  return MaterialPageRoute(
                      builder: (context) => const AddTaskPage());
                case '/test':
                  return MaterialPageRoute(
                      builder: (context) => NotificationPage(
                            note: setting.arguments as Note,
                          ));
                default:
                  Container();
              }
            },
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}
