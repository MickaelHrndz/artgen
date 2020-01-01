// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FarrisParams on FarrisParamsBase, Store {
  final _$aAtom = Atom(name: 'FarrisParamsBase.a');

  @override
  int get a {
    _$aAtom.context.enforceReadPolicy(_$aAtom);
    _$aAtom.reportObserved();
    return super.a;
  }

  @override
  set a(int value) {
    _$aAtom.context.conditionallyRunInAction(() {
      super.a = value;
      _$aAtom.reportChanged();
    }, _$aAtom, name: '${_$aAtom.name}_set');
  }

  final _$bAtom = Atom(name: 'FarrisParamsBase.b');

  @override
  int get b {
    _$bAtom.context.enforceReadPolicy(_$bAtom);
    _$bAtom.reportObserved();
    return super.b;
  }

  @override
  set b(int value) {
    _$bAtom.context.conditionallyRunInAction(() {
      super.b = value;
      _$bAtom.reportChanged();
    }, _$bAtom, name: '${_$bAtom.name}_set');
  }

  final _$FarrisParamsBaseActionController =
      ActionController(name: 'FarrisParamsBase');

  @override
  void addToA(int val) {
    final _$actionInfo = _$FarrisParamsBaseActionController.startAction();
    try {
      return super.addToA(val);
    } finally {
      _$FarrisParamsBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToB(int val) {
    final _$actionInfo = _$FarrisParamsBaseActionController.startAction();
    try {
      return super.addToB(val);
    } finally {
      _$FarrisParamsBaseActionController.endAction(_$actionInfo);
    }
  }
}
