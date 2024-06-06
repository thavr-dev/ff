import '/flutter_flow/flutter_flow_util.dart';
import 'placer_widget.dart' show PlacerWidget;
import 'package:flutter/material.dart';

class PlacerModel extends FlutterFlowModel<PlacerWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
