import 'package:flutter_seed/features/number_trivia/domain/entities/number_trivia.dart';

import 'package:super_enum/super_enum.dart';

part 'number_trivia_state.g.dart';

@superEnum
enum _NumberTriviaState {
  @object
  Empty,

  @object
  Loading,

  @Data(fields: [
    DataField('trivia', NumberTrivia),
  ])
  Loaded,

  @Data(fields: [
    DataField('message', String),
  ])
  Error
}
