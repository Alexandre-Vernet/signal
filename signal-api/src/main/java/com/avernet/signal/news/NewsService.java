package com.avernet.signal.news;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NewsService {

    private final RestClient restClient;

    private final NewsRepository newsRepository;

    private final NewsMapper newsMapper;

    @Value("${newsdata-api-key}")
    private String apiKey;

    @Transactional(readOnly = true)
    public List<News> findAllNews() {
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

        List<News> newsList = newsDataResponse.results()
                .stream().map(this::toNews)
                .toList();

        List<NewsEntity> newsEntity = newsMapper.toEntityList(newsList);
        newsRepository.saveAll(newsEntity);
    }

    private News toNews(NewsDataResult result) {
        return new News(
                null,
                result.article_id(),
                result.link(),
                result.title(),
                result.description(),
                result.image_url(),
                result.keywords(),
                result.category(),
                result.country(),
                result.pubDate(),
                result.source_name(),
                result.source_icon()
        );
    }
}
