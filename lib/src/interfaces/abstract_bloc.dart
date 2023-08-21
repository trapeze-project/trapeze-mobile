import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// This [AbstractBloc] class implements the barebone structure of every Bloc.
///
/// We have Model generic [M]
/// We have a Handler generic [H]
abstract class AbstractBloc<M, H> {
  /// This [BehaviorSubject] Object has the Stream Property we publish unto.
  @protected
  // ignore: close_sinks
  final BehaviorSubject<M> publisher = BehaviorSubject<M>();

  /// This handler field is used to modify the model [M].
  @protected
  abstract final H handler;

  void dispose() {
    this.publisher.close();
  }

  /// Getter to get the current stream
  get bloc => this.publisher.stream;
}
