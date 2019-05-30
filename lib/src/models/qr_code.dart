import 'package:flutter/material.dart';

class QrCode {
  final String id;
  final String qrCode;

  QrCode({
    @required this.id,
    @required this.qrCode,
  })  : assert(id != null && id.isNotEmpty),
        assert(qrCode != null);

  QrCode.fromMap(Map<String, dynamic> data)
      : this(id: data['id'], qrCode: data['qr_code']);

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'qr_code': this.qrCode,
      };
}
