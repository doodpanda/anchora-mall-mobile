// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    int id;
    String name;
    String price;
    String? discountedPrice;
    String description;
    String thumbnail;
    String category;
    bool isFeatured;
    bool isOfficialStore;
    bool isBlacklisted;
    String user;
    String createdAt;

    ProductEntry({
        required this.id,
        required this.name,
        required this.price,
        this.discountedPrice,
        required this.description,
        required this.thumbnail,
        required this.category,
        required this.isFeatured,
        required this.isOfficialStore,
        required this.isBlacklisted,
        required this.user,
        required this.createdAt,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) {
        // Handle Django serializer format with "pk" and "fields"
        if (json.containsKey("model") && json.containsKey("fields")) {
            final fields = json["fields"];
            return ProductEntry(
                id: json["pk"],
                name: fields["name"],
                price: fields["price"],
                discountedPrice: fields["discounted_price"],
                description: fields["description"],
                thumbnail: fields["thumbnail"] ?? "",
                category: fields["category"],
                isFeatured: fields["is_featured"],
                isOfficialStore: fields["is_official_store"],
                isBlacklisted: fields["is_blacklisted"],
                user: fields["user"].toString(),
                createdAt: fields["created_at"],
            );
        }
        // Handle flat JSON format
        return ProductEntry(
            id: json["id"],
            name: json["name"],
            price: json["price"],
            discountedPrice: json["discounted_price"],
            description: json["description"],
            thumbnail: json["thumbnail"] ?? "",
            category: json["category"],
            isFeatured: json["is_featured"],
            isOfficialStore: json["is_official_store"],
            isBlacklisted: json["is_blacklisted"],
            user: json["user"].toString(),
            createdAt: json["created_at"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "discounted_price": discountedPrice,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "is_featured": isFeatured,
        "is_official_store": isOfficialStore,
        "is_blacklisted": isBlacklisted,
        "user": user,
        "created_at": createdAt,
    };
}
