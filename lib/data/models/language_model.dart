

class LanguageModel {
    String? status;
    Message? message;

    LanguageModel({
        this.status,
        this.message,
    });

    factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        status: json["status"],
        message: json["message"] == null ? null : Message.fromJson(json["message"]),
    );

}

class Message {
    List<Language>? languages;

    Message({
        this.languages,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        languages:  List<Language>.from(json["languages"].map((x) => Language.fromJson(x))),
    );

}

class Language {
    dynamic id;
    dynamic name;
    dynamic shortName;

    Language({
        this.id,
        this.name,
        this.shortName,
    });

    factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        shortName: json["short_name"] ?? '',
    );

}
