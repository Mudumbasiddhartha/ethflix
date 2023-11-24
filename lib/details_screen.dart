import 'dart:async';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:ethflix/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late VideoPlayerController _videoPlayerController,
      _videoPlayerController2,
      _videoPlayerController3;

  late CustomVideoPlayerController _customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
      CustomVideoPlayerWebSettings(
    src: longVideo,
  );
  //create a variable to store duration of video watched
  Duration _videoDuration = Duration.zero;
  Timer? _paymentTimer;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(longVideo),
    )..initialize().then((value) => setState(() {}));
    _videoPlayerController.play();
    _videoPlayerController2 =
        VideoPlayerController.networkUrl(Uri.parse(video240));
    _videoPlayerController3 =
        VideoPlayerController.networkUrl(Uri.parse(video480));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      additionalVideoSources: {
        "240p": _videoPlayerController2,
        "480p": _videoPlayerController3,
        "720p": _videoPlayerController,
      },
    );

    _customVideoPlayerWebController = CustomVideoPlayerWebController(
      webVideoPlayerSettings: _customVideoPlayerWebSettings,
    );
    _videoPlayerController.addListener(() {
      //update the duration of video watched
      _videoDuration =
          _customVideoPlayerController.videoPlayerController.value.position;
    });
    // Start the payment timer to send video duration every 2 seconds
    // _paymentTimer = Timer.periodic(Duration(seconds: 2), (timer) {
    //   _sendPaymentToGateway(_videoDuration);
    // });
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    _paymentTimer?.cancel(); // Cancel the timer when disposing the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black26,
        title: Text(
          "FootBall Mumbai FC vs Delhi FC",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WillPopScope(
        // Prevent user from moving back
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: ListView(
            children: [
              kIsWeb
                  ? Expanded(
                      child: CustomVideoPlayerWeb(
                        customVideoPlayerWebController:
                            _customVideoPlayerWebController,
                      ),
                    )
                  : CustomVideoPlayer(
                      customVideoPlayerController: _customVideoPlayerController,
                    ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                child: const Text("Play Fullscreen"),
                onPressed: () {
                  if (kIsWeb) {
                    _customVideoPlayerWebController.setFullscreen(true);
                    _customVideoPlayerWebController.play();
                  } else {
                    _customVideoPlayerController.setFullscreen(true);
                    _customVideoPlayerController.videoPlayerController.play();
                  }
                },
              ),
              ListTile(
                title: const Text("Video Duration"),
                subtitle: Text("Video Duration: $_videoDuration"),
              ),
              SizedBox(
                height: 250,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 5, 143, 255)),
                    overlayColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 0, 128, 255)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                    //shape must be stadiumBorder
                    shape: MaterialStateProperty.all(StadiumBorder()),
                  ),
                  onPressed: () {
                    // Show the confirmation dialog
                    _videoPlayerController.pause();
                    showDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text("Are you sure you want to checkout?"),
                        actions: [
                          TextButton(
                            child: Text("Yes"),
                            onPressed: () {
                              _sendPaymentToGateway(_videoDuration);
                              // Stop the timer when checking out
                              _paymentTimer?.cancel();
                              double cost = _calculateCost(_videoDuration);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PaymentScreen(cost: cost)));
                            },
                          ),
                          TextButton(
                            child: Text("No"),
                            onPressed: () {
                              _videoPlayerController.play();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.ethereum,
                          color: Colors.white,
                          size: 35,
                        ),
                        Text(
                          "Checkout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 35,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateCost(Duration videoDuration) {
    return (videoDuration.inSeconds * 0.00042);
  }

  void _sendPaymentToGateway(Duration videoDuration) {
    // Simulate sending the duration to the payment gateway
    print("Sending payment for ${videoDuration.inSeconds} seconds");
    // Replace this with actual payment gateway integration
  }
}

String videoUrlLandscape =
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
String videoUrlPortrait =
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
String longVideo =
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

String video720 =
    "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4";

String video480 =
    "https://www.sample-videos.com/video123/mp4/480/big_buck_bunny_480p_10mb.mp4";

String video240 =
    "https://www.sample-videos.com/video123/mp4/240/big_buck_bunny_240p_10mb.mp4";
