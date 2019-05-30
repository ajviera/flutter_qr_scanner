import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_scanner/src/models/qr_code.dart';
import 'package:flutter/material.dart';

final CollectionReference qrCodeCollection =
    Firestore.instance.collection('qr_codes');

class QrCodeStorage {
  final FirebaseUser user;

  QrCodeStorage.forUser({@required this.user});

  static QrCode fromDocument(DocumentSnapshot document) =>
      _fromMap(document.data);

  static QrCode _fromMap(Map<String, dynamic> data) => QrCode.fromMap(data);

  Map<String, dynamic> _toMap(QrCode item, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(item.toMap());
    result['uid'] = user.uid;

    return result;
  }

  /// Returns a stream of data snapshots for the user, paginated using limit/offset
  list({int limit, int offset}) {
    Stream<QuerySnapshot> snapshots =
        qrCodeCollection.where('uid', isEqualTo: this.user.uid).snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      // TODO can probably use _query.limit in an intelligent way with offset
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  create(String qrCode) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(qrCodeCollection.document());
      final QrCode newItem = QrCode(id: newDoc.documentID, qrCode: qrCode);
      final Map<String, dynamic> data = _toMap(newItem, {
        'created': DateTime.now().toUtc().toIso8601String(),
      });
      await tx.set(newDoc.reference, data);

      return data;
    };

    return Firestore.instance
        .runTransaction(createTransaction)
        .then(_fromMap)
        .catchError((e) {
      print('dart error: ${e.toString()}');
      return null;
    });
  }

  update(QrCode item) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot doc =
          await tx.get(qrCodeCollection.document(item.id));
      // Permission check
      if (doc['uid'] != this.user.uid) {
        throw Exception('Permission Denied');
      }

      await tx.update(doc.reference, _toMap(item));
      return {'result': true};
    };

    return Firestore.instance.runTransaction(updateTransaction).then((r) {
      return r['result'] == true; // forcefully cast to boolean
    }).catchError((e) {
      print('dart error: ${e.toString()}');
      return false;
    });
  }

  delete(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(qrCodeCollection.document(id));
      // Permission check
      if (doc['uid'] != this.user.uid) {
        throw Exception('Permission Denied');
      }

      await tx.delete(doc.reference);
      return {'result': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((r) => r['result'])
        .catchError(
      (e) {
        print('dart error: ${e.toString()}');
        return false;
      },
    );
  }
}
