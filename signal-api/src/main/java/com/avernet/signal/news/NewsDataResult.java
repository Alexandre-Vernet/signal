package com.avernet.signal.news;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;
import java.util.List;

public record NewsDataResult(
        String article_id,
        String link,
        String title,
        String description,
        String content,
        List<String> keywords,
        List<String> creator,
        String language,
        List<String> country,
        List<String> category,
        String datatype,

        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        LocalDateTime pubDate,

        String pubDateTZ,

        @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        LocalDateTime fetched_at,

        String image_url,
        String video_url,
        String source_name,
        String source_priority,
        String source_url,
        String source_icon,
        Boolean duplicate
) {
}
