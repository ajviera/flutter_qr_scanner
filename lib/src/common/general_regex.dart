class GeneralRegex {
  static final RegExp regexEmail = RegExp(
      r"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
  static final RegExp regexPhone = RegExp(r"^\+?[1-9]\d{6,14}$");
  static final RegExp regexPassword = RegExp(r"^.{8,}$");
  static final RegExp regexWithSpace =
      RegExp(r"[a-zA-Z0-9.\s-/@_*+ñíóúáéÑÍÓÚÁÉ,]");
  static final RegExp regexWithoutSpace =
      RegExp(r"[a-zA-Z0-9.\-/@_*+ñíóúáéÑÍÓÚÁÉ,]");
  static final RegExp regexOnlyNumbers = RegExp(r"[0-9]");
  static final RegExp regexLicensePlate = RegExp(r"[a-zA-Z0-9]");
}
