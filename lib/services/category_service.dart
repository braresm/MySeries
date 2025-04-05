class CategoryService {
  List<int> getCategoriesForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'fun':
        return [18, 35, 80, 10749];
      case 'scared':
        return [27, 53];
      case 'passionate':
        return [9648, 10749];
      case 'intruiged':
        return [27, 878, 9648, 10749];
      case 'excited':
        return [28, 80, 9648, 16];
      case 'angry':
        return [28, 53, 18];
      case 'nostalgic':
        return [9648, 10749];
      case 'sad':
        return [99, 10749, 18];
      case 'adventurous':
        return [28, 12, 878];
      case 'weird':
        return [878, 14, 27];
      case 'frisky':
        return [35, 10749, 18];
      default:
        return [18, 35]; // Default categories
    }
  }
} 