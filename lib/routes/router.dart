import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter_seed/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter_seed/features/start/presentation/pages/start_page.dart';

@autoRouter
class $Router {
  @initial
  StartPage startPage;
  NumberTriviaPage numberTriviaPage;
}
