package com.avernet.signal.news;

import com.avernet.signal.news.news_categories.NewsCategoriesEntity;
import com.avernet.signal.news.news_countries.NewsCountriesEntity;
import com.avernet.signal.news.news_keywords.NewsKeywordsEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;

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
        List<NewsEntity> newsEntityList = newsRepository.findAll().stream()
                .sorted(Comparator.comparing(NewsEntity::getPublicationDate).reversed())
                .toList();

        return newsMapper.toDtoList(newsEntityList);
    }

    @Transactional(readOnly = true)
    public News getNews(Long id) {
        NewsEntity newsEntity = newsRepository.findById(id).orElseThrow();

        return newsMapper.toDto(newsEntity);
    }

    @Transactional(readOnly = true)
    public ResponseEntity<byte[]> getPublicationImage(Long id) {
        NewsEntity newsEntity = newsRepository.findById(id).orElseThrow();
        RestClient restClient = RestClient.create();

        ResponseEntity<byte[]> response = restClient.get()
                .uri(newsEntity.getImageUrl())
                .retrieve()
                .toEntity(byte[].class);

        return ResponseEntity.ok()
                .contentType(Objects.requireNonNull(response.getHeaders().getContentType()))
                .body(response.getBody());
    }

    @Transactional(readOnly = true)
    public ResponseEntity<byte[]> getSourceIcon(Long id) {
        NewsEntity newsEntity = newsRepository.findById(id).orElseThrow();
        RestClient restClient = RestClient.create();

        ResponseEntity<byte[]> response = restClient.get()
                .uri(newsEntity.getSourceIcon())
                .retrieve()
                .toEntity(byte[].class);

        return ResponseEntity.ok()
                .contentType(Objects.requireNonNull(response.getHeaders().getContentType()))
                .body(response.getBody());
    }

    @Transactional
    public void getLatestNews() {
        NewsDataResponse newsDataResponse = restClient.get()
                .uri(uriBuilder -> uriBuilder
                        .path("/latest")
                        .queryParam("apikey", apiKey)
                        .queryParam("language", "fr")
                        .queryParam("country", "fr")
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

        if (result.keywords() != null && !result.keywords().isEmpty()) {
            List<NewsKeywordsEntity> keywordsList = result.keywords().stream()
                    .map(keyword -> new NewsKeywordsEntity(null, newsEntity, keyword))
                    .toList();
            newsEntity.setKeywords(keywordsList);
        }

        if (result.category() != null && !result.category().isEmpty()) {
            List<NewsCategoriesEntity> categoriesList = result.category().stream()
                    .map(category -> new NewsCategoriesEntity(null, newsEntity, category))
                    .toList();
            newsEntity.setCategories(categoriesList);

        }

        if (result.country() != null && !result.country().isEmpty()) {
            List<NewsCountriesEntity> countriesList = result.country().stream()
                    .map(country -> new NewsCountriesEntity(null, newsEntity, country))
                    .toList();
            newsEntity.setCountries(countriesList);
        }

        return newsEntity;
    }
}
