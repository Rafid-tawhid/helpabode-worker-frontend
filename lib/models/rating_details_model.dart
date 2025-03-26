class RatingDetailsModel {
  num? _ratingCount;
  num? _avgRating;
  num? _ratingCountBelowFour;
  num? _star5RatingPonum;
  num? _star5RatingCount;
  num? _star4RatingPonum;
  num? _star4RatingCount;
  num? _star3RatingPonum;
  num? _star3RatingCount;
  num? _star2RatingPonum;
  num? _star2RatingCount;
  num? _star1RatingPonum;
  num? _star1RatingCount;
  num? _totalLike;
  num? _serviceDislike;
  String? _ratingLastUpdateDate;

  RatingDetailsModel(
      {num? ratingCount,
        num? avgRating,
        num? ratingCountBelowFour,
        num? star5RatingPonum,
        num? star5RatingCount,
        num? star4RatingPonum,
        num? star4RatingCount,
        num? star3RatingPonum,
        num? star3RatingCount,
        num? star2RatingPonum,
        num? star2RatingCount,
        num? star1RatingPonum,
        num? star1RatingCount,
        num? totalLike,
        num? serviceDislike,
        String? ratingLastUpdateDate}) {
    _ratingCount = ratingCount;
    _avgRating = avgRating;
    _ratingCountBelowFour = ratingCountBelowFour;
    _star5RatingPonum = star5RatingPonum;
    _star5RatingCount = star5RatingCount;
    _star4RatingPonum = star4RatingPonum;
    _star4RatingCount = star4RatingCount;
    _star3RatingPonum = star3RatingPonum;
    _star3RatingCount = star3RatingCount;
    _star2RatingPonum = star2RatingPonum;
    _star2RatingCount = star2RatingCount;
    _star1RatingPonum = star1RatingPonum;
    _star1RatingCount = star1RatingCount;
    _totalLike = totalLike;
    _serviceDislike = serviceDislike;
    _ratingLastUpdateDate = ratingLastUpdateDate;
  }

  num? get ratingCount => _ratingCount;
  set ratingCount(num? ratingCount) => _ratingCount = ratingCount;
  num? get avgRating => _avgRating;
  set avgRating(num? avgRating) => _avgRating = avgRating;
  num? get ratingCountBelowFour => _ratingCountBelowFour;
  set ratingCountBelowFour(num? ratingCountBelowFour) =>
      _ratingCountBelowFour = ratingCountBelowFour;
  num? get star5RatingPonum => _star5RatingPonum;
  set star5RatingPonum(num? star5RatingPonum) =>
      _star5RatingPonum = star5RatingPonum;
  num? get star5RatingCount => _star5RatingCount;
  set star5RatingCount(num? star5RatingCount) =>
      _star5RatingCount = star5RatingCount;
  num? get star4RatingPonum => _star4RatingPonum;
  set star4RatingPonum(num? star4RatingPonum) =>
      _star4RatingPonum = star4RatingPonum;
  num? get star4RatingCount => _star4RatingCount;
  set star4RatingCount(num? star4RatingCount) =>
      _star4RatingCount = star4RatingCount;
  num? get star3RatingPonum => _star3RatingPonum;
  set star3RatingPonum(num? star3RatingPonum) =>
      _star3RatingPonum = star3RatingPonum;
  num? get star3RatingCount => _star3RatingCount;
  set star3RatingCount(num? star3RatingCount) =>
      _star3RatingCount = star3RatingCount;
  num? get star2RatingPonum => _star2RatingPonum;
  set star2RatingPonum(num? star2RatingPonum) =>
      _star2RatingPonum = star2RatingPonum;
  num? get star2RatingCount => _star2RatingCount;
  set star2RatingCount(num? star2RatingCount) =>
      _star2RatingCount = star2RatingCount;
  num? get star1RatingPonum => _star1RatingPonum;
  set star1RatingPonum(num? star1RatingPonum) =>
      _star1RatingPonum = star1RatingPonum;
  num? get star1RatingCount => _star1RatingCount;
  set star1RatingCount(num? star1RatingCount) =>
      _star1RatingCount = star1RatingCount;
  num? get totalLike => _totalLike;
  set totalLike(num? totalLike) => _totalLike = totalLike;
  num? get serviceDislike => _serviceDislike;
  set serviceDislike(num? serviceDislike) => _serviceDislike = serviceDislike;
  String? get ratingLastUpdateDate => _ratingLastUpdateDate;
  set ratingLastUpdateDate(String? date) => _ratingLastUpdateDate = date;

  RatingDetailsModel.fromJson(Map<String, dynamic> json) {
    _ratingCount = json['rating_count'];
    _avgRating = json['avg_rating'];
    _ratingCountBelowFour = json['rating_count_below_four'];
    _star5RatingPonum = json['star5_rating_ponum'];
    _star5RatingCount = json['star5_rating_count'];
    _star4RatingPonum = json['star4_rating_ponum'];
    _star4RatingCount = json['star4_rating_count'];
    _star3RatingPonum = json['star3_rating_ponum'];
    _star3RatingCount = json['star3_rating_count'];
    _star2RatingPonum = json['star2_rating_ponum'];
    _star2RatingCount = json['star2_rating_count'];
    _star1RatingPonum = json['star1_rating_ponum'];
    _star1RatingCount = json['star1_rating_count'];
    _totalLike = json['total_like'];
    _serviceDislike = json['service_dislike'];
    _ratingLastUpdateDate = json['rating_last_update_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['rating_count'] = _ratingCount;
    data['avg_rating'] = _avgRating;
    data['rating_count_below_four'] = _ratingCountBelowFour;
    data['star5_rating_ponum'] = _star5RatingPonum;
    data['star5_rating_count'] = _star5RatingCount;
    data['star4_rating_ponum'] = _star4RatingPonum;
    data['star4_rating_count'] = _star4RatingCount;
    data['star3_rating_ponum'] = _star3RatingPonum;
    data['star3_rating_count'] = _star3RatingCount;
    data['star2_rating_ponum'] = _star2RatingPonum;
    data['star2_rating_count'] = _star2RatingCount;
    data['star1_rating_ponum'] = _star1RatingPonum;
    data['star1_rating_count'] = _star1RatingCount;
    data['total_like'] = _totalLike;
    data['service_dislike'] = _serviceDislike;
    data['rating_last_update_date'] = _ratingLastUpdateDate;
    return data;
  }
}


class UserReviews {
  final String? userName;
  final String? userEmail;
  final String? userImage; // Made nullable since it might be empty
  final String? rating;
  final String? ratingContent;
  final DateTime? ratingDate;

  UserReviews({
    required this.userName,
    required this.userEmail,
    this.userImage, // Nullable field
    required this.rating,
    required this.ratingContent,
    required this.ratingDate,
  });

  // Factory constructor to create an instance from JSON
  factory UserReviews.fromJson(Map<String, dynamic> json) {
    return UserReviews(
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userImage: json['userImage'], // Can be null
      rating: json['rating'].toString(),
      ratingContent: json['ratingContent'] ?? '',
      ratingDate: DateTime.parse(
          json['ratingDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'userImage': userImage,
      'rating': rating,
      'ratingContent': ratingContent,
      'ratingDate': ratingDate!.toIso8601String(),
    };
  }
}
