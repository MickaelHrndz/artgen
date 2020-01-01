import 'package:mobx/mobx.dart';
import 'dart:math';

part 'model.g.dart';

class FarrisParams = FarrisParamsBase with _$FarrisParams;

abstract class FarrisParamsBase with Store {
  static const spread = 52;
  static Random _rnd = Random();

  @observable
  int a = _rnd.nextInt(spread);
  
  @observable
  int b = _rnd.nextInt(spread);

  @action 
  void addToA(int val) => a += val;

  @action
  void addToB(int val) => b += val;

  @action
  void randomize(){
    a = _rnd.nextInt(spread);
    b = _rnd.nextInt(spread);
  }
}
