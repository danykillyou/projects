import 'dart:async';
import 'dart:ui';
import 'package:carousel_slider/carousel_controller.dart' as con;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'dart:ui' as ui;
class FaceDetectionFromLiveCamera extends StatefulWidget {
  const FaceDetectionFromLiveCamera({Key key}) : super(key: key);

  @override
  _FaceDetectionFromLiveCameraState createState() => _FaceDetectionFromLiveCameraState();
}

class _FaceDetectionFromLiveCameraState extends State<FaceDetectionFromLiveCamera> {

  CameraController _camera;
  CameraLensDirection _direction = CameraLensDirection.front;
  bool _isDetecting = false;
  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(mode: FaceDetectorMode.fast,
        enableLandmarks: true,));
  List<Face> faces;
  List filters =[];
  Map settings;
  var _filter,url;
  var CarouselController = con.CarouselController();



  @override
  initState()  {
    super.initState();
    _initializeCamera();
    WidgetsFlutterBinding.ensureInitialized();

    setState((){});
  }
  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_camera == null || !_camera.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _camera?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_camera != null) {
        _initializeCamera();      }
    }
  }
  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);

    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );
    // try{
    // settings= await get();
    // isConection=true;

    settings = {"https://firebasestorage.googleapis.com/v0/b/bold-cable-286310.appspot.com/o/WhatsApp_Image_2021-05-26_at_21.14.50-removebg-preview__4_-removebg-preview.png?alt=media&token=fd6ad86e-a6a0-4321-aad6-5eacd779ea66":[230,130,250,140],"https://firebasestorage.googleapis.com/v0/b/bold-cable-286310.appspot.com/o/mustache_c-removebg-preview.png?alt=media&token=1dd08b86-5e38-4869-aecd-0fa3296b30ea":[94.7,-100,110,-100],"https://firebasestorage.googleapis.com/v0/b/bold-cable-286310.appspot.com/o/DSC06508-removebg-preview.png?alt=media&token=62262612-2b67-4fe9-8589-eb5fc7d56814":[125.0,60.0,100.0,60.0],"https://firebasestorage.googleapis.com/v0/b/bold-cable-286310.appspot.com/o/Lipharoj_kaj_monoklo.svg-removebg-preview.png?alt=media&token=d71f25e2-bdd3-493c-8c1c-305293a7b4f4":[155.0,35.0,155.0,35.0],"https://firebasestorage.googleapis.com/v0/b/bold-cable-286310.appspot.com/o/sunglasses-glasses-png-image-removebg-preview.png?alt=media&token=2e4b595f-9ba0-4002-b662-7b76017ce328":[145,80.0,140.0,80.0]}; //,"https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-1100x628.jpg":[125.0,60.0,100.0,60.0]
    settings.forEach((key, value) {filters.add(key);});
    print(filters.toString());
    _filter=await getImage(filters.first);



    // }
    //   catch(e){isConection=false;
    //     settings= {'assets/images/sunglasses-glasses-png-image-removebg-preview.png':[230,40,430,40]};
    //   final ByteData data = await rootBundle.load('assets/images/sunglasses-glasses-png-image-removebg-preview.png');
    //   _filter = await loadImage(new Uint8List.view(data.buffer));}

    _camera = CameraController(
      description,
       ResolutionPreset.high,
    );
    await _camera.initialize();
  setState(() {

  });
    _camera.startImageStream((CameraImage image)
    {
      if (_isDetecting) return;

      _isDetecting = true;

      detect(image, faceDetector.processImage,
          rotation)
          .then(
            (dynamic result) {
          setState(() {
            faces = result;
          });

          _isDetecting = false;
        },
      ).catchError(
            (_) {
          _isDetecting = false;
        },
      );
    });
  }

  Future<ui.Image> getImage(String url) async {
    if(url==""){return null;}
    Completer<ImageInfo> completer = Completer();
    var img = new NetworkImage(url);
    img.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info,bool _){
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  Widget _carousel() {

    return CarouselSlider(        carouselController: CarouselController,

      options: CarouselOptions(onPageChanged: (int,reson) async {
        url=filters[int];
      // if(isConection)
          {_filter = await getImage(url);}
        // else{final ByteData data = await rootBundle.load('assets/images/sunglasses-glasses-png-image-removebg-preview.png');
        // _filter = await loadImage(new Uint8List.view(data.buffer));}
      }
          ,height: 70.0,viewportFraction: 0.23,autoPlay: true,enlargeCenterPage: true,aspectRatio: 10.0,enlargeStrategy :CenterPageEnlargeStrategy.height),
      items:  filters.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Center(
              child: GestureDetector(
                onTap: ()
                async{
                  // {try
                  // {
                  // Ensure that the camera is initialized.


                  // Attempt to take a picture and then get the location
                  // where the image file is saved.
                  if (_camera == null || !_camera.value.isInitialized) {
                    print('Error: select a camera first.');
                    return null;
                  }

                  if (_camera.value.isTakingPicture) {
                    // A capture is already pending, do nothing.
                    return null;
                  }

                  // try {
                  await _camera.stopImageStream();
                  print("camera off");
                  // await _camera.startImageStream((image) => null);
                  var image =await _camera.takePicture();
                  // await _camera.startImageStream((image) => null);
                  // var image = _capturePng;
                  // print(image.toString());

                  // if(_direction != CameraLensDirection.back){
                  // await _FFmpeg.execute("-y -i " +
                  //     image.path +
                  //     " -vf transpose=3 " +
                  //     image.path);
                  // }
                  //               var result = await ImageGallerySaver.saveFile(image.path);
                  //               print(result);
                  // // GallerySaver.saveImage(image.path);
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => DisplayPictureScreen(
                  //           // Pass the automatically generated path to
                  //           // the DisplayPictureScreen widget.
                  //           imagePath: image.path,
                  //           res:result.toString(),
                  //         ),
                  //       ));
                  // } on CameraException catch (e) {
                  //   print(e);
                  //   return null;
                  // }
                  // Uint8List image =await screenshotController.capture(delay: Duration(milliseconds: 10),pixelRatio: 1.5);
                  //Capture Done
                  // String path = await NativeScreenshot.takeScreenshot();

                  // print('Screenshot taken, path: $path');

                  // RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
                  // var image = await boundary.toImage();
                  // var byteData = await image.toByteData(format: ImageByteFormat.png);
                  // var pngBytes = byteData.buffer.asUint8List();
                  //
                  //
                  // var result = await ImageGallerySaver.saveImage( Uint8List.fromList(pngBytes),quality: 60,);
                  // print(result);

                  // final image = await _camera.takePicture();

                  // print(image.path+"took pic!!!!!!!!!!!!");


                  // await Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => FaceDetectionFromImage(image,_filter,settings[url],Size(
                  //       _camera.value.previewSize.height,
                  //       _camera.value.previewSize.width,
                  //     ),_direction== CameraLensDirection.front,ip)));
                  CarouselController.jumpToPage(0);
                  _initializeCamera();

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => DisplayPictureScreen(
                  //         // Pass the automatically generated path to
                  //         // the DisplayPictureScreen widget.
                  //         imagePath:image.path,
                  //         res: result.toString(),
                  //       ),
                  //     ));


                  // } catch (e) {
                  //   // If an error occurs, log the error to the console.
                  //   print("Exp:  "+e.toString());
                  // }
                },
                child: Container(
                  width: 70,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                      color: Colors.white12
                  ),
                  child: Center(
                    child: Image.network(i)
                    // Image.asset('assets/images/sunglasses-glasses-png-image-removebg-preview.png')
                    ,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: !_camera.value.isInitialized
            ? const Center(
          child: Text(
            'Initializing Camera...',
            style: TextStyle(
              color: Colors.green,
              fontSize: 30.0,
            ),
          ),
        )
            : Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CameraPreview(_camera,),
            _direction!= CameraLensDirection.front?Container()
            // _buildResults()
                :Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child:Container()
              // _buildResults()
              ,),


            // Positioned(top: 70,
            //   left: 170,
            //   child: Container(decoration: BoxDecoration(color:Colors.grey[100].withOpacity(0.20) ,borderRadius:BorderRadius.circular(10)),
            //     child: Row(children: [ _direction != CameraLensDirection.back? Container():GestureDetector(onTap: (){
            //       if(mode=="off"){_camera.setFlashMode(FlashMode.torch);mode="on";}
            //       else{_camera.setFlashMode(FlashMode.always); mode="off";}
            //     },child:mode=="off"? Icon(Icons.flash_on,size: 45):Icon(Icons.flash_off,size: 45,)),
            //       SizedBox(width: 10,),
            //       GestureDetector(onTap: _toggleCameraDirection,
            //         child: _direction == CameraLensDirection.back
            //             ? const Icon(Icons.camera_front,size: 30,)
            //             : const Icon(Icons.camera_rear,size: 30,),),
            //       SizedBox(width: 10,),
            //
            //
            //     ],),
            //   ),),


            // Positioned(top: 30,
            //     left: 170,
            //     child:Container(child: Text(faces.asMap().toString()),)),

                // child: Image.asset('assets/images/sunglasses-glasses-png-image-removebg-preview.png')),


            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: _carousel(),
            ),



          ],
        ),
      ),
    );
  }

}
