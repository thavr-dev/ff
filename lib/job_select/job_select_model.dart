import '/flutter_flow/flutter_flow_util.dart';
import 'job_select_widget.dart' show JobSelectWidget;
import 'package:flutter/material.dart';

class JobSelectModel extends FlutterFlowModel<JobSelectWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
