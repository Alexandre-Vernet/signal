package com.avernet.signal.news;

import java.util.List;

public record NewsDataResponse(
        String status,
        int totalResults,
        List<NewsDataResult> results
) {
}


