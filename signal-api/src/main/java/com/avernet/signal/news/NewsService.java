package com.avernet.signal.news;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NewsService {

    private final RestClient restClient;

    private final NewsRepository newsRepository;

    private final NewsMapper newsMapper;

    @Value("${newsdata-api-key}")
    private String apiKey;

    //    @Transactional(readOnly = true)
    public List<News> findAllNews() {
        getLatestNews();
        List<NewsEntity> newsEntityList = newsRepository.findAll();

        return newsMapper.toDtoList(newsEntityList);
    }

    @Transactional
    public void getLatestNews() {
        NewsDataResponse newsDataResponse = restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/latest")
                        .queryParam("apikey", apiKey)
                        .queryParam("language", "fr")
                        .queryParam("country", "fr")
//                        .queryParam("image", 1)
                        .queryParam("prioritydomain", "top")
                        .build())
                .retrieve()
                .body(NewsDataResponse.class);

        if (newsDataResponse == null || newsDataResponse.results().isEmpty()) {
            return;
        }

        List<NewsEntity> newsEntityList = newsDataResponse.results()
                .stream().map(this::toNewsEntity)
                .toList();

        newsRepository.saveAll(newsEntityList);
    }

    private NewsEntity toNewsEntity(NewsDataResult result) {
        NewsEntity newsEntity = NewsEntity.builder()
                .articleId(result.article_id())
                .link(result.link())
                .title(result.title())
                .description(result.description())
                .imageUrl(result.image_url())
                .publicationDate(result.pubDate())
                .sourceName(result.source_name())
                .sourceIcon(result.source_icon())
                .build();

        List<NewsKeywordsEntity> keywordsList = new ArrayList<>();
        if (result.keywords() != null && !result.keywords().isEmpty()) {
            keywordsList = result.keywords().stream()
                    .map(keyword -> new NewsKeywordsEntity(null, newsEntity, keyword))
                    .toList();
        }

        newsEntity.setKeywords(keywordsList);
        
        return newsEntity;
    }
}
