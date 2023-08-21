import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutternativetrapeze/src/utilities/device_scan/device_scan_controller/device_scan_controller.dart';
import 'package:permission_handler/permission_handler.dart';

/// This file holds (I.) Scan Progress Events; (II.) Scan Progress States; (III.) Scan Progress Bloc
// ----------------------------------------------------------------------------
/// (I.) Scan Progress Events
/// * 1. Start Scan
/// * 2. Finish Scan
/// * 3. Abort Scan
/// * 4. Error Scan
/// * 5. Update Scan

/// Abstract Scan Progress Event Class
abstract class ScanProgressEvent {}

/// * I.1. Start Scan
class StartScanEvent extends ScanProgressEvent {}

/// * I.2. Finish Scan
class FinishScanEvent extends ScanProgressEvent {
  final Directory dir;

  FinishScanEvent(this.dir);
}

/// * I.3. Abort Scan
class AbortScanEvent extends ScanProgressEvent {}

/// * I.4. Error Scan
class ErrorScanEvent extends ScanProgressEvent {
  final String reason;

  ErrorScanEvent(this.reason);
}

/// * I.5. Update Scan
class UpdateScanEvent extends ScanProgressEvent {
  final double progress;
  final String currentTask;

  UpdateScanEvent(this.progress, this.currentTask);
}

// ----------------------------------------------------------------------------
/// (II.) Scan Progress States
/// * 1. Start State
/// * 2. Finish State
/// * 3. Abort State
/// * 4. Error State
/// * 5. Update State

/// Abstract Scan Progress State Class
abstract class ScanProgressState {}

/// * II.1 Start State
class StartScanState extends ScanProgressState {}

/// * II.2 Finish State
class FinishScanState extends ScanProgressState {
  final Directory dir;

  FinishScanState(this.dir);
}

/// * II.3 Abort State
class AbortScanState extends ScanProgressState {}

/// * II.4 Error State
class ErrorScanState extends ScanProgressState {
  final String reason;

  ErrorScanState(this.reason);
}

/// * II.5 Update State
class UpdateScanState extends ScanProgressState {
  final double progress;
  final String currentTask;

  UpdateScanState(this.progress, this.currentTask);
}

// ----------------------------------------------------------------------------
/// (III.) Scan Progress Bloc
/// The Scan Progress Bloc sets states based on events
class DeviceScanProgressBloc extends Bloc<ScanProgressEvent, ScanProgressState> {
  late DeviceScanController _controller;
  // Set initial state
  DeviceScanProgressBloc() : super(StartScanState()) {
    _controller = DeviceScanController(this);
    on((event, emit) async {
      if (event is StartScanEvent) {
        PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.denied ||
            status == PermissionStatus.permanentlyDenied) {
          emit(ErrorScanState('Missing File Access Permission'));
          return;
        }
        _controller = DeviceScanController(this);
        _controller.startScan();
        emit(StartScanState());
      } else if (event is FinishScanEvent) {
        emit(FinishScanState(event.dir));
      } else if (event is AbortScanEvent) {
        _controller.abortScan();
        emit(AbortScanState());
      } else if (event is ErrorScanEvent) {
        emit(ErrorScanState(event.reason));
      } else if (event is UpdateScanEvent) {
        emit(UpdateScanState(event.progress, event.currentTask));
      }
    });
    add(StartScanEvent());
  }
}
