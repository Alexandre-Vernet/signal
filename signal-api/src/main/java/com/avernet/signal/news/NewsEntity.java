package com.avernet.signal.news;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "news")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NewsEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(name = "article_id", unique = true)
    String articleId;

    String link;

    String title;

    String description;

    @Column(name = "image_url")
    String imageUrl;

    @Column(name = "publication_date")
    LocalDateTime publicationDate;

    @Column(name = "source_name")
    String sourceName;

    @Column(name = "source_icon")
    String sourceIcon;
    
    @OneToMany(mappedBy = "news", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    List<NewsKeywordsEntity> keywords = new ArrayList<>();
}
