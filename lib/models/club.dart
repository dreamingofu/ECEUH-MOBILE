import 'package:flutter/material.dart';

class Club {
  const Club({
    required this.name,
    required this.slug,
    required this.description,
    required this.tags,
    required this.icon,
    this.logoAsset,
    this.meetingTime,
    this.location,
    this.contactEmail,
    this.instagramUrl,
    this.discordUrl,
    this.websiteUrl,
  });

  final String name;
  final String slug;
  final String description;
  final IconData icon;
  final String? logoAsset;
  final String? meetingTime;
  final String? location;
  final String? contactEmail;
  final String? instagramUrl;
  final String? discordUrl;
  final String? websiteUrl;
  final List<String> tags;

  bool get hasLinks =>
      instagramUrl != null ||
      discordUrl != null ||
      websiteUrl != null ||
      contactEmail != null;
}
