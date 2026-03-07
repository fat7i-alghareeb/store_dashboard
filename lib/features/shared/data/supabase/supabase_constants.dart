class SupabaseTables {
  static const products = 'products';
  static const banners = 'banners';
  static const categories = 'categories';
  static const colors = 'colors';
  static const offers = 'offers';
  static const productOffers = 'product_offers';
  static const productColors = 'product_colors';
  static const productImages = 'product_images';
  static const productSizes = 'product_sizes';
  static const users = 'users';
  static const productReview = 'product_review';
  static const productReviewPermissions = 'product_review_permissions';
  static const productFavorites = 'product_favorites';
}

class SupabaseColumns {
  static const id = 'id';
  static const createdAt = 'created_at';

  static const title = 'title';
  static const subtitle = 'subtitle';
  static const name = 'name';
  static const colorTitle = 'color_title';
  static const description = 'description';
  static const price = 'price';
  static const categoryId = 'category_id';

  static const colorId = 'color_id';
  static const hexCode = 'hex_code';
  static const displayOrder = 'display_order';
  static const sizeLabel = 'size_label';

  static const imageUrl = 'image_url';
  static const productColorId = 'product_color_id';

  static const isSpecial = 'is_special';
  static const isDeal = 'is_deal';
  static const dealPercent = 'deal_percent';
  static const isTrending = 'is_trending';

  static const discountPercent = 'discount_percent';
  static const validUntil = 'valid_until';
  static const isActive = 'is_active';

  static const userId = 'user_id';
  static const productId = 'product_id';
  static const offerId = 'offer_id';
  static const canRate = 'can_rate';
  static const rating = 'rating';
  static const comment = 'comment';
  static const images = 'images';

  static const email = 'email';
  static const username = 'username';
  static const userImage = 'user_image';
  static const phone = 'phone';
  static const location = 'location';

  static const categoryTitle = 'category_title';
  static const categoryImage = 'image';
}

class SupabaseStorageBuckets {
  static const photo = 'photo';
  static const reviewImages = 'reviews';
  static const photoCategory = 'photocategory';
  static const offers = 'offers';
}

class SupabaseEdge {
  static const superEndpointUrl =
      'https://ynivwhktntkpjnsmsvyg.supabase.co/functions/v1/super-endpoint';
  static const headerContentType = 'Content-Type';
  static const headerAuthorization = 'Authorization';
  static const contentTypeJson = 'application/json';
}
