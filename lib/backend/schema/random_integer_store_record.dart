import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';

class RandomIntegerStoreRecord extends FirestoreRecord {
  RandomIntegerStoreRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "generatedIntegers" field.
  List<int>? _generatedIntegers;
  List<int> get generatedIntegers => _generatedIntegers ?? const [];
  bool hasGeneratedIntegers() => _generatedIntegers != null;

  void _initializeFields() {
    _generatedIntegers = getDataList(snapshotData['generatedIntegers']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('RandomIntegerStore');

  static Stream<RandomIntegerStoreRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => RandomIntegerStoreRecord.fromSnapshot(s));

  static Future<RandomIntegerStoreRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => RandomIntegerStoreRecord.fromSnapshot(s));

  static RandomIntegerStoreRecord fromSnapshot(DocumentSnapshot snapshot) =>
      RandomIntegerStoreRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static RandomIntegerStoreRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      RandomIntegerStoreRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'RandomIntegerStoreRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is RandomIntegerStoreRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createRandomIntegerStoreRecordData() {
  final firestoreData = mapToFirestore(
    <String, dynamic>{}.withoutNulls,
  );

  return firestoreData;
}

class RandomIntegerStoreRecordDocumentEquality
    implements Equality<RandomIntegerStoreRecord> {
  const RandomIntegerStoreRecordDocumentEquality();

  @override
  bool equals(RandomIntegerStoreRecord? e1, RandomIntegerStoreRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.generatedIntegers, e2?.generatedIntegers);
  }

  @override
  int hash(RandomIntegerStoreRecord? e) =>
      const ListEquality().hash([e?.generatedIntegers]);

  @override
  bool isValidKey(Object? o) => o is RandomIntegerStoreRecord;
}
