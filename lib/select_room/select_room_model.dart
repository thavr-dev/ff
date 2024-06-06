import '/flutter_flow/flutter_flow_util.dart';
import 'select_room_widget.dart' show SelectRoomWidget;
import 'package:flutter/material.dart';

class SelectRoomModel extends FlutterFlowModel<SelectRoomWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
