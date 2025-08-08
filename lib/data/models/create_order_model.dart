

class CreateOrderModel {
    String? firstName;
    String? lastName;
    int? area;
    String? address;
    String? phone;
    String? email;
    String? city;
    String? couponCode;
    String? paymentMethod;
    String? zip;
    String? additionalInformation;

    CreateOrderModel({
        this.firstName,
        this.lastName,
        this.area,
        this.address,
        this.phone,
        this.email,
        this.city,
        this.couponCode,
        this.paymentMethod,
        this.zip,
        this.additionalInformation,
    });
    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "area": area,
        "address": address,
        "phone": phone,
        "email": email,
        "city": city,
        "coupon_code": couponCode,
        "payment_method": paymentMethod,
        "zip": zip,
        "additional_information": additionalInformation,
    };
}

