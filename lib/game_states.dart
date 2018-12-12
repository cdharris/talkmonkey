class GameState {
  String gameText;
  List<String> gameOptions;
  int correct;
  String next;
  String special;

  int zoom;
  String expression;

  GameState({
    this.gameText,
    this.gameOptions,
    this.correct,
    this.next,
    this.special,
    this.zoom,
    this.expression,
  });
}

Map<String, GameState> gameStates = {
  'start': GameState(
    gameText:
        'On arrival to Gibraltar you see your first wild Barbary Macaque. Let’s take a close look… \nQuestion: Where else could you find wild Barbary Macaques in Europe?',
    gameOptions: [
      'Some parts of Spain',
      'The Pyrenees',
      'Nowhere else',
    ],
    correct: 2,
    next: 'Zoom1',
  ),
  'Zoom1': GameState(
    gameText:
        'As we walk closer we notice they Monkey begins to scratch itself. \nQuestion: What could this be a sign of?',
    gameOptions: [
      'Nothing to worry about',
      'Nervousness',
      'A sign of fleas',
    ],
    correct: 1,
    next: 'Zoom2',
  )
    ..expression = 'Itching'
    ..zoom = 1,
//    ..expression = 'openMouth',
  'Zoom2': GameState(
      gameText:
          'The Monkeys eyes begin to dart… \nQuestion: What do you think is happening here?',
      gameOptions: [
        'Concerned- Looking for a way out',
        'Hungry- planning possible theft',
        'Nervous- looking for its young',
      ],
      correct: 0,
      zoom: 2,
      expression: 'Darting',
      next: 'Zoom2-2'),
  'Zoom2-2': GameState(
    gameText:
        'Here we see the Monkey’s mouth is closed and the overall face is relaxed. Question: What can we understand here?',
    gameOptions: [
      'Beware - Don’t trust the monkey',
      'Relax - The monkey looks happy',
      'Upset- Cheer up with some food',
    ],
    correct: 1,
    next: 'Zoom3',
    zoom: 2,
  ),
  'Zoom3': GameState(
    gameText:
        'As we approach further we notice the Monkey’s  eyebrows begin to raise and he stares at us intently, forming a round mouth… Question: What can you understand from this facial expression?',
    gameOptions: [
      'Aggressive, showing threatening behaviour',
      'Inquisitive, showing curious behaviour',
      'Perplexed, showing signs of confusion',
    ],
    correct: 0,
    expression: 'OpenMouth',
    zoom: 3,
    next: 'win',
  )
};
