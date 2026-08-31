package com.avernet.signal.news;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

@Configuration
@EnableScheduling
@RequiredArgsConstructor
public class NewsJob {

    private final NewsService newsService;

    @Scheduled(cron = "* * 03 * * *")
    private void getLatestNews() {
        newsService.getLatestNews();
    }
}
