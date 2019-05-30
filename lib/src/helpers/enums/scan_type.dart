enum SCANTYPE {
  WEB,
  TEXT,
  VCARD,
}

String textFromScanType(SCANTYPE scanType) {
  switch (scanType) {
    case SCANTYPE.TEXT:
      return 'TEXT';
    case SCANTYPE.VCARD:
      return 'VCARD';
    case SCANTYPE.WEB:
      return 'WEB';
  }
  return '';
}
