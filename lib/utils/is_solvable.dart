import 'dart:math';

bool isSolvable(List<int> puzzle) {
  final int _puzzleDimension = sqrt(puzzle.length).toInt();
  final int _emptyPositionRow = ((puzzle.indexOf(0)) ~/ _puzzleDimension) + 1;

  // inversions
  int _inversions = 0;

  for(int i = 0; i < puzzle.length; i++) {
    final _current = puzzle[i];

    if(_current == 1) continue;
    for(int j = i + 1; j < puzzle.length; j++) {
      final _next = puzzle[j];

      if(_current > _next && _next != 0) _inversions ++;
    }
  }

  // Check if is solvable
  if(_puzzleDimension.isOdd) {
    return _inversions.isEven; // Inversions are even and Dimension is odd, puzzle is solvable
  } else {
    if(((_puzzleDimension - _emptyPositionRow + 1).isEven && _inversions.isOdd) || ((_puzzleDimension - _emptyPositionRow + 1).isOdd && _inversions.isEven)) { // Empty point from bottom is even and inversions are odd or Empty point from bottom is odd and inversions are even
      return true; // Puzzle is solvable
    } else {
      return false; // Puzzle isn't solvable
    }
  }
}