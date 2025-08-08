class ProjectModel {
  List<Datum>? data;

  ProjectModel({
    this.data,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  dynamic id;
  dynamic location;
  dynamic totalUnits;
  dynamic projectDuration;
  dynamic projectDurationType;
  dynamic datumReturn;
  dynamic datumReturnMin;
  dynamic datumReturnMax;
  dynamic returnType;
  dynamic returnPeriod;
  dynamic returnPeriodType;
  dynamic numberOfReturn;
  dynamic minimumInvest;
  dynamic maximumInvest;
  dynamic fixedInvest;
  dynamic thumbnailImage;
  List<dynamic>? images;
  dynamic startDate;
  dynamic expiryDate;
  dynamic amountHasFixed;
  dynamic projectDurationHasUnlimited;
  dynamic numberOfReturnHasUnlimited;
  dynamic status;
  dynamic availableUnits;
  dynamic maturity;
  dynamic capitalBack;
  dynamic investLastDate;
  dynamic createdAt;
  dynamic updatedAt;
  Details? details;
  dynamic baseCurrency;
  dynamic currencySymbol;

  Datum({
    this.id,
    this.location,
    this.totalUnits,
    this.projectDuration,
    this.projectDurationType,
    this.datumReturn,
    this.datumReturnMin,
    this.datumReturnMax,
    this.returnType,
    this.returnPeriod,
    this.returnPeriodType,
    this.numberOfReturn,
    this.minimumInvest,
    this.maximumInvest,
    this.fixedInvest,
    this.thumbnailImage,
    this.images,
    this.startDate,
    this.expiryDate,
    this.amountHasFixed,
    this.projectDurationHasUnlimited,
    this.numberOfReturnHasUnlimited,
    this.status,
    this.availableUnits,
    this.maturity,
    this.capitalBack,
    this.investLastDate,
    this.createdAt,
    this.updatedAt,
    this.details,
    this.baseCurrency,
    this.currencySymbol,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        location: json["location"],
        totalUnits: json["total_units"].toString(),
        projectDuration: json["project_duration"],
        projectDurationType: json["project_duration_type"],
        datumReturn: json["return"],
        datumReturnMin: json["return_minimum"],
        datumReturnMax: json["return_maximum"],
        returnType: json["return_type"],
        returnPeriod: json["return_period"],
        returnPeriodType: json["return_period_type"],
        numberOfReturn: json["number_of_return"],
        minimumInvest: json["minimum_invest"],
        maximumInvest: json["maximum_invest"],
        fixedInvest: json["fixed_invest"],
        thumbnailImage: json["thumbnail_image"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        expiryDate: json["expiry_date"] == null
            ? null
            : DateTime.parse(json["expiry_date"]),
        amountHasFixed: json["amount_has_fixed"],
        projectDurationHasUnlimited: json["project_duration_has_unlimited"],
        numberOfReturnHasUnlimited: json["number_of_return_has_unlimited"],
        status: json["status"],
        availableUnits: json["available_units"],
        maturity: json["maturity"],
        capitalBack: json["capital_back"],
        investLastDate: json["invest_last_date"] == null
            ? null
            : DateTime.parse(json["invest_last_date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
        baseCurrency: json["base_currency"],
        currencySymbol: json["currency_symbol"],
      );
}

class Details {
  dynamic id;
  dynamic projectId;
  dynamic languageId;
  dynamic title;
  dynamic slug;
  dynamic shortDescription;
  dynamic description;
  dynamic createdAt;
  dynamic updatedAt;

  Details({
    this.id,
    this.projectId,
    this.languageId,
    this.title,
    this.slug,
    this.shortDescription,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
        projectId: json["project_id"],
        languageId: json["language_id"],
        title: json["title"],
        slug: json["slug"],
        shortDescription: json["short_description"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );
}
