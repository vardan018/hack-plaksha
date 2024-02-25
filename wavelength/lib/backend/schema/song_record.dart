import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SongRecord extends FirestoreRecord {
  SongRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "songname" field.
  String? _songname;
  String get songname => _songname ?? '';
  bool hasSongname() => _songname != null;

  void _initializeFields() {
    _songname = snapshotData['songname'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('song');

  static Stream<SongRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SongRecord.fromSnapshot(s));

  static Future<SongRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SongRecord.fromSnapshot(s));

  static SongRecord fromSnapshot(DocumentSnapshot snapshot) => SongRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SongRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SongRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SongRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SongRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSongRecordData({
  String? songname,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'songname': songname,
    }.withoutNulls,
  );

  return firestoreData;
}

class SongRecordDocumentEquality implements Equality<SongRecord> {
  const SongRecordDocumentEquality();

  @override
  bool equals(SongRecord? e1, SongRecord? e2) {
    return e1?.songname == e2?.songname;
  }

  @override
  int hash(SongRecord? e) => const ListEquality().hash([e?.songname]);

  @override
  bool isValidKey(Object? o) => o is SongRecord;
}
