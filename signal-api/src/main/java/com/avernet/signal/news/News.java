package com.avernet.signal.news;

import java.time.LocalDateTime;
import java.util.List;

public record News(
        Long id,
        String articleId,
        String link,
        String title,
        String description,
        String imageUrl,
        List<String> keywords,
        List<String> categories,
        List<String> countries,
        LocalDateTime publicationDate,
        String sourceName,
        String sourceIcon
) {}
