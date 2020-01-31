import 'package:super_enum/super_enum.dart';

part 'number_trivia_event.g.dart';

@superEnum
enum _NumberTriviaEvent {
@Data(fields: [
  DataField('numberString', String),
])
GetTriviaForConcreteNumberEvent,

@object
GetTriviaForRandomNumberEvent,}