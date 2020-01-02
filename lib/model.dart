import 'package:mobx/mobx.dart';
import 'dart:math';

part 'model.g.dart';

class FarrisParams = FarrisParamsBase with _$FarrisParams;

abstract class FarrisParamsBase with Store {

  // Random object
  static Random _rnd = Random();

  // Random value's spread
  static const spread = 52;

  @observable
  int a = _rnd.nextInt(spread);
  
  @observable
  int b = _rnd.nextInt(spread);

  @action 
  void addToA(int val) => a += val;

  @action
  void addToB(int val) => b += val;

  // Set a and b to random values according to the spread
  @action
  void randomize(){
    a = _rnd.nextInt(spread);
    b = _rnd.nextInt(spread);
  }
}
