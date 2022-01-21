//const functions = require('firebase-functions');
//const admin = require("firebase-admin");
//
//
//admin.initializeApp(functions.config().firebase);
////console.log("9999999999999999999999999999999999999")
//var msgdata;
//
//exports.msgTriger1 =functions.firestore.document(
//"/test").onCreate((snapshot,context) => {
////msgdata = snapshot.data();
//console.log("i am a big logggggggggggg");
////print("ooooo")
////admin.firestore().collection("Users").get().then((snapshot) => {
////var tokens =[];
////if(snapshot.empty){console.log("no devices");}
////else{
////for (var token of snapshot.documents){
////console.log(token)
////tokens.push(token.data().token);
////}
////
//var pyload ={
//"notification":{
//"title": "from"+msgdata.sendby,
//"body":msgdata.mess,
//"sound":"default"
//},
//"data":{"sendername":msgdata.sendby,"message":msgdata.mess}
//
//}
//}
////return admin.messaging().sendToDevice(tokens,pyload).then((response)=>{
////console.log("pushed all");
////}).catch((e)=>{console.log(e)});
////})
//});
//
//
//
//
//
//
//
//
//// // Create and Deploy Your First Cloud Functions
//// // https://firebase.google.com/docs/functions/write-firebase-functions
////
//// exports.helloWorld = functions.https.onRequest((request, response) => {
////   functions.logger.info("Hello logs!", {structuredData: true});
////   response.send("Hello from Firebase!");
//// });
// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

// Take the text parameter passed to this HTTP endpoint and insert it into
// Cloud Firestore under the path /messages/:documentId/original
//exports.addMessage = functions.https.onRequest(async (req, res) => {
//  // Grab the text parameter.
//  const original = req.query.text;
//  // Push the new message into Cloud Firestore using the Firebase Admin SDK.
//  const writeResult = await admin.firestore().collection('messages').add({"a":original});
//  // Send back a message that we've successfully written the message
//  res.json({result: `Message with ID: ${writeResult.id} added.`});
//});

// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
exports.sendmess = functions.firestore.document('chat_rooms/{roomid}/chat/{chat}')
    .onCreate(async(snap, context) => {
      // Grab the current value of what was written to Cloud Firestore.
      functions.logger.log("mess is ",snap.data().mess);
      functions.logger.log("roomid",context.params.roomid);
      var sendto = await admin.firestore().collection("chat_rooms").doc(context.params.roomid).get();
      var users1;
      var grup_name=" ";
//      sendto = await sendto.where("room_id","==",context.params.roomid);
//      sendto.forEach((async(snapshot) => {
        users1=sendto.data().users;
        if(sendto.data().name!=null)
        {grup_name=sendto.data().name+": ";}
//      }));
      var user_sendto=[];
      var user_sentfrom;
       functions.logger.log("sendto: ",users1);

       users1.filter((item) => {if(item == snap.data().sendby){
      user_sentfrom=item; }
      else{user_sendto.push(item);}});
//      users1.filter((item) =>{if(item !=user_sentfrom ){
//      user_sendto=item;}});
//        users1.remove(user_sentfrom);
//       functions.logger.log("sendto_11: ",users1);

      functions.logger.log("final user ",user_sendto)
      functions.logger.log("send from user ",user_sentfrom)
      var mess = snap.data().mess;
      var tokens1 =[];
    var snapshots= admin.firestore().collection('Users');

    user_sendto.forEach(async(item) => {



        snapshots =await snapshots.where("name","==", item ).get();
        snapshots.forEach(async(snapshot) => {
    functions.logger.log("snapshot data: ",snapshot.data());
 functions.logger.log("snapshot: ",snapshot.data());
//    if(snapshot.empty){functions.logger.log("no devices",snapshot);}
//    else{
            var token=snapshot.data().tokens;
        functions.logger.log("token:  ",token);

//    }
    var payload ={
    "notification":{
    "title": grup_name+"from "+user_sentfrom,
    "body":snap.data().mess,
    "sound":"default",
    "visibility":"1","priority": "PRIORITY_HIGH ",
    },
    "data":{"sendername":snap.data().sendby,"message":snap.data().mess}

    }
     await admin.messaging().sendToDevice(snapshot.data().tokens,payload);

      // Access the parameter `{documentId}` with `context.params`
      functions.logger.log(tokens1);
 });
 });

//      const uppercase = mess;

      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to Cloud Firestore.
      // Setting an 'uppercase' field in Cloud Firestore document returns a Promise.
//      return snap.ref.set({uppercase}, {merge: true});
    });
