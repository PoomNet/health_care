class Currentpost {
   static var CAUSE;
   static var SYMPTOM;
   static var DESCRIBE;

   static String whoCurrent(){
     return "current -> cause: ${CAUSE}, symptom: ${SYMPTOM}, describe: ${DESCRIBE}";
   }
}