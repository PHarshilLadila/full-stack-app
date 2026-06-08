// lib/features/customer/customer_web/utils/category_style_manager.dart
import 'package:flutter/material.dart';

class CategoryStyleManager {
  // Singleton pattern
  static final CategoryStyleManager _instance =
      CategoryStyleManager._internal();
  factory CategoryStyleManager() => _instance;
  CategoryStyleManager._internal();

  // Complete Categories Map with Icons, Colors & Backgrounds
  static const Map<String, CategoryStyleData> _categoryStyles = {
    // ==================== FASHION & APPAREL ====================
    "women's fashion": CategoryStyleData(
      icon: Icons.female,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "men's fashion": CategoryStyleData(
      icon: Icons.man,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "kid's fashion": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "baby fashion": CategoryStyleData(
      icon: Icons.baby_changing_station,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "women's clothing": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "men's clothing": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "girls clothing": CategoryStyleData(
      icon: Icons.female,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "boys clothing": CategoryStyleData(
      icon: Icons.man,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "ethnic wear": CategoryStyleData(
      icon: Icons.style,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "western wear": CategoryStyleData(
      icon: Icons.style,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "traditional wear": CategoryStyleData(
      icon: Icons.celebration,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "sarees": CategoryStyleData(
      icon: Icons.style,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "lehenga": CategoryStyleData(
      icon: Icons.style,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "salwar suit": CategoryStyleData(
      icon: Icons.style,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "kurti": CategoryStyleData(
      icon: Icons.style,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "shirts": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "t-shirts": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "jeans": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "trousers": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF607D8B,
      backgroundColor: 0xFFECEFF1,
    ),
    "shorts": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "jackets": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "coats": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "blazers": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "sweaters": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "hoodies": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "sweatshirts": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF607D8B,
      backgroundColor: 0xFFECEFF1,
    ),
    "leather jackets": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF3E2723,
      backgroundColor: 0xFFEFEBE9,
    ),
    "denim jackets": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "party wear": CategoryStyleData(
      icon: Icons.celebration,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "formal wear": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "casual wear": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "sports wear": CategoryStyleData(
      icon: Icons.sports,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "active wear": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "gym wear": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "yoga wear": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "sleepwear": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "lingerie": CategoryStyleData(
      icon: Icons.favorite,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "innerwear": CategoryStyleData(
      icon: Icons.checkroom,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "swimwear": CategoryStyleData(
      icon: Icons.beach_access,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "bikinis": CategoryStyleData(
      icon: Icons.beach_access,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "maternity wear": CategoryStyleData(
      icon: Icons.pregnant_woman,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "plus size": CategoryStyleData(
      icon: Icons.accessibility_new,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "big & tall": CategoryStyleData(
      icon: Icons.accessibility_new,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "petite": CategoryStyleData(
      icon: Icons.accessibility_new,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),

    // ==================== FOOTWEAR ====================
    "footwear": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "men's footwear": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "women's footwear": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "kid's footwear": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "sports shoes": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "running shoes": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "walking shoes": CategoryStyleData(
      icon: Icons.directions_walk,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "training shoes": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "casual shoes": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "formal shoes": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "loafers": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "oxfords": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "derbys": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "monks": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "sandals": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "flip flops": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "slippers": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "sneakers": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "boots": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "ankle boots": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "knee high boots": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "winter boots": CategoryStyleData(
      icon: Icons.ac_unit,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "hiking shoes": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "trekking shoes": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "climbing shoes": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "cycling shoes": CategoryStyleData(
      icon: Icons.directions_bike,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "golf shoes": CategoryStyleData(
      icon: Icons.golf_course,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "dance shoes": CategoryStyleData(
      icon: Icons.music_note,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "heels": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "pumps": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "wedges": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "flats": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "ballerinas": CategoryStyleData(
      icon: Icons.shopping_bag,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "school shoes": CategoryStyleData(
      icon: Icons.school,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),

    // ==================== ACCESSORIES ====================
    "accessories": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "jewellery": CategoryStyleData(
      icon: Icons.diamond,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "women's jewellery": CategoryStyleData(
      icon: Icons.diamond,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "men's jewellery": CategoryStyleData(
      icon: Icons.diamond,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "kid's jewellery": CategoryStyleData(
      icon: Icons.diamond,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "rings": CategoryStyleData(
      icon: Icons.circle,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "engagement rings": CategoryStyleData(
      icon: Icons.circle,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "wedding rings": CategoryStyleData(
      icon: Icons.circle,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "promise rings": CategoryStyleData(
      icon: Icons.favorite,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "necklaces": CategoryStyleData(
      icon: Icons.straighten,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "pendants": CategoryStyleData(
      icon: Icons.straighten,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "chains": CategoryStyleData(
      icon: Icons.straighten,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "earrings": CategoryStyleData(
      icon: Icons.circle_outlined,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "studs": CategoryStyleData(
      icon: Icons.circle_outlined,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "hoops": CategoryStyleData(
      icon: Icons.circle_outlined,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "drops": CategoryStyleData(
      icon: Icons.circle_outlined,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "chandeliers": CategoryStyleData(
      icon: Icons.circle_outlined,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "bracelets": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "bangles": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "anklets": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "watches": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFF607D8B,
      backgroundColor: 0xFFECEFF1,
    ),
    "smart watches": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "luxury watches": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "sports watches": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "bags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "handbags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "tote bags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "backpacks": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "clutches": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "shoulder bags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "crossbody bags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "sling bags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "wallets": CategoryStyleData(
      icon: Icons.account_balance_wallet,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "belts": CategoryStyleData(
      icon: Icons.timeline,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "sunglasses": CategoryStyleData(
      icon: Icons.sunny,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "eyeglasses": CategoryStyleData(
      icon: Icons.visibility,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "caps & hats": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "scarves": CategoryStyleData(
      icon: Icons.straighten,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "ties": CategoryStyleData(
      icon: Icons.straighten,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "gloves": CategoryStyleData(
      icon: Icons.ac_unit,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "umbrellas": CategoryStyleData(
      icon: Icons.beach_access,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "keychains": CategoryStyleData(
      icon: Icons.vpn_key,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "phone cases": CategoryStyleData(
      icon: Icons.phone_android,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),

    // ==================== BEAUTY & PERSONAL CARE ====================
    "beauty & personal care": CategoryStyleData(
      icon: Icons.spa,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "skincare": CategoryStyleData(
      icon: Icons.spa,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5F9,
    ),
    "face care": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5F9,
    ),
    "body care": CategoryStyleData(
      icon: Icons.spa,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "eye care": CategoryStyleData(
      icon: Icons.visibility,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "lip care": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "hand care": CategoryStyleData(
      icon: Icons.pan_tool,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "foot care": CategoryStyleData(
      icon: Icons.airline_seat_flat,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "makeup": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "foundation": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFD7CCC8,
      backgroundColor: 0xFFEFEBE9,
    ),
    "concealer": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFD7CCC8,
      backgroundColor: 0xFFEFEBE9,
    ),
    "powder": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFD7CCC8,
      backgroundColor: 0xFFEFEBE9,
    ),
    "blush": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "highlighter": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFFD700,
      backgroundColor: 0xFFFFF8E1,
    ),
    "contour": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "eyeshadow": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "eyeliner": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "kajal": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "mascara": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "eyebrow": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "lipstick": CategoryStyleData(
      icon: Icons.brush,
      color: 0xE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "lip gloss": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "lip liner": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "lip balm": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "nail care": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "nail polish": CategoryStyleData(
      icon: Icons.brush,
      color: 0xE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "nail art": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "hair care": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF8D6E63,
      backgroundColor: 0xFFEFEBE9,
    ),
    "shampoo": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "conditioner": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "hair oil": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "hair serum": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "hair spray": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "hair color": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "hair styling": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "hair tools": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "hair dryer": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "straightener": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "curler": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "fragrances": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "perfumes": CategoryStyleData(
      icon: Icons.air,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "men's perfumes": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "women's perfumes": CategoryStyleData(
      icon: Icons.air,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "unisex perfumes": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "eau de parfum": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "eau de toilette": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "body spray": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "deodorants": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "attar": CategoryStyleData(
      icon: Icons.air,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "bath & body": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "body lotion": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "body wash": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "body scrub": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "body butter": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "soap": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "hand wash": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "sanitizer": CategoryStyleData(
      icon: Icons.bubble_chart,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "men's grooming": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "shaving": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "razors": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "trimmers": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "beard care": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "beard oil": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "beard wax": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "mustache care": CategoryStyleData(
      icon: Icons.face,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "oral care": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "toothpaste": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "toothbrush": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "mouthwash": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "dental floss": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),

    // ==================== SPORTS & FITNESS ====================
    "sports & fitness": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "cricket": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "cricket bats": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cricket balls": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "cricket gloves": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "cricket pads": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "cricket helmet": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "cricket shoes": CategoryStyleData(
      icon: Icons.sports_cricket,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "badminton": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "badminton rackets": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "shuttlecocks": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "badminton net": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "badminton shoes": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "football": CategoryStyleData(
      icon: Icons.sports_soccer,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "football shoes": CategoryStyleData(
      icon: Icons.sports_soccer,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "football jersey": CategoryStyleData(
      icon: Icons.sports_soccer,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "football gloves": CategoryStyleData(
      icon: Icons.sports_soccer,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "basketball": CategoryStyleData(
      icon: Icons.sports_basketball,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "basketball shoes": CategoryStyleData(
      icon: Icons.sports_basketball,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "basketball jersey": CategoryStyleData(
      icon: Icons.sports_basketball,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "tennis": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "tennis rackets": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "tennis balls": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "tennis shoes": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "volleyball": CategoryStyleData(
      icon: Icons.sports_volleyball,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "table tennis": CategoryStyleData(
      icon: Icons.table_restaurant,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "table tennis racket": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "table tennis balls": CategoryStyleData(
      icon: Icons.sports_tennis,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "hockey": CategoryStyleData(
      icon: Icons.sports_hockey,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "hockey stick": CategoryStyleData(
      icon: Icons.sports_hockey,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "hockey ball": CategoryStyleData(
      icon: Icons.sports_hockey,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "golf": CategoryStyleData(
      icon: Icons.golf_course,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "golf clubs": CategoryStyleData(
      icon: Icons.golf_course,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "golf balls": CategoryStyleData(
      icon: Icons.golf_course,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),

    "gym & fitness": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "gym equipment": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "dumbbells": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "weights": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "resistance bands": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFFE91E63,
      backgroundColor: 0xFFFCE4EC,
    ),
    "yoga mats": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "exercise bikes": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "treadmills": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "yoga": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "yoga blocks": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "yoga straps": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "yoga wheels": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "pilates": CategoryStyleData(
      icon: Icons.self_improvement,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "swimming": CategoryStyleData(
      icon: Icons.pool,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "swimsuits": CategoryStyleData(
      icon: Icons.beach_access,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "swim goggles": CategoryStyleData(
      icon: Icons.pool,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "swim caps": CategoryStyleData(
      icon: Icons.pool,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "fins": CategoryStyleData(
      icon: Icons.pool,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "boxing": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "boxing gloves": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "punching bags": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "hand wraps": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "mma": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "martial arts": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "karate": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "taekwondo": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "judo": CategoryStyleData(
      icon: Icons.sports_mma,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cycling": CategoryStyleData(
      icon: Icons.directions_bike,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "bicycles": CategoryStyleData(
      icon: Icons.directions_bike,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "cycling helmet": CategoryStyleData(
      icon: Icons.directions_bike,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "cycling gloves": CategoryStyleData(
      icon: Icons.directions_bike,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),

    "running": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "running shorts": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "running shirts": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "hydration packs": CategoryStyleData(
      icon: Icons.directions_run,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "walking": CategoryStyleData(
      icon: Icons.directions_walk,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "hiking": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "hiking boots": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "hiking backpacks": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "trekking poles": CategoryStyleData(
      icon: Icons.terrain,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "camping": CategoryStyleData(
      icon: Icons.fireplace,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "tents": CategoryStyleData(
      icon: Icons.cabin,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "sleeping bags": CategoryStyleData(
      icon: Icons.backpack,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "camping chairs": CategoryStyleData(
      icon: Icons.chair,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "fishing": CategoryStyleData(
      icon: Icons.phishing,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "fishing rods": CategoryStyleData(
      icon: Icons.linear_scale,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "fishing reels": CategoryStyleData(
      icon: Icons.circle,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "fishing hooks": CategoryStyleData(
      icon: Icons.anchor,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),

    // ==================== HOME & LIVING ====================
    "home & living": CategoryStyleData(
      icon: Icons.home,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "home & kitchen": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "home accessory": CategoryStyleData(
      icon: Icons.home,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "furniture": CategoryStyleData(
      icon: Icons.chair,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "sofas": CategoryStyleData(
      icon: Icons.chair,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "beds": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "dining tables": CategoryStyleData(
      icon: Icons.table_restaurant,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "chairs": CategoryStyleData(
      icon: Icons.chair,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "wardrobes": CategoryStyleData(
      icon: Icons.dataset,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "bookshelves": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "office furniture": CategoryStyleData(
      icon: Icons.work,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "desks": CategoryStyleData(
      icon: Icons.table_restaurant,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "office chairs": CategoryStyleData(
      icon: Icons.chair,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "kitchen & dining": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cookware": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "pans": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "pots": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "bakeware": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "knives": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "utensils": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "kitchen tools": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "appliances": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "mixers": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "blenders": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "microwaves": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "refrigerators": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "dishwashers": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "ovens": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "stoves": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "cooktops": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "dinnerware": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "plates": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "bowls": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "cups": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "glasses": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "cutlery": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "bedding & bath": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF607D8B,
      backgroundColor: 0xFFECEFF1,
    ),
    "bed sheets": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "pillows": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "blankets": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "comforters": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "quilts": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "duvets": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "mattresses": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "mattress protectors": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "towels": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "bathrobes": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "shower curtains": CategoryStyleData(
      icon: Icons.bed,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "decor": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "wall art": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "paintings": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "wallpapers": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "mirrors": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "clocks": CategoryStyleData(
      icon: Icons.access_time,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "vases": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "planters": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "candles": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "candle holders": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "photo frames": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "rugs": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "carpets": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "curtains": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "blinds": CategoryStyleData(
      icon: Icons.brush,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "lighting": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "ceiling lights": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "floor lamps": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "table lamps": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "wall lights": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),

    "string lights": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "led lights": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "storage & organization": CategoryStyleData(
      icon: Icons.inventory,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "storage boxes": CategoryStyleData(
      icon: Icons.inventory,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "shelves": CategoryStyleData(
      icon: Icons.inventory,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "cabinets": CategoryStyleData(
      icon: Icons.inventory,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "drawers": CategoryStyleData(
      icon: Icons.inventory,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "hangers": CategoryStyleData(
      icon: Icons.inventory,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "laundry": CategoryStyleData(
      icon: Icons.local_laundry_service,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "cleaning supplies": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "brooms": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "mops": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "vacuum cleaners": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "dustbins": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),

    // ==================== ELECTRONICS ====================
    "electronics": CategoryStyleData(
      icon: Icons.electrical_services,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "mobiles & tablets": CategoryStyleData(
      icon: Icons.phone_android,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "smartphones": CategoryStyleData(
      icon: Icons.phone_android,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "tablets": CategoryStyleData(
      icon: Icons.tablet_android,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "mobile accessories": CategoryStyleData(
      icon: Icons.phone_android,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "chargers": CategoryStyleData(
      icon: Icons.phone_android,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "power banks": CategoryStyleData(
      icon: Icons.phone_android,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "earphones": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "headphones": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "bluetooth speakers": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "laptops & computers": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "laptops": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "desktops": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "monitors": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "keyboards": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "mice": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "computer accessories": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "printers": CategoryStyleData(
      icon: Icons.print,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "scanners": CategoryStyleData(
      icon: Icons.print,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "routers": CategoryStyleData(
      icon: Icons.router,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "modems": CategoryStyleData(
      icon: Icons.router,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "audio & headphones": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "earbuds": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "over ear headphones": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "on ear headphones": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "speakers": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "soundbars": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "home theater": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "microphones": CategoryStyleData(
      icon: Icons.mic,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "cameras": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "dslr cameras": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "mirrorless cameras": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "point & shoot": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "camera lenses": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "tripods": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "camera bags": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "action cameras": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "gaming": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "gaming consoles": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "playstation": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "xbox": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "nintendo": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "gaming accessories": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "gaming chairs": CategoryStyleData(
      icon: Icons.chair,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "gaming keyboards": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "gaming mice": CategoryStyleData(
      icon: Icons.computer,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "gaming headsets": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "tv & home theater": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "televisions": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "smart tvs": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "4k tvs": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "oled tvs": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "qled tvs": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "tv mounts": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "projectors": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "projector screens": CategoryStyleData(
      icon: Icons.tv,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "home assistants": CategoryStyleData(
      icon: Icons.mic,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "smart speakers": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "smart home": CategoryStyleData(
      icon: Icons.home_max,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "smart bulbs": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "smart plugs": CategoryStyleData(
      icon: Icons.power,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "smart locks": CategoryStyleData(
      icon: Icons.lock,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "smart cameras": CategoryStyleData(
      icon: Icons.camera_alt,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "doorbells": CategoryStyleData(
      icon: Icons.doorbell,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "wearable technology": CategoryStyleData(
      icon: Icons.watch,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "fitness trackers": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "vr headsets": CategoryStyleData(
      icon: Icons.vrpano,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "drones": CategoryStyleData(
      icon: Icons.flight,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),

    // ==================== AUTOMOBILES ====================
    "automotives": CategoryStyleData(
      icon: Icons.directions_car,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "car accessories": CategoryStyleData(
      icon: Icons.car_repair,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "car care": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "car cleaning": CategoryStyleData(
      icon: Icons.cleaning_services,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "car covers": CategoryStyleData(
      icon: Icons.car_repair,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "car mats": CategoryStyleData(
      icon: Icons.car_repair,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "car lighting": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "car audio": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "car speakers": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "car subwoofers": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "car amplifiers": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "car stereos": CategoryStyleData(
      icon: Icons.speaker,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "bike accessories": CategoryStyleData(
      icon: Icons.motorcycle,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "bike helmets": CategoryStyleData(
      icon: Icons.motorcycle,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "bike gloves": CategoryStyleData(
      icon: Icons.motorcycle,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "bike covers": CategoryStyleData(
      icon: Icons.motorcycle,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "bike lights": CategoryStyleData(
      icon: Icons.lightbulb,
      color: 0xFFFFC107,
      backgroundColor: 0xFFFFF8E1,
    ),
    "spare parts": CategoryStyleData(
      icon: Icons.build,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "tires": CategoryStyleData(
      icon: Icons.build,
      color: 0xFF212121,
      backgroundColor: 0xFFF5F5F5,
    ),
    "batteries": CategoryStyleData(
      icon: Icons.battery_full,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "oil & fluids": CategoryStyleData(
      icon: Icons.build,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "tools": CategoryStyleData(
      icon: Icons.build,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),

    // ==================== BOOKS & STATIONERY ====================
    "books": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "fiction books": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "non fiction books": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "textbooks": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF3F51B5,
      backgroundColor: 0xFFE8EAF6,
    ),
    "comics": CategoryStyleData(
      icon: Icons.book,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "magazines": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "children's books": CategoryStyleData(
      icon: Icons.book,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "audiobooks": CategoryStyleData(
      icon: Icons.headphones,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "ebooks": CategoryStyleData(
      icon: Icons.book,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "office & stationery": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "pens": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "pencils": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "markers": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "highlighters": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0x4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "notebooks": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "paper": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "envelopes": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "folders": CategoryStyleData(
      icon: Icons.folder,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "binders": CategoryStyleData(
      icon: Icons.folder,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "staplers": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "hole punches": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "scissors": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "tape": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "glue": CategoryStyleData(
      icon: Icons.edit_note,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "calculators": CategoryStyleData(
      icon: Icons.calculate,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "school supplies": CategoryStyleData(
      icon: Icons.school,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "lunch boxes": CategoryStyleData(
      icon: Icons.kitchen,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "water bottles": CategoryStyleData(
      icon: Icons.water_drop,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),

    // ==================== TOYS & GAMES ====================
    "toys & games": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "action figures": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "dolls": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "stuffed animals": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "board games": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "puzzles": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "building blocks": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "lego": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "remote control toys": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "educational toys": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "baby toys": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "outdoor toys": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "video games": CategoryStyleData(
      icon: Icons.sports_esports,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "card games": CategoryStyleData(
      icon: Icons.toys,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),

    // ==================== HEALTH & WELLNESS ====================
    "health & wellness": CategoryStyleData(
      icon: Icons.health_and_safety,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "medical supplies": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "first aid": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "bandages": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "masks": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "sanitizers": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "vitamins": CategoryStyleData(
      icon: Icons.health_and_safety,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "supplements": CategoryStyleData(
      icon: Icons.health_and_safety,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "protein powders": CategoryStyleData(
      icon: Icons.fitness_center,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "wellness": CategoryStyleData(
      icon: Icons.spa,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "massagers": CategoryStyleData(
      icon: Icons.spa,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "therapy": CategoryStyleData(
      icon: Icons.spa,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "medical equipment": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "blood pressure monitors": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "thermometers": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "inhalers": CategoryStyleData(
      icon: Icons.medical_services,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "wheelchairs": CategoryStyleData(
      icon: Icons.accessible,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "walkers": CategoryStyleData(
      icon: Icons.accessible,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),

    // ==================== GROCERY ====================
    "grocery": CategoryStyleData(
      icon: Icons.shopping_cart,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "fruits & vegetables": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "fresh fruits": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "fresh vegetables": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "dairy products": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "milk": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "cheese": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "butter": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "yogurt": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "eggs": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "meat": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "seafood": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "poultry": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "bakery": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "bread": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cakes": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "pastries": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF69B4,
      backgroundColor: 0xFFFFE4E1,
    ),
    "snacks": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "chips": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cookies": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "beverages": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "soft drinks": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "juices": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "water": CategoryStyleData(
      icon: Icons.water_drop,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "coffee": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "tea": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "organic food": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF8BC34A,
      backgroundColor: 0xFFF1F8E9,
    ),
    "organic fruits": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF8BC34A,
      backgroundColor: 0xFFF1F8E9,
    ),
    "organic vegetables": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF8BC34A,
      backgroundColor: 0xFFF1F8E9,
    ),
    "organic grains": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF8BC34A,
      backgroundColor: 0xFFF1F8E9,
    ),
    "staples": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "rice": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "wheat": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "flour": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "spices": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF5722,
      backgroundColor: 0xFFFBE9E7,
    ),
    "oils": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "canned goods": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "frozen food": CategoryStyleData(
      icon: Icons.eco,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "baby food": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),

    // ==================== PET SUPPLIES ====================
    "pet supplies": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "dog supplies": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cat supplies": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "bird supplies": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "fish supplies": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "pet food": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "dog food": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "cat food": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "pet toys": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "dog toys": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "cat toys": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "pet accessories": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "collars": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "leashes": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "harnesses": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "pet beds": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "crates": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "carriers": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF9E9E9E,
      backgroundColor: 0xFFF5F5F5,
    ),
    "grooming": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "pet shampoos": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF4CAF50,
      backgroundColor: 0xFFE8F5E9,
    ),
    "brushes": CategoryStyleData(
      icon: Icons.pets,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),

    // ==================== BABY PRODUCTS ====================
    "baby products": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "baby clothing": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF9C27B0,
      backgroundColor: 0xFFF3E5F5,
    ),
    "baby diapers": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "baby wipes": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "baby bottles": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF00BCD4,
      backgroundColor: 0xFFE0F7FA,
    ),
    "baby formula": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "baby strollers": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF2196F3,
      backgroundColor: 0xFFE3F2FD,
    ),
    "baby car seats": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFF44336,
      backgroundColor: 0xFFFFEBEE,
    ),
    "baby cribs": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFF795548,
      backgroundColor: 0xFFEFEBE9,
    ),
    "baby toys (baby products)": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFF9800,
      backgroundColor: 0xFFFFF3E0,
    ),
    "nursing pads": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),
    "breast pumps": CategoryStyleData(
      icon: Icons.child_care,
      color: 0xFFFFFFFF,
      backgroundColor: 0xFFF5F5F5,
    ),

    // ==================== DEFAULT ====================
    "default": CategoryStyleData(
      icon: Icons.category,
      color: 0xFF6B7280,
      backgroundColor: 0xFFF3F4F6,
    ),
  };

  // Get icon for category/subcategory
  IconData getIcon(String categoryName) {
    final key = _normalizeKey(categoryName);
    return _categoryStyles[key]?.icon ?? _categoryStyles['default']!.icon;
  }

  // Get color for category/subcategory
  Color getColor(String categoryName) {
    final key = _normalizeKey(categoryName);
    final colorValue =
        _categoryStyles[key]?.color ?? _categoryStyles['default']!.color;
    return Color(colorValue);
  }

  // Get background color for category/subcategory
  Color getBackgroundColor(String categoryName) {
    final key = _normalizeKey(categoryName);
    final bgColorValue =
        _categoryStyles[key]?.backgroundColor ??
        _categoryStyles['default']!.backgroundColor;
    return Color(bgColorValue);
  }

  // Get all style data at once
  CategoryStyleData getStyleData(String categoryName) {
    final key = _normalizeKey(categoryName);
    return _categoryStyles[key] ?? _categoryStyles['default']!;
  }

  // Normalize string for matching
  String _normalizeKey(String input) {
    return input.trim().toLowerCase();
  }

  // Check if category exists
  bool hasCategory(String categoryName) {
    return _categoryStyles.containsKey(_normalizeKey(categoryName));
  }

  // Get all available category keys (for debugging)
  List<String> getAllCategories() {
    return _categoryStyles.keys.toList();
  }

  // Fuzzy search for category (partial match)
  String? findClosestMatch(String categoryName) {
    final normalized = _normalizeKey(categoryName);

    // Exact match
    if (_categoryStyles.containsKey(normalized)) {
      return normalized;
    }

    // Partial match
    for (final key in _categoryStyles.keys) {
      if (key.contains(normalized) || normalized.contains(key)) {
        return key;
      }
    }

    return null;
  }
}

// Model class for category style data
class CategoryStyleData {
  final IconData icon;
  final int color;
  final int backgroundColor;

  const CategoryStyleData({
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

// Extension for easy use in widgets
extension CategoryStyleExtension on String {
  IconData get categoryIcon => CategoryStyleManager().getIcon(this);
  Color get categoryColor => CategoryStyleManager().getColor(this);
  Color get categoryBackgroundColor =>
      CategoryStyleManager().getBackgroundColor(this);
  CategoryStyleData get categoryStyle =>
      CategoryStyleManager().getStyleData(this);
  bool get hasCategoryStyle => CategoryStyleManager().hasCategory(this);
  String? get closestMatch => CategoryStyleManager().findClosestMatch(this);
}
