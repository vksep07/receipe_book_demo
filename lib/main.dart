import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/blocs/home/home_bloc.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'presentation/pages/home/home_page.dart';
import 'domain/repositories/meal_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MealRepository>(
          create: (context) => di.sl<MealRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) =>
                    HomeBloc(repository: context.read<MealRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    SearchBloc(repository: context.read<MealRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Recipe Book',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const HomePage(),
        ),
      ),
    );
  }
}
