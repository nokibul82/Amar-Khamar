

class ViewTicketModel {
    Data? data;

    ViewTicketModel({
        this.data,
    });

    factory ViewTicketModel.fromJson(Map<String, dynamic> json) => ViewTicketModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

  
}

class Data {
    dynamic id;
    dynamic ticket;
    dynamic subject;
    dynamic lastReply;
    dynamic status;
    List<Message>? messages;

    Data({
        this.id,
        this.ticket,
        this.subject,
        this.lastReply,
        this.status,
        this.messages,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        ticket: json["ticket"],
        subject: json["subject"],
        lastReply: json["last_reply"] == null ? null : DateTime.parse(json["last_reply"]),
        status: json["status"],
        messages: json["messages"] == null ? [] : List<Message>.from(json["messages"]!.map((x) => Message.fromJson(x))),
    );

 
}

class Message {
    dynamic id;
    dynamic supportTicketId;
    dynamic adminId;
    dynamic message;
    dynamic createdAt;
    dynamic adminImage;
    List<Attachment>? attachment;

    Message({
        this.id,
        this.supportTicketId,
        this.adminId,
        this.message,
        this.createdAt,
        this.adminImage,
        this.attachment,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        supportTicketId: json["support_ticket_id"],
        adminId: json["admin_id"],
        message: json["message"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        adminImage: json["admin_image"],
        attachment: json["attachment"] == null ? [] : List<Attachment>.from(json["attachment"]!.map((x) => Attachment.fromJson(x))),
    );

}

class Attachment {
    dynamic id;
    dynamic file;

    Attachment({
        this.id,
        this.file,
    });

    factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        file: json["file"],
    );

 
}
