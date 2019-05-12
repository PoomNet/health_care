class Currentpost {
   static var CAUSE;
   static var SYMPTOM;
   static var CATEGORY;
   static var DESCRIBE;

   static String whoCurrent(){
     return "current -> cause: ${CAUSE}, symptom: ${SYMPTOM},category: ${CATEGORY}, describe: ${DESCRIBE}";
   }
}