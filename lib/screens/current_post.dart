class Currentpost {
  static var CAUSE;
  static var SYMPTOM;
  static var CATEGORY;
  static var DESCRIBE;
  static var USER;
  static var COMMENT;
  static var IMAGE;
  static var EMAIL;
  static String whoCurrent() {
    return "current -> cause: ${CAUSE}, symptom: ${SYMPTOM},category: ${CATEGORY}, describe: ${DESCRIBE},user:${USER},comment:${COMMENT},image:${IMAGE}, email:${EMAIL}";
  }
}
