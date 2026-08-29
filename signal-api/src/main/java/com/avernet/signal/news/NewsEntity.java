package com.avernet.signal.news;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "news")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
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
}
