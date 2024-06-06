import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'room_join_widget.dart' show RoomJoinWidget;
import 'package:flutter/material.dart';

class RoomJoinModel extends FlutterFlowModel<RoomJoinWidget> {
  ///  Local state fields for this page.

  int? randomId = 1;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Firestore Query - Query a collection] action in roomJoin widget.
  RandomIntegerStoreRecord? listOfIntegers;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
