import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:beatconnect_launch_mvp/lib.dart';

class CreateEventCtrl extends GetxController {
  final FirebaseApp _app;

  CreateEventCtrl(this._app);

  FirebaseAuth get _authApp => FirebaseAuth.instanceFor(app: _app);

  final RxString _content = "".obs;
  final Rx<DateTime> _startDate = Rx(DateTime.now());
  final Rx<LatLng?> _point = Rx(null);
  final Rx<PostVisibility> _visibility = Rx(PostVisibility.public);
  final RxBool _isUploading = false.obs;

  String get content => _content.value;
  DateTime get startDate => _startDate.value;
  LatLng? get point => _point.value;
  bool get isUploading => _isUploading.value;

  void setContent(String value) => _content.value = value;
  void setStartDate(DateTime? value) =>
      _startDate.value = value ?? DateTime.now();
  void setPoint(LatLng? value) => _point.value = value;
  void setVisibility(PostVisibility value) => _visibility.value = value;

  @override
  void onReady() {
    super.onReady();
    _point.bindStream(_getCurrentPoint());
  }

  void loadInfo(Map<String, dynamic> data) {
    _content.value = data["content"];
    _startDate.value = (data["startDate"] as Timestamp).toDate();
    _point.value = (data["point"] as GeoPoint).toLatLng();
  }

  Stream<LatLng?> _getCurrentPoint() {
    return Geolocator.getPositionStream().map(
      (event) => LatLng(
        event.latitude,
        event.longitude,
      ),
    );
  }

  void submit([String? eventRef]) async {
    _isUploading.value = true;
    _startDate
      ..validateNull(
        label: "Fecha de programacion",
      )
      ..validateDateAfter(
        label: "Fecha de programacion",
        date: DateTime.now(),
      );
    EventService.createEvent(
      eventRef: eventRef,
      accountRef: "users/${_authApp.currentUser!.uid}",
      content: _content.validateEmpty(),
      point: _point.validateNull(
        label: "Ubicacion",
      ),
      startDate: _startDate.value,
    );
    _isUploading.value = false;
    Get.back();
  }
}

class EventCtrl extends GetxController {
  final FirebaseApp _app;

  EventCtrl(this._app);

  FirebaseAuth get _authApp => FirebaseAuth.instanceFor(app: _app);

  Stream<int> getCountAssist({
    required String eventRef,
  }) =>
      EventService.countAssistOnEvent(eventRef: eventRef);

  Stream<bool> hasAssistOnEvent({
    required String eventRef,
  }) {
    return EventService.hasAssistOnEvent(
      accountRef: "users/${_authApp.currentUser!.uid}",
      eventRef: eventRef,
    );
  }

  Future<void> assistEvent({
    required String eventRef,
  }) {
    return EventService.createEventAssist(
      accountRef: "users/${_authApp.currentUser!.uid}",
      eventRef: eventRef,
    );
  }

  Future<void> deleteAssistEvent({
    required String eventRef,
  }) {
    return EventService.deleteEventAssist(
      accountRef: "users/${_authApp.currentUser!.uid}",
      eventRef: eventRef,
    );
  }
}

extension GeoPointLatLng on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}
