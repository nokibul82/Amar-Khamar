import '../../../utils/app_constants.dart';

class OnBordingData {
  String imagePath;
  String title;
  String description;

  OnBordingData(
      {required this.imagePath,
      required this.title,
      required this.description});
}

List<OnBordingData> onBordingDataList = [
  OnBordingData(
      imagePath: "$rootImageDir/onbording_1.png",
      title: "Sustainable Farm\nInvesting Made Simple",
      description:
          "Phosfluorescently syndicate alternative best practices\nbefore inexpensive core for communities."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_2.png",
      title: "Sustainable Farm\nInvesting Made Simple",
      description:
          "Phosfluorescently syndicate alternative best practices\nbefore inexpensive core for communities."),
  OnBordingData(
      imagePath: "$rootImageDir/onbording_3.png",
      title: "Sustainable Farm\nInvesting Made Simple",
      description:
          "Phosfluorescently syndicate alternative best practices\nbefore inexpensive core for communities."),
];
