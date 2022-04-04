class ProductModel {
  bool? status;
  List<DataProduct>? data;
  String? message;

  ProductModel({this.status, this.data, this.message});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DataProduct>[];
      json['data'].forEach((v) {
        data!.add(new DataProduct.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class DataProduct {
  int? id;
  int? categoryId;
  int? price;
  String? name;
  String? details;
  List<Images>? images;

  DataProduct(
      {this.id,
      this.categoryId,
      this.price,
      this.name,
      this.details,
      this.images});

  DataProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    price = json['price'];
    name = json['name'];
    details = json['details'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['name'] = this.name;
    data['details'] = this.details;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  int? productId;
  String? path;

  Images({this.id, this.productId, this.path});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['path'] = this.path;
    return data;
  }
}
