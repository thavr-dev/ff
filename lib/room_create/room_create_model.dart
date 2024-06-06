import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'room_create_widget.dart' show RoomCreateWidget;
import 'package:flutter/material.dart';

class RoomCreateModel extends FlutterFlowModel<RoomCreateWidget> {
  ///  Local state fields for this page.

  int? randomId = 1;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in roomCreate widget.
  RandomIntegerStoreRecord? listOfIntegers;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
