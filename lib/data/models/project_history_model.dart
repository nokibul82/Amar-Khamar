

class ProjectHistoryModel {
    List<Datum>? data;

    ProjectHistoryModel({
        this.data,
    });

    factory ProjectHistoryModel.fromJson(Map<String, dynamic> json) => ProjectHistoryModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

}

class Datum {
    dynamic id;
    dynamic userId;
    dynamic projectId;
    dynamic projectTitle;
    dynamic projectSlug;
    dynamic perUnitPrice;
    dynamic unit;
    dynamic datumReturn;
    dynamic numberOfReturn;
    dynamic isLifeTime;
    dynamic returnPeriod;
    dynamic returnPeriodType;
    dynamic nextReturn;
    dynamic capitalBack;
    dynamic projectExpiryDate;
    dynamic status;
    dynamic projectPeriodIsLifetime;
    dynamic lastReturn;
    dynamic totalReturn;
    dynamic trx;
    dynamic createdAt;
    dynamic updatedAt;
    dynamic baseCurrency;
    dynamic currencySymbol;

    Datum({
        this.id,
        this.userId,
        this.projectId,
        this.projectTitle,
        this.projectSlug,
        this.perUnitPrice,
        this.unit,
        this.datumReturn,
        this.numberOfReturn,
        this.isLifeTime,
        this.returnPeriod,
        this.returnPeriodType,
        this.nextReturn,
        this.capitalBack,
        this.projectExpiryDate,
        this.status,
        this.projectPeriodIsLifetime,
        this.lastReturn,
        this.totalReturn,
        this.trx,
        this.createdAt,
        this.updatedAt,
        this.baseCurrency,
        this.currencySymbol,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        projectId: json["project_id"],
        projectTitle: json["project_title"],
        projectSlug: json["project_slug"],
        perUnitPrice: json["per_unit_price"]  ?? "0.00",
        unit: json["unit"]?? "0.00",
        datumReturn: json["return"],
        numberOfReturn: json["number_of_return"].toString(),
        isLifeTime: json["is_life_time"],
        returnPeriod: json["return_period"].toString(),
        returnPeriodType: json["return_period_type"],
        nextReturn: json["next_return"] == null ? null : DateTime.parse(json["next_return"]),
        capitalBack: json["capital_back"],
        projectExpiryDate: json["project_expiry_date"],
        status: json["status"],
        projectPeriodIsLifetime: json["project_period_is_lifetime"],
        lastReturn: json["last_return"],
        totalReturn: json["total_return"],
        trx: json["trx"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        baseCurrency: json["base_currency"],
        currencySymbol: json["currency_symbol"],
    );
}
