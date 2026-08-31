CREATE TABLE public.news
(
    id               bigserial NOT NULL,
    article_id       varchar   NOT NULL,
    link             varchar   NOT NULL,
    title            varchar   NOT NULL,
    description      varchar NULL,
    image_url        varchar NULL,
    publication_date timestamp NOT NULL,
    source_name      varchar   NOT NULL,
    source_icon      varchar   NOT NULL,
    CONSTRAINT news_pk PRIMARY KEY (id),
    CONSTRAINT article_id_unique UNIQUE (article_id)
);

CREATE TABLE public.news_countries
(
    id      bigserial NOT NULL,
    news_id int8      NOT NULL,
    country varchar   NOT NULL,
    CONSTRAINT news_countries_pk PRIMARY KEY (id),
    CONSTRAINT news_countries_unique UNIQUE (news_id, country),
    CONSTRAINT news_countries_fk FOREIGN KEY (news_id) REFERENCES public.news (id)
);

CREATE TABLE public.news_categories
(
    id       bigserial NOT NULL,
    news_id  int8      NOT NULL,
    category varchar   NOT NULL,
    CONSTRAINT news_categories_pk PRIMARY KEY (id),
    CONSTRAINT news_categories_unique UNIQUE (news_id, category),
    CONSTRAINT news_categories_fk FOREIGN KEY (news_id) REFERENCES public.news (id)
);

CREATE TABLE public.news_keywords
(
    id      bigserial NOT NULL,
    news_id int8      NOT NULL,
    keyword varchar   NOT NULL,
    CONSTRAINT news_keywords_pk PRIMARY KEY (id),
    CONSTRAINT news_keywords_unique UNIQUE (news_id, keyword),
    CONSTRAINT news_keywords_fk FOREIGN KEY (news_id) REFERENCES public.news (id)
);